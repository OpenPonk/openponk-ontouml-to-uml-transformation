"
I execute complex refactoring of OntoUML generalization sets. I flatten or restructure class hierarchies using standard generalizations, compositions, or a combination thereof, based on selected user strategies.
"
Class {
	#name : 'OntoUMLTransformGeneralizationSet',
	#superclass : 'OntoUMLTransformation',
	#instVars : [
		'elements',
		'index',
		'combinationSelector'
	],
	#category : 'OpenPonk-OntoUML-Transformations-Transformations',
	#package : 'OpenPonk-OntoUML-Transformations',
	#tag : 'Transformations'
}

{ #category : 'transforming' }
OntoUMLTransformGeneralizationSet class >> transformAsComposition: aTransformed withController: aController withTransformer: aTransformer [
	| instance |
	instance := self newWithTransformed: aTransformed withController: aController withTransformer: aTransformer.
	^ instance transformAsComposition.
]

{ #category : 'transforming' }
OntoUMLTransformGeneralizationSet class >> transformWithoutCombination: aTransformed withController: aController withTransformer: aTransformer [
	| instance |
	instance := self newWithTransformed: aTransformed withController: aController withTransformer: aTransformer.
	^ instance transformDisjointGeneralization.
]

{ #category : 'private - transforming - generalization' }
OntoUMLTransformGeneralizationSet >> calculateIndex: aIndex for: aElementPosition [
	| positionOffset |
	positionOffset := 2 raisedTo: (aElementPosition - 1).
	(aIndex bitAnd: positionOffset) > 0 
		ifTrue: [ ^ 1. ] 
		ifFalse: [ ^ 0. ].
]

{ #category : 'private - transforming - generalization' }
OntoUMLTransformGeneralizationSet >> calculateIndexesFrom: aIndex [
	| sumOfIndexes |
	sumOfIndexes := 0.
	1 to: index size do: [ :i |
		index at: i put: (self calculateIndex: aIndex for: i).
		sumOfIndexes := sumOfIndexes + (index at: i). ].
	^ sumOfIndexes.
]

{ #category : 'accessing' }
OntoUMLTransformGeneralizationSet >> combinationSelector [

	^ combinationSelector
]

{ #category : 'accessing' }
OntoUMLTransformGeneralizationSet >> combinationSelector: anObject [

	combinationSelector := anObject
]

{ #category : 'private - transforming - generalization' }
OntoUMLTransformGeneralizationSet >> combineClass: aAddedClass with: aCompositeClass [
	^ self combinationSelector value: aAddedClass value: aCompositeClass.
	
]

{ #category : 'transforming' }
OntoUMLTransformGeneralizationSet >> combineUsingGeneralization: aAddedClass with: aCompositeClass [

	aCompositeClass name: aCompositeClass name , (aAddedClass name ifNil: [ '' ]).
	aCompositeClass ownedAttributes addAll: (self copyAttributes: aAddedClass ownedAttributes for: aCompositeClass).
	aCompositeClass ownedOperations addAll: (self copyOperations: aAddedClass ownedOperations for: aCompositeClass).
	^ #(  )
]

{ #category : 'transforming' }
OntoUMLTransformGeneralizationSet >> combineUsingGeneralizationAndComposition: aAddedClass with: aCompositeClass [

	aCompositeClass name: aCompositeClass name , (aAddedClass name ifNil: [ '' ]).
	^ { (self createCompositionWithSource: (controller getTransformedElementFrom: aAddedClass) withTarget: aCompositeClass) }
]

{ #category : 'private - transforming - generalization' }
OntoUMLTransformGeneralizationSet >> createClassCombination [

	| newClass results compositions |
	results := OrderedCollection new.
	newClass := OPUMLClass new.
	newClass name: ''.
	results add: newClass.
	results add: (self createGeneralizationFor: newClass).
	compositions := (1 to: index size) flatCollect: [ :i |
			                (index at: i) > 0
				                ifTrue: [ self combineClass: (elements at: i) with: newClass ]
				                ifFalse: [ #(  ) ] ].
	results addAll: compositions.
	controller addElementToTransformedModel: newClass.
	compositions do: [ :element | controller addElementToTransformedModel: element ].
	^ results
]

{ #category : 'private - transforming - composition' }
OntoUMLTransformGeneralizationSet >> createCompositionEndFor: aComposition withEndType: anEndType withOpposingEnd: aOpposingEndType navigable: isNavigable [

	| property |
	property := OPUMLProperty new.
	property
		name: '';
		lowerValue: (OPUMLLiteralInteger new value: 1);
		upperValue: (OPUMLLiteralInteger new value: 1);
		type: anEndType.

	isNavigable
		ifTrue: [ property owningClass: aOpposingEndType ]
		ifFalse: [ property owningAssociation: aComposition ].

	^ property
]

{ #category : 'private - transforming - composition' }
OntoUMLTransformGeneralizationSet >> createCompositionWithSource: aSource withTarget: aTarget [

	| composition |
	composition := OPUMLAssociation new.
	composition memberEnds add: (self
			 createCompositionEndFor: composition
			 withEndType: aSource
			 withOpposingEnd: aTarget
			 navigable: true).
	composition memberEnds add: (self
			 createCompositionEndFor: composition
			 withEndType: aTarget
			 withOpposingEnd: aSource
			 navigable: false).
	self validateAssociation: composition.
	^ composition
]

{ #category : 'private - transforming - generalization' }
OntoUMLTransformGeneralizationSet >> createGeneralizationFor: aSpecific [

	^ self createGeneralizationWithGeneral: (controller getTransformedElementFrom: transformed first general) withSpecific: aSpecific
]

{ #category : 'private - transforming - generalization' }
OntoUMLTransformGeneralizationSet >> createGeneralizationWithGeneral: aGeneral withSpecific: aSpecific [
	| generalization |
	generalization := OPUMLGeneralization new.
	generalization general: aGeneral.
	generalization specific: aSpecific.
	^ generalization.
]

{ #category : 'transforming' }
OntoUMLTransformGeneralizationSet >> getSelection [
	| transformation |
	transformation := transformer class savedTransformation.
	^ transformation ifNil: [ self getSelectionUsingModalWindow. ].
	
]

{ #category : 'transforming' }
OntoUMLTransformGeneralizationSet >> getSelectionUsingModalWindow [
	| dialogWindow |
	dialogWindow := TransformGeneralizationSetUI basicNew.
	dialogWindow model: transformed.
	dialogWindow initialize.
	dialogWindow openModal.
	dialogWindow useForAll ifTrue: [ transformer class savedTransformation: dialogWindow transformation. ].
	^ dialogWindow transformation.
	
]

{ #category : 'initialization' }
OntoUMLTransformGeneralizationSet >> initializeArrays [
	elements := (transformed collect: [ :generalization | generalization specific. ]) asArray.
	index := Array new: elements size.
]

{ #category : 'private - transforming - generalization' }
OntoUMLTransformGeneralizationSet >> setGeneralProperties [
	transformer transformed isDisjoint ifTrue: [ self setName. ].
	transformer transformed isCovering ifTrue: [ transformer general isAbstract: true. ].
]

{ #category : 'private - transforming - composition' }
OntoUMLTransformGeneralizationSet >> setName [

	((transformer name ifNil: [ '' ]) endsWith: 'XOR') ifTrue: [ ^ self ].
	transformer name: (transformer transformed name ifNil: [ transformer general name ifNil: [ '' ] ]) , ' - XOR'
]

{ #category : 'transforming' }
OntoUMLTransformGeneralizationSet >> transform [

	| selection |
	transformer transformed isDisjoint ifTrue: [
		^ self transformDisjointGeneralization ].
	selection := self getSelection.
	selection = 'Gen' ifTrue: [ ^ self transformAsGeneralization ].
	selection = 'GenAndComp' ifTrue: [
		^ self transformAsGeneralizationAndComposition ].
	selection = 'Comp' ifTrue: [ ^ self transformAsComposition ].
	^ nil
]

{ #category : 'transforming' }
OntoUMLTransformGeneralizationSet >> transformAsComposition [
	transformer transformed isDisjoint ifTrue: [ self setName. ].
	^ transformed collect: [ :generalization | OntoUMLTransformComposition transform: generalization withController: controller withTransformer: transformer. ].
]

{ #category : 'transforming' }
OntoUMLTransformGeneralizationSet >> transformAsGeneralization [
	^ self transformWithCombination: [ :addedClass :composedClass | self combineUsingGeneralization: addedClass with: composedClass. ].
]

{ #category : 'transforming' }
OntoUMLTransformGeneralizationSet >> transformAsGeneralizationAndComposition [
	^ self transformWithCombination: [ :addedClass :composedClass | self combineUsingGeneralizationAndComposition: addedClass with: composedClass. ].
]

{ #category : 'private - transforming - generalization' }
OntoUMLTransformGeneralizationSet >> transformClassCombination: aIndex [
	(self calculateIndexesFrom: aIndex) < 2 ifTrue:
	 [ ^ {}. ].
	^ self createClassCombination.
]

{ #category : 'transforming' }
OntoUMLTransformGeneralizationSet >> transformDisjointGeneralization [

	transformer transformed isCovering ifTrue: [ transformer general isAbstract: true ].
	self initializeArrays.
	^ elements collect: [ :element | self createGeneralizationFor: (controller getTransformedElementFrom: element) ]
]

{ #category : 'private - transforming - generalization' }
OntoUMLTransformGeneralizationSet >> transformWithCombination: aCombinationSelector [

	| maxIndex results |
	self setGeneralProperties.
	self initializeArrays.
	self combinationSelector: aCombinationSelector.
	maxIndex := (2 raisedTo: elements size) - 1.
	results := (3 to: maxIndex) flatCollect: [ :i | self transformClassCombination: i ] as: OrderedCollection. "we can ignore first two indexes"
	results addAll: (elements collect: [ :element | self createGeneralizationFor: (controller getTransformedElementFrom: element) ]).
	^ results
]
