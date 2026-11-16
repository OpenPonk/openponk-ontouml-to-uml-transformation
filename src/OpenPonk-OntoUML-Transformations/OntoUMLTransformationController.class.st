"
I orchestrate the transformation of a complete OntoUML model into a standard UML model. I manage the mapping between original and transformed elements and dispatch specific transformers for classes, associations, generalizations, and generalization sets.
"
Class {
	#name : 'OntoUMLTransformationController',
	#superclass : 'Object',
	#instVars : [
		'originalModel',
		'transformedModel',
		'transformedElements'
	],
	#category : 'OpenPonk-OntoUML-Transformations-Controllers',
	#package : 'OpenPonk-OntoUML-Transformations',
	#tag : 'Controllers'
}

{ #category : 'transforming' }
OntoUMLTransformationController class >> transformModel: aModel [
	| instance |
	instance := self new.
	instance originalModel: aModel packagedElements.
	^ instance transform.
]

{ #category : 'accessing' }
OntoUMLTransformationController >> addElementToTransformedModel: aElement [
	transformedModel packagedElements add: aElement.
]

{ #category : 'accessing' }
OntoUMLTransformationController >> addTransformationLinkBetween: aOriginalElement and: aTransformedElement [

	transformedElements add: aOriginalElement -> aTransformedElement
]

{ #category : 'accessing' }
OntoUMLTransformationController >> getTransformedElementFrom: aOriginalElement [

	^ transformedElements at: aOriginalElement
]

{ #category : 'initialization' }
OntoUMLTransformationController >> initialize [

	super initialize.
	self initializeTransformedModel.
	transformedElements := Dictionary new
]

{ #category : 'initialization' }
OntoUMLTransformationController >> initializeTransformedModel [
	transformedModel := OPUMLPackage new name: 'UML Model'.
]

{ #category : 'accessing' }
OntoUMLTransformationController >> originalModel [

	^ originalModel
]

{ #category : 'accessing' }
OntoUMLTransformationController >> originalModel: anObject [

	originalModel := anObject
]

{ #category : 'transforming' }
OntoUMLTransformationController >> transform [

	self transformClasses.
	self transformAssociations.
	self transformGeneralizationSets.
	self transformGeneralizations.
	^ transformedModel
]

{ #category : 'private - transforming' }
OntoUMLTransformationController >> transformAssociations [

	(OntoUMLModelQuery getAssociationsFrom: originalModel) do: [ :association |
		OntoUMLAssociationTransformer transform: association withController: self ]
]

{ #category : 'private - transforming' }
OntoUMLTransformationController >> transformClasses [

	(OntoUMLModelQuery getEntitiesFrom: originalModel) do: [ :entity |
		OntoUMLClassTransformer transform: entity withController: self ]
]

{ #category : 'private - transforming' }
OntoUMLTransformationController >> transformGeneralizationSets [

	| genSets |
	genSets := OntoUMLModelQuery getGeneralizationSetsFrom: originalModel.
	OntoUMLGeneralizationSetTransformer savedTransformation: nil.
	genSets do: [ :genSet | OntoUMLGeneralizationSetTransformer transform: genSet withController: self ]
]

{ #category : 'private - transforming' }
OntoUMLTransformationController >> transformGeneralizations [

	| generalizations |
	generalizations := OntoUMLModelQuery getGeneralizationsWithoutGenSetsFrom: originalModel.
	generalizations do: [ :generalization | OntoUMLGeneralizationTransformer transform: generalization withController: self ]
]

{ #category : 'accessing' }
OntoUMLTransformationController >> transformedElements [

	^ transformedElements
]

{ #category : 'accessing' }
OntoUMLTransformationController >> transformedModel [

	^ transformedModel
]
