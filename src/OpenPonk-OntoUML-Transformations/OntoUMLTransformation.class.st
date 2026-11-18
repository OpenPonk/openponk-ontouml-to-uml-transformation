"
I am the abstract base class for executing specific structural transformations on OntoUML model elements. I hold references to the element being transformed, the orchestrating controller, and the originating transformer.
"
Class {
	#name : 'OntoUMLTransformation',
	#superclass : 'Object',
	#instVars : [
		'transformed',
		'controller',
		'transformer'
	],
	#category : 'OpenPonk-OntoUML-Transformations-Transformations',
	#package : 'OpenPonk-OntoUML-Transformations',
	#tag : 'Transformations'
}

{ #category : 'transforming' }
OntoUMLTransformation class >> newWithTransformed: aTransformed withController: aController withTransformer: aTransformer [
	| instance |
	instance := self new.
	instance transformed: aTransformed;
		controller: aController;
		transformer: aTransformer.
	^ instance.
]

{ #category : 'transforming' }
OntoUMLTransformation class >> transform: aTransformed withController: aController withTransformer: aTransformer [
	^ (self newWithTransformed: aTransformed 
			withController: aController 
				withTransformer: aTransformer)
					transform.
]

{ #category : 'accessing' }
OntoUMLTransformation >> controller [

	^ controller
]

{ #category : 'accessing' }
OntoUMLTransformation >> controller: anObject [

	controller := anObject
]

{ #category : 'transforming' }
OntoUMLTransformation >> copyAttributes: aAttributesCollection for: aEntity [

	^ aAttributesCollection
		  select: [ :attribute | attribute association isNil ]
		  thenCollect: [ :attribute | self copyProperty: attribute for: aEntity ]
]

{ #category : 'transforming' }
OntoUMLTransformation >> copyCommentFrom: aComment [
	^ OPUMLComment new body: aComment body; yourself.
]

{ #category : 'transforming' }
OntoUMLTransformation >> copyCommentsFrom: aOriginalElement to: aTransformedElement [
	aTransformedElement ownedComments: (aOriginalElement ownedComments collect: [ :comment | self copyCommentFrom: comment. ]).
]

{ #category : 'transforming' }
OntoUMLTransformation >> copyMultiplicity: aMultiplicity [

	| copy |
	aMultiplicity ifNil: [ ^ nil ].
	copy := aMultiplicity class new.
	copy
		value: aMultiplicity value;
		visibility: aMultiplicity visibility.
	^ copy
]

{ #category : 'transforming' }
OntoUMLTransformation >> copyOperation: aOperation for: aEntity [

	| copy |
	copy := OPUMLOperation new.
	copy
		name: aOperation name;
		isAbstract: aOperation isAbstract;
		isStatic: aOperation isStatic;
		visibility: aOperation visibility.
	self copyCommentsFrom: aOperation to: copy.
	^ copy
]

{ #category : 'transforming' }
OntoUMLTransformation >> copyOperations: anOperationsCollection for: aEntity [

	^ anOperationsCollection collect: [ :operation | self copyOperation: operation for: aEntity ]
]

{ #category : 'transforming' }
OntoUMLTransformation >> copyProperty: aProperty for: aEntity [

	| copy |
	copy := OPUMLProperty new.
	copy
		name: aProperty name;
		isStatic: aProperty isStatic;
		isReadOnly: aProperty isReadOnly;
		isDerived: aProperty isDerived;
		isOrdered: aProperty isOrdered;
		isUnique: aProperty isUnique;
		lowerValue: (self copyMultiplicity: aProperty lowerValue);
		upperValue: (self copyMultiplicity: aProperty upperValue);
		visibility: aProperty visibility.
	self copyCommentsFrom: aProperty to: copy.
	^ copy
]

{ #category : 'transforming' }
OntoUMLTransformation >> transform [
	^ self subclassResponsibility.
]

{ #category : 'accessing' }
OntoUMLTransformation >> transformed [

	^ transformed
]

{ #category : 'accessing' }
OntoUMLTransformation >> transformed: anObject [

	transformed := anObject
]

{ #category : 'accessing' }
OntoUMLTransformation >> transformer [

	^ transformer
]

{ #category : 'accessing' }
OntoUMLTransformation >> transformer: anObject [

	transformer := anObject
]

{ #category : 'validating' }
OntoUMLTransformation >> validateAssociation: anAssociation [
	(OPUmlAssociationViewModel new
		model: anAssociation) validate
]
