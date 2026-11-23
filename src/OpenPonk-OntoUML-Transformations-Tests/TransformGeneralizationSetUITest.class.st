"
Unit tests verifying generalization set transformation dialog initialization, label formatting, radio button selection, image preview switching, and modal button actions.
"
Class {
	#name : 'TransformGeneralizationSetUITest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-OntoUML-Transformations-Tests-UI',
	#package : 'OpenPonk-OntoUML-Transformations-Tests',
	#tag : 'UI'
}

{ #category : 'utilities' }
TransformGeneralizationSetUITest >> newGeneralizationsWithGeneral: aGeneralClass specifics: aSpecificClasses setName: aSetName [

	| generalizationSet |
	generalizationSet := OPUMLGeneralizationSet new
		                     name: aSetName;
		                     yourself.
	generalizationSet generalizations addAll: (aSpecificClasses collect: [ :specificClass |
				 OPUMLGeneralization new
					 general: aGeneralClass;
					 specific: specificClass;
					 yourself ]).
	^ generalizationSet generalizations
]

{ #category : 'tests' }
TransformGeneralizationSetUITest >> testInitialStateAndLabelsDisplayNamesAndDefaultComposition [

	| generalClass specificClassA specificClassB generalizations presenter |
	generalClass := OPUMLClass new name: 'Person'.
	specificClassA := OPUMLClass new name: 'Student'.
	specificClassB := OPUMLClass new name: 'Employee'.
	generalizations := self
		                   newGeneralizationsWithGeneral: generalClass
		                   specifics: {
				                   specificClassA.
				                   specificClassB }
		                   setName: 'roles'.

	presenter := TransformGeneralizationSetUI on: generalizations.

	self assert: presenter model identicalTo: generalizations.
	self assert: presenter transformation equals: 'Comp'.
	self deny: presenter useForAll description: 'Dialog must default useForAll to false before confirmation'.
	self assert: (presenter instVarNamed: #labelGenSetText) label equals: 'Transformed generalization set: '.
	self assert: (presenter instVarNamed: #labelGenSetValue) label equals: 'roles'.
	self assert: (presenter instVarNamed: #labelGeneralValue) label equals: 'Person'.
	self assert: (presenter instVarNamed: #labelSpecificValue) label equals: 'Student, Employee'.
	self assert: presenter radioComp state description: 'Composition radio button must be selected initially'.
	self deny: presenter radioGen state description: 'Generalization radio button must not be selected initially'.
	self deny: presenter radioGenAndComp state description: 'Combined radio button must not be selected initially'.
	self assert: (presenter diagram image isKindOf: Form) description: 'Diagram preview must render a Form image'.
	self assert: presenter diagram image bits equals: presenter imageComposition bits
]

{ #category : 'tests' }
TransformGeneralizationSetUITest >> testLabelHelpersHandleNilNamesEmptyGeneralizationSetsAndTruncation [

	| nilGeneral nilSpecific namedSpecific nilGeneralizations nilPresenter orphanGeneralization orphanPresenter longSpecifics longGeneralizations longPresenter |
	nilGeneral := OPUMLClass new name: nil.
	nilSpecific := OPUMLClass new name: nil.
	namedSpecific := OPUMLClass new name: 'Student'.
	nilGeneralizations := self
		                      newGeneralizationsWithGeneral: nilGeneral
		                      specifics: {
				                      nilSpecific.
				                      namedSpecific }
		                      setName: nil.

	nilPresenter := TransformGeneralizationSetUI on: nilGeneralizations.
	self assert: nilPresenter getGenSetName equals: 'nameless'.
	self assert: nilPresenter getGeneralName equals: 'nameless'.
	self assert: nilPresenter getSpecificNames equals: 'nameless, Student'.

	orphanGeneralization := OPUMLGeneralization new
		                        general: (OPUMLClass new name: 'Agent');
		                        specific: (OPUMLClass new name: 'Person');
		                        yourself.
	orphanPresenter := TransformGeneralizationSetUI on: { orphanGeneralization }.
	self assert: orphanPresenter getGenSetName equals: 'nameless'.

	longSpecifics := (1 to: 6) collect: [ :index | OPUMLClass new name: 'VeryLongSpecificClassNameNumber' , index asString ].
	longGeneralizations := self
		                       newGeneralizationsWithGeneral: (OPUMLClass new name: 'Entity')
		                       specifics: longSpecifics
		                       setName: 'longSet'.
	longPresenter := TransformGeneralizationSetUI on: longGeneralizations.
	self
		assert: longPresenter getSpecificNames size >= longPresenter maxLength
		description: 'Truncated list must reach maxLength threshold'.
	self deny: (longPresenter getSpecificNames endsWith: ', ') description: 'Truncated list must not end with separator'.
	self
		deny: (longPresenter getSpecificNames includesSubstring: 'Number6')
		description: 'Specifics beyond maxLength must be omitted'
]

{ #category : 'tests' }
TransformGeneralizationSetUITest >> testModalWindowConfigurationAndConfirmButtons [

	| generalizations presenter widget modalWindow buttons confirmButton confirmForAllButton |
	generalizations := self
		                   newGeneralizationsWithGeneral: (OPUMLClass new name: 'Person')
		                   specifics: {
				                   (OPUMLClass new name: 'Student').
				                   (OPUMLClass new name: 'Employee') }
		                   setName: 'roles'.
	presenter := TransformGeneralizationSetUI on: generalizations.
	widget := presenter build.
	self assert: (widget isKindOf: Morph) description: 'Default layout must build a Morph widget'.

	modalWindow := presenter asModalWindow.
	modalWindow build.

	self assert: modalWindow title equals: TransformGeneralizationSetUI title.
	self assert: modalWindow initialExtent equals: 700 @ 600.
	self deny: modalWindow isResizable description: 'Modal dialog window must not be resizable'.
	self deny: (modalWindow instVarNamed: #closeOnBackdropClick) description: 'Modal dialog must disable closing on backdrop click'.

	buttons := modalWindow instVarNamed: #buttons.
	self assertCollection: (buttons collect: #label) hasSameElements: #( 'Confirm' 'Confirm for all' ).
	confirmButton := buttons detect: [ :each | each label = 'Confirm' ].
	confirmForAllButton := buttons detect: [ :each | each label = 'Confirm for all' ].

	confirmForAllButton performAction.
	self assert: presenter useForAll description: 'Confirm for all button must set useForAll to true'.

	confirmButton performAction.
	self deny: presenter useForAll description: 'Confirm button must set useForAll to false'
]

{ #category : 'tests' }
TransformGeneralizationSetUITest >> testRadioButtonsUpdateTransformationAndDiagramImage [

	| generalizations presenter |
	generalizations := self
		                   newGeneralizationsWithGeneral: (OPUMLClass new name: 'Person')
		                   specifics: {
				                   (OPUMLClass new name: 'Student').
				                   (OPUMLClass new name: 'Employee') }
		                   setName: 'roles'.
	presenter := TransformGeneralizationSetUI on: generalizations.

	presenter radioGen state: true.
	self assert: presenter transformation equals: 'Gen'.
	self assert: presenter diagram image bits equals: presenter imageGeneralization bits.

	presenter radioGenAndComp state: true.
	self assert: presenter transformation equals: 'GenAndComp'.
	self assert: presenter diagram image bits equals: presenter imageGeneralizationAndComposition bits.

	presenter radioComp state: true.
	self assert: presenter transformation equals: 'Comp'.
	self assert: presenter diagram image bits equals: presenter imageComposition bits
]
