"
I am a Spec presenter providing UI toolbar menus and entry points to trigger the overall OntoUML to standard UML transformation process.
"
Class {
	#name : 'TransformationUI',
	#superclass : 'SpPresenter',
	#category : 'OpenPonk-OntoUML-Transformations-UI',
	#package : 'OpenPonk-OntoUML-Transformations',
	#tag : 'UI'
}

{ #category : 'layout' }
TransformationUI class >> defaultLayout [
]

{ #category : 'specs' }
TransformationUI class >> toolbarMenu: aBuilder [

	<opEditorToolbarMenu: #OPUmlClassEditorPlugin>
	| appliedProfiles |
	appliedProfiles := aBuilder model diagramController model
		                   profileApplications collect: #appliedProfile.
	(appliedProfiles noneSatisfy: [ :each | each name = 'OntoUML' ]) 
		ifTrue: [ ^ self ].
	self toolbarMenuItemFor: aBuilder
]

{ #category : 'specs' }
TransformationUI class >> toolbarMenuItemFor: aBuilder [

	(aBuilder item: 'Transform to UML')
		icon: OntoUMLIcons ontoumlIcon;
		action: [ 
			self transformToUML: aBuilder model diagramController model ]
]

{ #category : 'specs' }
TransformationUI class >> transformToUML: aModel [

	(OPProject openOnModel:
		 (OntoUMLTransformationController transformModel: aModel))
		showAllElementsInAllDiagrams
]

{ #category : 'initialization' }
TransformationUI >> initializePresenters [
	"We don't need to initialize anything."
]
