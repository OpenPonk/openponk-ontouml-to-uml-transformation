"
A model command that strips OntoUML stereotypes and transforms the ontologically enriched model into a standard UML class model.
"
Class {
	#name : 'OPOntoUMLTransformToUMLCommand',
	#superclass : 'OPModelCommand',
	#category : 'OpenPonk-OntoUML-Transformations-Commands',
	#package : 'OpenPonk-OntoUML-Transformations',
	#tag : 'Commands'
}

{ #category : 'testing' }
OPOntoUMLTransformToUMLCommand class >> canBeExecutedInEditor: anEditor [
	"Answers true if the active editor has the OntoUML profile applied on its UML model."
	^ OntoUMLProfileFactory isAppliedTo: anEditor
]

{ #category : 'activation' }
OPOntoUMLTransformToUMLCommand class >> modelMenuActivation [
	<classAnnotation>
	^ OPModelMenuActivation
		byItemOf: OPModelBasicMenuGroup
		order: 25
		for: OPEditor
]

{ #category : 'accessing' }
OPOntoUMLTransformToUMLCommand >> defaultMenuIcon [
	"Answers the icon form for the transformation command."
	^ OntoUMLIcons ontoumlIcon
]

{ #category : 'accessing' }
OPOntoUMLTransformToUMLCommand >> defaultMenuItemName [
	"Answers the display name of the transformation command."
	^ 'Transform to UML'
]

{ #category : 'execution' }
OPOntoUMLTransformToUMLCommand >> execute [
	"Transforms the active OntoUML model into plain UML."
	TransformationUI transformToUML: self model
]
