"
Unit tests verifying transformation of OntoUML classes into plain UML classes, including attributes, operations, multiplicities, and comments.
"
Class {
	#name : 'OntoUMLTransformClassTest',
	#superclass : 'OntoUMLAbstractTransformationTest',
	#category : 'OpenPonk-OntoUML-Transformations-Tests-Transformations',
	#package : 'OpenPonk-OntoUML-Transformations-Tests',
	#tag : 'Transformations'
}

{ #category : 'tests' }
OntoUMLTransformClassTest >> testTransformCopiesClassAttributesCommentsAndSkipsAssociationEnds [

	| controller sourceClass sourceComment attributeProperty attributeComment lowerBound upperBound associationEnd resultClass copiedProperty |
	controller := OntoUMLTransformationController new.
	sourceClass := OPUMLClass new name: 'Customer'.
	sourceComment := OPUMLComment new body: 'Class note'.
	sourceClass ownedComments: { sourceComment }.

	lowerBound := OPUMLLiteralInteger new value: 0.
	upperBound := OPUMLLiteralUnlimitedNatural new value: 1.
	attributeComment := OPUMLComment new body: 'Attr note'.
	attributeProperty := OPUMLProperty new
		                     name: 'code';
		                     isStatic: true;
		                     isReadOnly: true;
		                     isDerived: true;
		                     isOrdered: true;
		                     isUnique: false;
		                     visibility: OPUMLVisibilityKind private;
		                     lowerValue: lowerBound;
		                     upperValue: upperBound;
		                     owningClass: sourceClass;
		                     yourself.
	attributeProperty ownedComments: { attributeComment }.

	associationEnd := OPUMLProperty new
		                  name: 'navEnd';
		                  owningClass: sourceClass;
		                  association: OPUMLAssociation new;
		                  yourself.

	resultClass := OntoUMLTransformClass
		               transform: sourceClass
		               withController: controller
		               withTransformer: OntoUMLClassTransformer new.

	self assert: resultClass class identicalTo: OPUMLClass.
	self deny: resultClass identicalTo: sourceClass.
	self assert: resultClass name equals: 'Customer'.
	self assert: (controller getTransformedElementFrom: sourceClass) identicalTo: resultClass.
	self assertCollection: controller transformedModel packagedElements hasSameElements: { resultClass }.
	self assert: resultClass ownedComments size equals: 1.
	self assert: resultClass ownedComments first body equals: 'Class note'.
	self deny: resultClass ownedComments first identicalTo: sourceComment.

	self assert: resultClass ownedAttributes size equals: 1.
	copiedProperty := resultClass ownedAttributes first.
	self deny: copiedProperty identicalTo: attributeProperty.
	self assert: copiedProperty name equals: 'code'.
	self assert: copiedProperty owningClass identicalTo: resultClass.
	self assert: copiedProperty isStatic description: 'Transformed attribute must preserve isStatic'.
	self assert: copiedProperty isReadOnly description: 'Transformed attribute must preserve isReadOnly'.
	self assert: copiedProperty isDerived description: 'Transformed attribute must preserve isDerived'.
	self assert: copiedProperty isOrdered description: 'Transformed attribute must preserve isOrdered'.
	self deny: copiedProperty isUnique description: 'Transformed attribute must preserve isUnique = false'.
	self assert: copiedProperty visibility equals: OPUMLVisibilityKind private.
	self assert: copiedProperty lowerValue value equals: 0.
	self assert: copiedProperty upperValue value equals: 1.
	self deny: copiedProperty lowerValue identicalTo: lowerBound.
	self deny: copiedProperty upperValue identicalTo: upperBound.
	self assert: copiedProperty ownedComments size equals: 1.
	self assert: copiedProperty ownedComments first body equals: 'Attr note'.
	self deny: copiedProperty ownedComments first identicalTo: attributeComment
]

{ #category : 'tests' }
OntoUMLTransformClassTest >> testTransformCopiesOperations [

	| controller sourceClass sourceOperation sourceComment resultClass copiedOperation validationWarnings |
	controller := OntoUMLTransformationController new.
	sourceClass := OPUMLClass new name: 'Person'.
	sourceOperation := OPUMLOperation new
		                   name: 'compute';
		                   isAbstract: true;
		                   isStatic: true;
		                   visibility: OPUMLVisibilityKind protected;
		                   owningClass: sourceClass;
		                   yourself.
	sourceComment := OPUMLComment new
		                 body: 'Operation comment';
		                 yourself.
	sourceOperation ownedComments: { sourceComment }.

	resultClass := OntoUMLTransformClass
		               transform: sourceClass
		               withController: controller
		               withTransformer: OntoUMLClassTransformer new.

	self assert: resultClass ownedOperations size equals: 1.
	copiedOperation := resultClass ownedOperations first.
	self deny: copiedOperation identicalTo: sourceOperation.
	self assert: copiedOperation name equals: 'compute'.
	self assert: copiedOperation owningClass identicalTo: resultClass.
	self assert: copiedOperation isAbstract description: 'Transformed operation must preserve isAbstract'.
	self assert: copiedOperation isStatic description: 'Transformed operation must preserve isStatic'.
	self assert: copiedOperation visibility equals: OPUMLVisibilityKind protected.
	self assert: copiedOperation ownedComments size equals: 1.
	self assert: copiedOperation ownedComments first body equals: 'Operation comment'.
	self deny: copiedOperation ownedComments first identicalTo: sourceComment.

	validationWarnings := OrderedCollection new.
	[ (OPUmlOperationViewModel new model: copiedOperation) validate ]
		on: OPModelInvalid
		do: [ :warning |
				validationWarnings add: warning messageText.
				warning resume ].
	self assertEmpty: validationWarnings
]

{ #category : 'tests' }
OntoUMLTransformClassTest >> testTransformHandlesNilAttributeMultiplicities [

	| controller sourceClass attributeProperty resultClass copiedProperty |
	controller := OntoUMLTransformationController new.
	sourceClass := OPUMLClass new name: 'Item'.
	attributeProperty := OPUMLProperty new
		                     name: 'label';
		                     owningClass: sourceClass;
		                     yourself.

	resultClass := OntoUMLTransformClass
		               transform: sourceClass
		               withController: controller
		               withTransformer: OntoUMLClassTransformer new.

	self assert: resultClass ownedAttributes size equals: 1.
	copiedProperty := resultClass ownedAttributes first.
	self assert: copiedProperty lowerValue identicalTo: nil.
	self assert: copiedProperty upperValue identicalTo: nil
]
