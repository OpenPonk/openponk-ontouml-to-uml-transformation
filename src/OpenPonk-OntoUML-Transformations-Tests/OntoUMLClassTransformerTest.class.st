"
Unit tests verifying class transformer strategy dispatch and default UML class transformation.
"
Class {
	#name : 'OntoUMLClassTransformerTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-OntoUML-Transformations-Tests-Transformers',
	#package : 'OpenPonk-OntoUML-Transformations-Tests',
	#tag : 'Transformers'
}

{ #category : 'tests' }
OntoUMLClassTransformerTest >> testControllerAndTransformedAccessors [

	| transformer controller sourceClass |
	transformer := OntoUMLClassTransformer new.
	controller := OntoUMLTransformationController new.
	sourceClass := OPUMLClass new name: 'Entity'.

	transformer
		controller: controller;
		transformed: sourceClass.

	self assert: transformer controller identicalTo: controller.
	self assert: transformer transformed identicalTo: sourceClass
]

{ #category : 'tests' }
OntoUMLClassTransformerTest >> testGetTransformationInitializesIndexAndReturnsDefaultTransformation [

	| kindClass plainClass |
	kindClass := OPUMLClass new
		             name: 'Person';
		             applyStereotype: OntoUMLKind new;
		             yourself.
	plainClass := OPUMLClass new name: 'Plain'.

	OntoUMLClassTransformer instVarNamed: #transformationIndex put: nil.
	[
		self assert: (OntoUMLClassTransformer getTransformation: kindClass) identicalTo: OntoUMLTransformClass.
		self assert: (OntoUMLClassTransformer getTransformation: plainClass) identicalTo: OntoUMLTransformClass ] ensure: [
		OntoUMLClassTransformer initializeTransformationIndex ]
]

{ #category : 'tests' }
OntoUMLClassTransformerTest >> testTransformWithControllerProducesClassInTransformedModel [

	| controller sourceClass resultClass |
	controller := OntoUMLTransformationController new.
	sourceClass := OPUMLClass new
		               name: 'Organization';
		               applyStereotype: OntoUMLKind new;
		               yourself.

	resultClass := OntoUMLClassTransformer transform: sourceClass withController: controller.

	self assert: resultClass class identicalTo: OPUMLClass.
	self assert: resultClass name equals: 'Organization'.
	self assert: (controller getTransformedElementFrom: sourceClass) identicalTo: resultClass.
	self assertCollection: controller transformedModel packagedElements hasSameElements: { resultClass }
]
