Class {
	#name : 'OntoUMLTransformAssociationTest',
	#superclass : 'OntoUMLTransformationTest',
	#category : 'OpenPonk-OntoUML-Transformations-Transformations',
	#package : 'OpenPonk-OntoUML-Transformations',
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
