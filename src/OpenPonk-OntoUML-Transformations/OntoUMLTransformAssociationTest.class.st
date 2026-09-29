"
I am a unit test class verifying the accurate mapping and structural conversion of OntoUML associations into standard UML associations during transformation.
"
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

{ #category : 'tests' }
OntoUMLTransformAssociationTest >> testCreateAssociationValidatesWithoutUiController [
	| controller source target association transformer resultAssociation |
	controller := OntoUMLTransformationController new.
	source := OPUMLClass new name: 'Source'.
	target := OPUMLClass new name: 'Target'.
	controller addTranformationLinkBetween: source and: (OPUMLClass new name: 'Source').
	controller addTranformationLinkBetween: target and: (OPUMLClass new name: 'Target').

	association := self createAssociationFrom: source to: target.
	association name: 'rel'.
	association isDerived: false.

	transformer := OntoUMLTransformAssociation
		newWithTransformed: association
		withController: controller
		withTransformer: OntoUMLAssociationTransformer new.

	resultAssociation := transformer createAssociation.
	self assert: resultAssociation isNotNil.
	self assert: resultAssociation memberEnds size equals: 2
]
