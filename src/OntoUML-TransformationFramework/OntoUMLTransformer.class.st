Class {
	#name : #OntoUMLTransformer,
	#superclass : #Object,
	#instVars : [
		'transformed',
		'controller'
	],
	#classInstVars : [
		'transformationIndex'
	],
	#category : #'OntoUML-TransformationFramework-Transformers'
}

{ #category : #transforming }
OntoUMLTransformer class >> defaultTransformation [
	^ self subclassResponsibility.
]

{ #category : #transforming }
OntoUMLTransformer class >> getTransformation: aSelector [
	transformationIndex ifNil: [ self initializeTransformationIndex ].
	^ transformationIndex at: aSelector ifAbsent: [ self defaultTransformation. ].
]

{ #category : #transforming }
OntoUMLTransformer class >> initializeTransformationIndex [
	^self subclassResponsibility.
]

{ #category : #transforming }
OntoUMLTransformer class >> transform: aTransformed withController: aController [
 	| instance |
	instance := self new.
	instance transformed: aTransformed;
		controller: aController.
	^ instance transform.
]

{ #category : #accessing }
OntoUMLTransformer >> controller [
	^ controller
]

{ #category : #accessing }
OntoUMLTransformer >> controller: anObject [

	controller := anObject
]

{ #category : #transforming }
OntoUMLTransformer >> transform [ 
	^ self subclassResponsibility.
]

{ #category : #accessing }
OntoUMLTransformer >> transformed [

	^ transformed
]

{ #category : #accessing }
OntoUMLTransformer >> transformed: anObject [

	transformed := anObject
]
