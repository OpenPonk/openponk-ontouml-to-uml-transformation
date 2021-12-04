Class {
	#name : #OntoUMLTransformation,
	#superclass : #Object,
	#instVars : [
		'transformed',
		'controller',
		'transformer'
	],
	#category : #'OntoUML-TransformationFramework-Transformations'
}

{ #category : #transforming }
OntoUMLTransformation class >> newWithTransformed: aTransformed withController: aController withTransformer: aTransformer [
	| instance |
	instance := self new.
	instance transformed: aTransformed;
		controller: aController;
		transformer: aTransformer.
	^ instance.
]

{ #category : #transforming }
OntoUMLTransformation class >> transform: aTransformed withController: aController withTransformer: aTransformer [
	^ (self newWithTransformed: aTransformed 
			withController: aController 
				withTransformer: aTransformer)
					transform.
]

{ #category : #accessing }
OntoUMLTransformation >> controller [

	^ controller
]

{ #category : #accessing }
OntoUMLTransformation >> controller: anObject [

	controller := anObject
]

{ #category : #transforming }
OntoUMLTransformation >> copyCommentFrom: aComment [
	^ OPUMLComment new body: aComment body; yourself.
]

{ #category : #transforming }
OntoUMLTransformation >> copyCommentsFrom: aOriginalElement to: aTransformedElement [
	aTransformedElement ownedComments: (aOriginalElement ownedComments collect: [ :comment | self copyCommentFrom: comment. ]).
]

{ #category : #transforming }
OntoUMLTransformation >> transform [
	^ self subclassResponsibility.
]

{ #category : #accessing }
OntoUMLTransformation >> transformed [

	^ transformed
]

{ #category : #accessing }
OntoUMLTransformation >> transformed: anObject [

	transformed := anObject
]

{ #category : #accessing }
OntoUMLTransformation >> transformer [

	^ transformer
]

{ #category : #accessing }
OntoUMLTransformation >> transformer: anObject [

	transformer := anObject
]
