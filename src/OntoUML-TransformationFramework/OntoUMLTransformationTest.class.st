Class {
	#name : 'OntoUMLTransformationTest',
	#superclass : 'TestCase',
	#category : 'OntoUML-TransformationFramework-Transformations',
	#package : 'OntoUML-TransformationFramework',
	#tag : 'Transformations'
}

{ #category : 'utility' }
OntoUMLTransformationTest >> createAssociationFrom: aSource to: aEnd [
	| association |
	association := OPUMLAssociation new.
	OPUMLProperty new
		name: '';
		lowerValue: (OPUMLLiteralInteger new value: 1);
		upperValue: (OPUMLLiteralUnlimitedNatural new value: 1);
		owningAssociation: association;
		type: aSource.
	OPUMLProperty new
		name: '';
		lowerValue: (OPUMLLiteralInteger new value: 1);
		upperValue: (OPUMLLiteralUnlimitedNatural new value: 1);
		owningAssociation: association;
		type: aEnd.
	association memberEnds addAll: association ownedEnds asArray.
	^ association
]

{ #category : 'utility' }
OntoUMLTransformationTest >> createAssociationFrom: aSource to: aEnd with: aStereotype [ 
	| association |
	association := self createAssociationFrom: aSource to: aEnd.
	association applyStereotype: aStereotype.
	^ association.
]

{ #category : 'constants' }
OntoUMLTransformationTest >> getTestedClass [
	^ OntoUMLTransformation.
]

{ #category : 'tests' }
OntoUMLTransformationTest >> testController [
	| tested controller alternativeController | 
	tested := self getTestedClass new.
	controller := OntoUMLTransformationController basicNew.
	alternativeController := OntoUMLTransformationController basicNew.
	tested controller: controller.
	self assert: tested controller equals: controller.
	tested controller: alternativeController.
	self assert: tested controller equals: alternativeController.
	
]

{ #category : 'tests' }
OntoUMLTransformationTest >> testNewWithTransformedWithControllerWithTransformer [
	| testedClass testedInstance controller transformed transformer |
	testedClass :=  self getTestedClass.
	controller := OntoUMLTransformationController basicNew.
	transformed := OPUMLClass new.
	transformer := OntoUMLTransformer basicNew.
	testedInstance := testedClass newWithTransformed: transformed withController: controller withTransformer: transformer.
	self assert: testedInstance class equals: testedClass.
	self assert: testedInstance controller equals: controller.
	self assert: testedInstance transformer equals: transformer.
	self assert: testedInstance transformed equals: transformed. 
]

{ #category : 'tests' }
OntoUMLTransformationTest >> testTransformed [
	| tested transformed alternativeTransformed | 
	tested := self getTestedClass new.
	transformed := OPUMLClass new.
	alternativeTransformed := OPUMLAssociation new.
	tested transformed: transformed.
	self assert: tested transformed equals: transformed.
	tested transformed: alternativeTransformed.
	self assert: tested transformed equals: alternativeTransformed.
	
]

{ #category : 'tests' }
OntoUMLTransformationTest >> testTransformer [
	| tested transformer alternativeTransformer | 
	tested := OntoUMLTransformation new.
	transformer := OntoUMLClassTransformer basicNew.
	alternativeTransformer := OntoUMLAssociationTransformer basicNew.
	tested transformer: transformer.
	self assert: tested transformer equals: transformer.
	tested transformer: alternativeTransformer.
	self assert: tested transformer equals: alternativeTransformer.
	
]
