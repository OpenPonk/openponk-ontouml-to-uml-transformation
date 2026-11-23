"
Unit tests verifying model menu activation, profile applicability, metadata, and execution of the OntoUML-to-UML transformation command.
"
Class {
	#name : 'OPOntoUMLTransformToUMLCommandTest',
	#superclass : 'TestCase',
	#instVars : [
		'projectController',
		'mockWorkbench',
		'toolbarPresenter'
	],
	#category : 'OpenPonk-OntoUML-Transformations-Tests-Commands',
	#package : 'OpenPonk-OntoUML-Transformations-Tests',
	#tag : 'Commands'
}

{ #category : 'private' }
OPOntoUMLTransformToUMLCommandTest >> closeWindowsOpenedAfter: aWindowSnapshot [

	self currentWorld submorphs
		select: [ :eachMorph | eachMorph isSystemWindow and: [ (aWindowSnapshot includes: eachMorph) not ] ]
		thenDo: [ :eachWindow | eachWindow delete ]
]

{ #category : 'private' }
OPOntoUMLTransformToUMLCommandTest >> openEditorWithOntoUmlPackage [

	| umlPlugin umlPackage personClass editor |
	umlPlugin := OPPluginRegistry default plugins detect: [ :eachPlugin | eachPlugin isKindOf: OPUmlClassEditorPlugin ].
	umlPackage := OPUMLPackage new
		              name: 'OntoUmlSource';
		              yourself.
	umlPackage profileApplications add: (OPUMLProfileApplication new
			 appliedProfile: OntoUMLProfileFactory profile;
			 yourself).
	personClass := OPUMLClass new
		               name: 'Person';
		               applyStereotype: OntoUMLKind new;
		               yourself.
	umlPackage packagedElements add: personClass.
	projectController project addModel: umlPackage.
	editor := (OPEditor on: umlPlugin)
		          workbench: mockWorkbench;
		          yourself.
	editor openEmptyModel: umlPackage.
	^ editor
]

{ #category : 'private' }
OPOntoUMLTransformToUMLCommandTest >> openEditorWithPlainUmlPackage [

	| umlPlugin umlPackage editor |
	umlPlugin := OPPluginRegistry default plugins detect: [ :eachPlugin | eachPlugin isKindOf: OPUmlClassEditorPlugin ].
	umlPackage := OPUMLPackage new
		              name: 'PlainUmlSource';
		              yourself.
	projectController project addModel: umlPackage.
	editor := (OPEditor on: umlPlugin)
		          workbench: mockWorkbench;
		          yourself.
	editor openEmptyModel: umlPackage.
	^ editor
]

{ #category : 'running' }
OPOntoUMLTransformToUMLCommandTest >> setUp [

	super setUp.
	projectController := OPProjectController forProject: OPProject new.
	mockWorkbench := Mock new.
	mockWorkbench stub projectController willReturn: projectController.
	mockWorkbench stub workbench willReturn: mockWorkbench.
	mockWorkbench stub announcer willReturn: Announcer new.
	toolbarPresenter := OPWorkbenchToolbar newApplication: SpApplication defaultApplication.
	toolbarPresenter owner: mockWorkbench
]

{ #category : 'running' }
OPOntoUMLTransformToUMLCommandTest >> tearDown [

	OntoUMLGeneralizationSetTransformer savedTransformation: nil.
	toolbarPresenter := nil.
	mockWorkbench := nil.
	projectController := nil.
	super tearDown
]

{ #category : 'tests' }
OPOntoUMLTransformToUMLCommandTest >> testCanBeExecutedInEditorRequiresOntoUmlProfile [

	| ontoUmlEditor plainUmlEditor modelMenuItem ontoUmlMenuNames plainUmlMenuNames |
	ontoUmlEditor := self openEditorWithOntoUmlPackage.
	plainUmlEditor := self openEditorWithPlainUmlPackage.

	self
		assert: (OPOntoUMLTransformToUMLCommand canBeExecutedInEditor: ontoUmlEditor)
		description: 'Command must be enabled for UML editor with OntoUML profile'.
	self
		deny: (OPOntoUMLTransformToUMLCommand canBeExecutedInEditor: plainUmlEditor)
		description: 'Command must not be enabled for UML editor without OntoUML profile'.

	toolbarPresenter focusedEditor: ontoUmlEditor.
	modelMenuItem := toolbarPresenter menu menuGroups first menuItems detect: [ :eachItem | eachItem name = 'Model' ].
	ontoUmlMenuNames := modelMenuItem subMenu menuGroups flatCollect: [ :eachGroup | eachGroup menuItems collect: #name ].
	self assertCollection: ontoUmlMenuNames includesAll: #( 'Transform to UML' ).

	toolbarPresenter focusedEditor: plainUmlEditor.
	modelMenuItem := toolbarPresenter menu menuGroups first menuItems detect: [ :eachItem | eachItem name = 'Model' ].
	plainUmlMenuNames := modelMenuItem subMenu menuGroups flatCollect: [ :eachGroup | eachGroup menuItems collect: #name ].
	self denyCollection: plainUmlMenuNames includesAny: #( 'Transform to UML' )
]

{ #category : 'tests' }
OPOntoUMLTransformToUMLCommandTest >> testCommandMetadataAndMenuActivation [

	| activation command icon |
	activation := OPOntoUMLTransformToUMLCommand modelMenuActivation.
	self assert: activation menuGroup identicalTo: OPModelBasicMenuGroup.
	self assert: activation menuItemOrder equals: 25.

	command := OPOntoUMLTransformToUMLCommand new.
	self assert: command defaultMenuItemName equals: 'Transform to UML'.
	icon := command defaultMenuIcon.
	self assert: (icon isKindOf: Form) description: 'Command icon must answer a Form'.
	self assert: icon bits equals: OntoUMLIcons ontoumlIcon bits
]

{ #category : 'tests' }
OPOntoUMLTransformToUMLCommandTest >> testExecuteOpensWorkbenchOnTransformedModelWithAllElementsShown [

	| ontoUmlEditor windowsBefore workbenchesBefore toolContext command newWindows newWorkbenches openedWorkbench transformedPackage transformedClasses |
	ontoUmlEditor := self openEditorWithOntoUmlPackage.
	windowsBefore := (self currentWorld submorphs select: [ :eachMorph | eachMorph isSystemWindow ]) asIdentitySet.
	workbenchesBefore := OPWorkbench allInstances asIdentitySet.
	[
		toolContext := CmdSimpleToolContext for: ontoUmlEditor.
		command := OPOntoUMLTransformToUMLCommand new.
		command readParametersFromContext: toolContext.
		command prepareFullExecutionInContext: toolContext.
		command execute.

		newWindows := self currentWorld submorphs select: [ :eachMorph |
			              eachMorph isSystemWindow and: [ (windowsBefore includes: eachMorph) not ] ].
		self assert: newWindows size equals: 1.
		newWorkbenches := OPWorkbench allInstances reject: [ :eachWorkbench | workbenchesBefore includes: eachWorkbench ].
		self assert: newWorkbenches size equals: 1.

		openedWorkbench := newWorkbenches first.
		transformedPackage := openedWorkbench projectController project models anyOne.
		self assert: transformedPackage name equals: 'UML Model'.
		transformedClasses := transformedPackage packagedElements select: [ :eachElement | eachElement isKindOf: OPUMLClass ].
		self assertCollection: (transformedClasses collect: #name) hasSameElements: #( 'Person' ).
		self assertEmpty: transformedClasses first appliedStereotypes.
		self assert: openedWorkbench focusedEditor diagramController controllers size equals: 1.
		self
			deny: openedWorkbench projectController undoManager canUndo
			description: 'Showing all elements after transformation must clear undo history' ] ensure: [
		self closeWindowsOpenedAfter: windowsBefore ]
]
