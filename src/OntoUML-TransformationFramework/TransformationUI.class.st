Class {
	#name : #TransformationUI,
	#superclass : #SpPresenter,
	#category : #'OntoUML-TransformationFramework-UI'
}

{ #category : #specs }
TransformationUI class >> defaultSpec [
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

{ #category : #initialization }
TransformationUI >> initializeWidgets [
	"We don't need to initialize anything."
]
