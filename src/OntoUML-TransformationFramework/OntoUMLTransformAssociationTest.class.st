Class {
	#name : 'OntoUMLTransformAssociationTest',
	#superclass : 'OntoUMLTransformationTest',
	#category : 'OntoUML-TransformationFramework-Transformations',
	#package : 'OntoUML-TransformationFramework',
	#tag : 'Transformations'
}

{ #category : 'constants' }
OntoUMLTransformAssociationTest >> getAssociation [
	| source target association |
	source := OPUMLClass new name: 'source'.
	target := OPUMLClass new name: 'target'.
	association := self createAssociationFrom: source to: target.
	^ association. 
]
