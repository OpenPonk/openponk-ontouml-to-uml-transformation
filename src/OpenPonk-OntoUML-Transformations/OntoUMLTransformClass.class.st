Class {
	#name : 'OntoUMLTransformClass',
	#superclass : 'OntoUMLTransformation',
	#category : 'OpenPonk-OntoUML-Transformations-Transformations',
	#package : 'OpenPonk-OntoUML-Transformations',
	#tag : 'Transformations'
}

{ #category : 'transforming' }
OntoUMLTransformClass >> copyAttribute: aAttribute for: aEntity [
	(aAttribute isKindOf: OPUMLProperty) ifTrue: [ ^ self copyProperty: aAttribute for: aEntity. ].
	(aAttribute isKindOf: OPUMLOperation) ifTrue: [ ^ self copyOperation: aAttribute for: aEntity. ].
	^ {}.
]

{ #category : 'transforming' }
OntoUMLTransformClass >> copyAttributes: aAttributesCollection for: aEntity [
	| copy |
	copy := aAttributesCollection copyEmpty.
	copy addAll: (aAttributesCollection flatCollect: [ :attribute | self copyAttribute: attribute for: aEntity]).
	^ copy.
]

{ #category : 'transforming' }
OntoUMLTransformClass >> copyMultiplicity: aMultiplicity [
	| copy |	
	aMultiplicity ifNil: [ ^ nil. ].
	copy := aMultiplicity class new.
	copy value: aMultiplicity value;
		visibility: aMultiplicity visibility.
	^ copy
]

{ #category : 'transforming' }
OntoUMLTransformClass >> copyOperation: aOperation for: aEntity [
	| copy |
	copy := OPUMLOperation new.
	copy name: aOperation name;
		owner: aEntity;
		isAbstract: aOperation isAbstract;
		isStatic: aOperation isStatic;
		visibility: aOperation visibility.
	self copyCommentsFrom: aOperation to: copy. 
	^ { copy. }.
]

{ #category : 'transforming' }
OntoUMLTransformClass >> copyProperty: aProperty for: aEntity [
	| copy |
	aProperty association ifNotNil: [ ^ {}. ].
	copy := OPUMLProperty new.
	copy name: aProperty name;
		owner: aEntity;
		isStatic: aProperty isStatic;
		isReadOnly: aProperty isReadOnly;
		isDerived: aProperty isDerived;
		isOrdered: aProperty isOrdered;
		isUnique: aProperty isUnique;
		lowerValue: (self copyMultiplicity: aProperty lowerValue);
		upperValue: (self copyMultiplicity: aProperty upperValue);		
		visibility: aProperty visibility.
	self copyCommentsFrom: aProperty to: copy. 
	^ { copy. }
]

{ #category : 'transforming' }
OntoUMLTransformClass >> createClassFor: aEntity [
	| createdClass |
	createdClass := OPUMLClass new.	
	createdClass name: aEntity name.
	self copyCommentsFrom: aEntity to: createdClass. 
	createdClass ownedAttributes: (self copyAttributes: aEntity ownedAttributes for: createdClass).
	createdClass ownedOperations addAll: (createdClass ownedAttributes select: [ :att | att isKindOf: OPUMLOperation ]).
	^ createdClass.
]

{ #category : 'transforming' }
OntoUMLTransformClass >> transform [
	| entityClass |
	entityClass := self createClassFor: transformed.
	controller addTranformationLinkBetween: transformed and: entityClass.
	controller addElementToTransformedModel: entityClass.
	^ entityClass.
]
