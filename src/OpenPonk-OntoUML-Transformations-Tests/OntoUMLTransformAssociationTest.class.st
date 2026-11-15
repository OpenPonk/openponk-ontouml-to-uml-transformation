"
I am a unit test class verifying the accurate mapping and structural conversion of OntoUML associations into standard UML associations during transformation.
"
Class {
	#name : 'OntoUMLTransformAssociationTest',
	#superclass : 'OntoUMLTransformationTest',
	#category : 'OpenPonk-OntoUML-Transformations-Tests-Transformations',
	#package : 'OpenPonk-OntoUML-Transformations-Tests',
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

	| controller source target transformedSource transformedTarget association transformer resultAssociation |
	controller := OntoUMLTransformationController new.
	source := OPUMLClass new name: 'Source'.
	target := OPUMLClass new name: 'Target'.
	transformedSource := OPUMLClass new name: 'Source'.
	transformedTarget := OPUMLClass new name: 'Target'.
	controller addTranformationLinkBetween: source and: transformedSource.
	controller addTranformationLinkBetween: target and: transformedTarget.

	association := self createAssociationFrom: source to: target.
	association name: 'rel'.
	association isDerived: false.

	transformer := OntoUMLTransformAssociation
		               newWithTransformed: association
		               withController: controller
		               withTransformer: OntoUMLAssociationTransformer new.

	resultAssociation := transformer createAssociation.
	self assert: resultAssociation class identicalTo: OPUMLAssociation.
	self deny: resultAssociation identicalTo: association.
	self assert: resultAssociation name equals: 'rel'.
	self deny: resultAssociation isDerived description: 'Transformed association must preserve isDerived = false'.
	self assert: resultAssociation memberEnds size equals: 2.
	self assert: resultAssociation memberEnds first type identicalTo: transformedSource.
	self assert: resultAssociation memberEnds second type identicalTo: transformedTarget.
	self assert: resultAssociation memberEnds first owningAssociation identicalTo: resultAssociation.
	self assert: resultAssociation memberEnds second owningAssociation identicalTo: resultAssociation
]
