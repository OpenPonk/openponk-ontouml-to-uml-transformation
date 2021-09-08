Class {
	#name : #OntoUMLTransformClass,
	#superclass : #OntoUMLTransformation,
	#category : #'OntoUML-TransformationFramework-Transformations'
}

{ #category : #transforming }
OntoUMLTransformClass >> copyAttribute: aAttribute for: aEntity [
	| copy |
	aAttribute association ifNotNil: [ ^ {}. ].
	copy := aAttribute class new.
	copy name: aAttribute name;
		owner: aEntity.
	^ { copy. }
]

{ #category : #transforming }
OntoUMLTransformClass >> copyAttributes: aAttributesCollection for: aEntity [
	| copy |
	copy := aAttributesCollection copyEmpty.
	copy addAll: (aAttributesCollection flatCollect: [ :attribute | self copyAttribute: attribute for: aEntity]).
	^ copy.
]

{ #category : #transforming }
OntoUMLTransformClass >> createClassFor: aEntity [
	| createdClass |
	createdClass := OPUMLClass new.	
	createdClass name: aEntity name.
	createdClass ownedAttributes: (self copyAttributes: aEntity ownedAttributes for: createdClass).
	createdClass ownedOperations addAll: (createdClass ownedAttributes select: [ :att | att isKindOf: OPUMLOperation ]).
	^ createdClass.
]

{ #category : #transforming }
OntoUMLTransformClass >> transform [
	| entityClass |
	entityClass := self createClassFor: transformed.
	controller addTranformationLinkBetween: transformed and: entityClass.
	controller addElementToTransformedModel: entityClass.
	^ entityClass.
]
