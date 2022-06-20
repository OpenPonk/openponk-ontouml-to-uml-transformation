Class {
	#name : #TransformationUI,
	#superclass : #SpPresenter,
	#category : #'OntoUML-TransformationFramework-UI'
}

{ #category : #'as yet unclassified' }
TransformationUI class >> defaultLayout [
]

{ #category : #specs }
TransformationUI class >> defaultSpec [

	self flag: 'Pharo 9- compatibility'.
	^ self defaultLayout
]

{ #category : #specs }
TransformationUI class >> toolbarMenu: aBuilder [ 
	<opEditorToolbarMenu: #OPUmlClassEditorPlugin>
	| builder |
	builder := aBuilder model diagramController model profileApplications.
	(builder isEmpty or: [ builder anyOne appliedProfile name ~= 'OntoUML' ])
		ifTrue: [ ^ self ].
	self toolbarMenuItemFor: aBuilder
]

{ #category : #specs }
TransformationUI class >> toolbarMenuItemFor: aBuilder [
	(aBuilder item: 'Transform to UML')
		action: [ self transformToUML: aBuilder model diagramController model ].
]

{ #category : #specs }
TransformationUI class >> transformToUML: aModel [
	OPProject openOnModel: (OntoUMLTransformationController transformModel: aModel).
]

{ #category : #'as yet unclassified' }
TransformationUI >> initializePresenters [
	"We don't need to initialize anything."
]
