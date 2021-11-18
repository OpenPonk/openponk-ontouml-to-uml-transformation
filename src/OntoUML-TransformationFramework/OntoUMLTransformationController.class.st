Class {
	#name : #OntoUMLTransformationController,
	#superclass : #Object,
	#instVars : [
		'originalModel',
		'transformedModel',
		'transformedElements'
	],
	#category : #'OntoUML-TransformationFramework-Controllers'
}

{ #category : #transforming }
OntoUMLTransformationController class >> transformModel: aModel [
	| instance |
	instance := self new.
	instance originalModel: aModel packagedElements.
	^ instance transform.
]

{ #category : #accessing }
OntoUMLTransformationController >> addElementToTransformedModel: aElement [
	transformedModel packagedElements add: aElement.
]

{ #category : #accessing }
OntoUMLTransformationController >> addTranformationLinkBetween: aOriginalElement and: aTransformedElement [
	transformedElements add: (aOriginalElement -> aTransformedElement).
]

{ #category : #accessing }
OntoUMLTransformationController >> getTransfomedElementFrom: aOriginalElement [
	^ transformedElements at: aOriginalElement.
]

{ #category : #initialization }
OntoUMLTransformationController >> initialize [
	self initializeTransformedModel.
	transformedElements := Dictionary new.
]

{ #category : #initialization }
OntoUMLTransformationController >> initializeTransformedModel [
	transformedModel := OPUMLPackage new name: 'UML Model'.
]

{ #category : #accessing }
OntoUMLTransformationController >> originalModel [

	^ originalModel
]

{ #category : #accessing }
OntoUMLTransformationController >> originalModel: anObject [

	originalModel := anObject
]

{ #category : #'private - transforming' }
OntoUMLTransformationController >> tranformAssociations [
	(OntoUMLModelQuery getAssociationsFrom: originalModel)
		do: [ :association | OntoUMLAssociationTransformer transform: association withController: self. ].
]

{ #category : #'private - transforming' }
OntoUMLTransformationController >> tranformClasses [
	(OntoUMLModelQuery getEntitiesFrom: originalModel)
		do: [ :entity | OntoUMLClassTransformer transform: entity withController: self. ].
]

{ #category : #'private - transforming' }
OntoUMLTransformationController >> tranformGeneralizationSets [
	| genSets | 
	genSets := OntoUMLModelQuery getGeneralizationSetsFrom: originalModel.
	genSets ifNil: [ ^ self. ].
	OntoUMLGeneralizationSetTransformer savedTransformation: nil.
	genSets do: [ :genSet | 	OntoUMLGeneralizationSetTransformer transform: genSet withController: self. ].
	
]

{ #category : #'private - transforming' }
OntoUMLTransformationController >> tranformGeneralizations [
	| generalizations | 
	generalizations := OntoUMLModelQuery getGeneralizationsWithoutGenSetsFrom: originalModel.
	generalizations ifNil: [ ^ self. ].
	generalizations do: [ :generalization | OntoUMLGeneralizationTransformer transform: generalization withController: self. ].
]

{ #category : #accessing }
OntoUMLTransformationController >> transfomedElements [

	^ transformedElements
]

{ #category : #accessing }
OntoUMLTransformationController >> transfomedElements: anObject [

	transformedElements := anObject
]

{ #category : #transforming }
OntoUMLTransformationController >> transform [
	self tranformClasses.
	self tranformAssociations.
	self tranformGeneralizationSets.
	self tranformGeneralizations.
	^ transformedModel.
]

{ #category : #accessing }
OntoUMLTransformationController >> transformedModel [

	^ transformedModel
]

{ #category : #accessing }
OntoUMLTransformationController >> transformedModel: anObject [

	transformedModel := anObject
]
