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
