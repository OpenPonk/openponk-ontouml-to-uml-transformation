"
I am a unit test class verifying the state initialization and basic mechanics of OntoUML model transformations.
"
Class {
	#name : 'OntoUMLTransformationTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-OntoUML-Transformations-Tests-Transformations',
	#package : 'OpenPonk-OntoUML-Transformations-Tests',
	#tag : 'Transformations'
}

{ #category : 'constants' }
OntoUMLTransformationTest >> getTestedClass [
	^ OntoUMLTransformation.
]

{ #category : 'tests' }
OntoUMLTransformationTest >> testClassTransformWithControllerWithTransformerExecutesConcreteSubclass [

	| controller sourceGeneral transformedGeneral sourceSpecific transformedSpecific generalization resultGeneralization |
	controller := OntoUMLTransformationController new.
	sourceGeneral := OPUMLClass new name: 'Parent'.
	sourceSpecific := OPUMLClass new name: 'Child'.
	transformedGeneral := OPUMLClass new name: 'Parent'.
	transformedSpecific := OPUMLClass new name: 'Child'.
	controller addTransformationLinkBetween: sourceGeneral and: transformedGeneral.
	controller addTransformationLinkBetween: sourceSpecific and: transformedSpecific.
	generalization := OPUMLGeneralization new
		                  general: sourceGeneral;
		                  specific: sourceSpecific;
		                  yourself.

	resultGeneralization := OntoUMLTransformGeneralization
		                        transform: generalization
		                        withController: controller
		                        withTransformer: OntoUMLGeneralizationTransformer new.

	self assert: resultGeneralization class identicalTo: OPUMLGeneralization.
	self assert: resultGeneralization general identicalTo: transformedGeneral.
	self assert: resultGeneralization specific identicalTo: transformedSpecific
]

{ #category : 'tests' }
OntoUMLTransformationTest >> testController [

	| tested controller alternativeController |
	tested := self getTestedClass new.
	controller := OntoUMLTransformationController new.
	alternativeController := OntoUMLTransformationController new.
	tested controller: controller.
	self assert: tested controller identicalTo: controller.
	tested controller: alternativeController.
	self assert: tested controller identicalTo: alternativeController
]

{ #category : 'tests' }
OntoUMLTransformationTest >> testCopyCommentsCopiesBodiesAsDistinctComments [

	| transformation sourceClass targetClass firstComment secondComment |
	transformation := self getTestedClass new.
	sourceClass := OPUMLClass new name: 'Source'.
	firstComment := OPUMLComment new body: 'First note'.
	secondComment := OPUMLComment new body: 'Second note'.
	sourceClass ownedComments: {
			firstComment.
			secondComment }.
	targetClass := OPUMLClass new name: 'Target'.

	transformation copyCommentsFrom: sourceClass to: targetClass.

	self assert: targetClass ownedComments size equals: 2.
	self assert: (targetClass ownedComments collect: #body as: Array) equals: #( 'First note' 'Second note' ).
	self deny: targetClass ownedComments first identicalTo: firstComment.
	self deny: targetClass ownedComments second identicalTo: secondComment
]

{ #category : 'tests' }
OntoUMLTransformationTest >> testNewWithTransformedWithControllerWithTransformer [

	| testedClass testedInstance controller transformed transformer |
	testedClass := self getTestedClass.
	controller := OntoUMLTransformationController new.
	transformed := OPUMLClass new.
	transformer := OntoUMLClassTransformer new.
	testedInstance := testedClass newWithTransformed: transformed withController: controller withTransformer: transformer.
	self assert: testedInstance class identicalTo: testedClass.
	self assert: testedInstance controller identicalTo: controller.
	self assert: testedInstance transformer identicalTo: transformer.
	self assert: testedInstance transformed identicalTo: transformed
]

{ #category : 'tests' }
OntoUMLTransformationTest >> testTransformed [

	| tested transformed alternativeTransformed |
	tested := self getTestedClass new.
	transformed := OPUMLClass new.
	alternativeTransformed := OPUMLAssociation new.
	tested transformed: transformed.
	self assert: tested transformed identicalTo: transformed.
	tested transformed: alternativeTransformed.
	self assert: tested transformed identicalTo: alternativeTransformed
]

{ #category : 'tests' }
OntoUMLTransformationTest >> testTransformer [

	| tested transformer alternativeTransformer |
	tested := self getTestedClass new.
	transformer := OntoUMLClassTransformer new.
	alternativeTransformer := OntoUMLAssociationTransformer new.
	tested transformer: transformer.
	self assert: tested transformer identicalTo: transformer.
	tested transformer: alternativeTransformer.
	self assert: tested transformer identicalTo: alternativeTransformer
]
