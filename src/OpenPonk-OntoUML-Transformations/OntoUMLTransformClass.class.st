"
I execute the transformation of an OntoUML stereotyped class into a standard UML class, mapping attributes, operations, and property constraints.
"
Class {
	#name : 'OntoUMLTransformClass',
	#superclass : 'OntoUMLTransformation',
	#category : 'OpenPonk-OntoUML-Transformations-Transformations',
	#package : 'OpenPonk-OntoUML-Transformations',
	#tag : 'Transformations'
}

{ #category : 'transforming' }
OntoUMLTransformClass >> copyAttributes: aAttributesCollection for: aEntity [

	^ aAttributesCollection
		  select: [ :attribute | attribute association isNil ]
		  thenCollect: [ :attribute | self copyProperty: attribute for: aEntity ]
]

{ #category : 'transforming' }
OntoUMLTransformClass >> copyOperation: aOperation for: aEntity [

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
OntoUMLTransformClass >> copyOperations: anOperationsCollection for: aEntity [

	^ anOperationsCollection collect: [ :operation | self copyOperation: operation for: aEntity ]
]

{ #category : 'transforming' }
OntoUMLTransformClass >> copyProperty: aProperty for: aEntity [

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
OntoUMLTransformClass >> createClassFor: aEntity [

	| createdClass |
	createdClass := OPUMLClass new.
	createdClass name: aEntity name.
	self copyCommentsFrom: aEntity to: createdClass.
	createdClass ownedAttributes: (self copyAttributes: aEntity ownedAttributes for: createdClass).
	createdClass ownedOperations: (self copyOperations: aEntity ownedOperations for: createdClass).
	^ createdClass
]

{ #category : 'transforming' }
OntoUMLTransformClass >> transform [

	| entityClass |
	entityClass := self createClassFor: transformed.
	controller addTransformationLinkBetween: transformed and: entityClass.
	controller addElementToTransformedModel: entityClass.
	^ entityClass
]
