"
Unit tests verifying association transformer strategy selection, self-association filtering, and delegation.
"
Class {
	#name : 'OntoUMLAssociationTransformerTest',
	#superclass : 'OntoUMLAbstractTransformationTest',
	#category : 'OpenPonk-OntoUML-Transformations-Tests-Transformers',
	#package : 'OpenPonk-OntoUML-Transformations-Tests',
	#tag : 'Transformers'
}

{ #category : 'tests' }
OntoUMLAssociationTransformerTest >> testGetTransformationReturnsSubQuantityOfAndDefault [

	| sourceClass targetClass regularAssociation subQuantityAssociation |
	sourceClass := OPUMLClass new name: 'A'.
	targetClass := OPUMLClass new name: 'B'.
	regularAssociation := self createAssociationFrom: sourceClass to: targetClass with: OntoUMLMediation new.
	subQuantityAssociation := self createAssociationFrom: sourceClass to: targetClass with: OntoUMLSubQuantityOf new.

	OntoUMLAssociationTransformer instVarNamed: #transformationIndex put: nil.
	[
		self
			assert: (OntoUMLAssociationTransformer getTransformation: subQuantityAssociation)
			identicalTo: OntoUMLTransformSubQuantityOf.
		self assert: (OntoUMLAssociationTransformer getTransformation: regularAssociation) identicalTo: OntoUMLTransformAssociation ]
		ensure: [ OntoUMLAssociationTransformer initializeTransformationIndex ]
]

{ #category : 'tests' }
OntoUMLAssociationTransformerTest >> testTransformDelegatesForDistinctEndpoints [

	| controller sourceClass targetClass transformedSource transformedTarget association result |
	controller := OntoUMLTransformationController new.
	sourceClass := OPUMLClass new name: 'Relator'.
	targetClass := OPUMLClass new name: 'Role'.
	transformedSource := OPUMLClass new name: 'Relator'.
	transformedTarget := OPUMLClass new name: 'Role'.
	controller addTransformationLinkBetween: sourceClass and: transformedSource.
	controller addTransformationLinkBetween: targetClass and: transformedTarget.
	association := self createAssociationFrom: sourceClass to: targetClass with: OntoUMLMediation new.
	association name: 'mediates'.

	result := OntoUMLAssociationTransformer transform: association withController: controller.

	self assert: result class identicalTo: OPUMLAssociation.
	self assert: result name equals: 'mediates'.
	self assertCollection: controller transformedModel packagedElements hasSameElements: { result }
]

{ #category : 'tests' }
OntoUMLAssociationTransformerTest >> testTransformSkipsSelfAssociation [

	| controller selfClass selfAssociation result |
	controller := OntoUMLTransformationController new.
	selfClass := OPUMLClass new name: 'Person'.
	selfAssociation := self createAssociationFrom: selfClass to: selfClass.

	result := OntoUMLAssociationTransformer transform: selfAssociation withController: controller.

	self assert: result identicalTo: nil.
	self assertEmpty: controller transformedModel packagedElements
]
