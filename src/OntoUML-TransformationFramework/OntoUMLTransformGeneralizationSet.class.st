Class {
	#name : #OntoUMLTransformGeneralizationSet,
	#superclass : #OntoUMLTransformation,
	#instVars : [
		'elements',
		'index',
		'combinationSelector'
	],
	#category : #'OntoUML-TransformationFramework-Transformations'
}

{ #category : #transforming }
OntoUMLTransformGeneralizationSet class >> transformAsComposition: aTransformed withController: aController withTransformer: aTransformer [
	| instance |
	instance := self newWithTransformed: aTransformed withController: aController withTransformer: aTransformer.
	^ instance transformAsComposition.
]

{ #category : #transforming }
OntoUMLTransformGeneralizationSet class >> transformAsGeneralization: aTransformed withController: aController withTransformer: aTransformer [
	| instance |
	instance := self newWithTransformed: aTransformed withController: aController withTransformer: aTransformer.
	^ instance transformAsGeneralization.
]

{ #category : #transforming }
OntoUMLTransformGeneralizationSet class >> transformAsGeneralizationAndComposition: aTransformed withController: aController withTransformer: aTransformer [
	| instance |
	instance := self newWithTransformed: aTransformed withController: aController withTransformer: aTransformer.
	^ instance transformAsGeneralizationAndComposition.
]

{ #category : #'private - transforming - generalization' }
OntoUMLTransformGeneralizationSet >> calculateIndex: aIndex for: aElementPosition [
	| positionOffset |
	positionOffset := 2 raisedTo: (aElementPosition - 1).
	(aIndex bitAnd: positionOffset) > 0 
		ifTrue: [ ^ 1. ] 
		ifFalse: [ ^ 0. ].
]

{ #category : #'private - transforming - generalization' }
OntoUMLTransformGeneralizationSet >> calculateIndexesFrom: aIndex [
	| sumOfIndexes |
	sumOfIndexes := 0.
	1 to: index size do: [ :i |
		index at: i put: (self calculateIndex: aIndex for: i).
		sumOfIndexes := sumOfIndexes + (index at: i). ].
	^ sumOfIndexes.
]

{ #category : #accessing }
OntoUMLTransformGeneralizationSet >> combinationSelector [

	^ combinationSelector
]

{ #category : #accessing }
OntoUMLTransformGeneralizationSet >> combinationSelector: anObject [

	combinationSelector := anObject
]

{ #category : #'private - transforming - generalization' }
OntoUMLTransformGeneralizationSet >> combineClass: aAddedClass with: aCompositeClass [
	^ self combinationSelector value: aAddedClass value: aCompositeClass.
	
]

{ #category : #transforming }
OntoUMLTransformGeneralizationSet >> combineUsingGeneralization: aAddedClass with: aCompositeClass [
	aCompositeClass name: aCompositeClass name, aAddedClass name.
	self copyAttributesFrom: aAddedClass in: aCompositeClass.
	self copyOperationsFor: aCompositeClass.
	^ self createGeneralizationWithGeneral: (controller getTransfomedElementFrom: aAddedClass) withSpecific: aCompositeClass.
	
]

{ #category : #transforming }
OntoUMLTransformGeneralizationSet >> combineUsingGeneralizationAndComposition: aAddedClass with: aCompositeClass [
	aCompositeClass name: aCompositeClass name, aAddedClass name.
	^ self createCompositionWithSource: (controller getTransfomedElementFrom: aAddedClass) withTarget: aCompositeClass.
	
]

{ #category : #'private - transforming - generalization' }
OntoUMLTransformGeneralizationSet >> copyAttribute: aAttribute for: aClass [
	| copy |
	aAttribute association ifNotNil: [ ^ {}. ].
	copy := aAttribute class new.
	copy name: aAttribute name;
		owner: aClass.
	aClass ownedAttributes add: copy.
]

{ #category : #'private - transforming - generalization' }
OntoUMLTransformGeneralizationSet >> copyAttributesFrom: aAddedClass in: aCompositeClass [
	| attributes |
	attributes := aAddedClass ownedAttributes.
	aCompositeClass attributes ifNil: [ aCompositeClass ownedAttributes: attributes copyEmpty. ].
	attributes do: [ :attribute | self copyAttribute: attribute for: aCompositeClass. ].
]

{ #category : #'private - transforming - generalization' }
OntoUMLTransformGeneralizationSet >> copyOperationsFor: aCompositeClass [	
	aCompositeClass ownedOperations addAll: (aCompositeClass ownedAttributes select: [ :att | att isKindOf: OPUMLOperation ]).
]

{ #category : #'private - transforming - generalization' }
OntoUMLTransformGeneralizationSet >> createClassCombination [
	| newClass results |
	results := OrderedCollection new.
	newClass := OPUMLClass new.
	newClass name: ''.
	results add: newClass.
	results add: (self createGeneralizationFor: newClass).
	results addAll: ((1 to: index size) flatCollect: [ :i |
		(index at: i) > 0 
			ifTrue: [ {self combineClass: (elements at: i) with: newClass.}. ]
			ifFalse: [ {}. ]. ]).
	results do: [ :element | controller addElementToTransformedModel: element. ].
	^ results.
]

{ #category : #'private - transforming - composition' }
OntoUMLTransformGeneralizationSet >> createCompositionEndFor: aComposition withEndType: aEndType withOpposingEnd: aOpposingEndType navigable: aBoolean [
	| end |
	end := OPUMLProperty new
		name: '';
		lowerValue: (OPUMLLiteralInteger new value: 1);
		upperValue: (OPUMLLiteralInteger new value: 1);
		association: aComposition;
		type: aEndType.
	aBoolean ifTrue: [ end owningClass: aOpposingEndType. ].
	^ end.
]

{ #category : #'private - transforming - composition' }
OntoUMLTransformGeneralizationSet >> createCompositionWithSource: aSource withTarget: aTarget [
	| composition |
	composition := OPUMLAssociation new.
	self createCompositionEndFor: composition withEndType: aSource withOpposingEnd: aTarget navigable: true.
	self createCompositionEndFor: composition withEndType: aTarget withOpposingEnd: aSource navigable: false.
	composition memberEnds addAll: composition ownedEnds.
	^ composition.
]

{ #category : #'private - transforming - generalization' }
OntoUMLTransformGeneralizationSet >> createGeneralizationFor: aSpecific [
	^ self createGeneralizationWithGeneral: (controller getTransfomedElementFrom: transformed first general) withSpecific: aSpecific.
]

{ #category : #'private - transforming - generalization' }
OntoUMLTransformGeneralizationSet >> createGeneralizationWithGeneral: aGeneral withSpecific: aSpecific [
	| generalization |
	generalization := OPUMLGeneralization new.
	generalization general: aGeneral.
	generalization specific: aSpecific.
	^ generalization.
]

{ #category : #transforming }
OntoUMLTransformGeneralizationSet >> getSelection [
	| dialogWindow |
	dialogWindow := TransformGeneralizationSetUI basicNew.
	dialogWindow model: transformed.
	dialogWindow initialize.
	dialogWindow openModalWithSpec.
	^ dialogWindow transformation.
	
]

{ #category : #initialization }
OntoUMLTransformGeneralizationSet >> initializeArrays [
	elements := (transformed collect: [ :generalization | generalization specific. ]) asArray.
	index := Array new: elements size.
]

{ #category : #'private - transforming - generalization' }
OntoUMLTransformGeneralizationSet >> setGeneralProperties [
	transformer transformed isDisjoint ifTrue: [ self setName. ].
	transformer transformed isCovering ifTrue: [ transformer general isAbstract: true. ].
]

{ #category : #'private - transforming - composition' }
OntoUMLTransformGeneralizationSet >> setName [
	((transformer name ifNil: [ '' ]) endsWith: 'XOR') ifTrue: [ ^ self. ].
	transformer name: (transformer transformed name ifNil: [ transformer general name ]) , ' - XOR'.
]

{ #category : #transforming }
OntoUMLTransformGeneralizationSet >> transform [
	| selection |	
 	transformer transformed isDisjoint ifTrue: [ ^ self transformDisjointGeneralization. ].
	selection := self getSelection.
	(selection = 'Gen') ifTrue: [ ^ self transformAsGeneralization. ].
	(selection = 'GenAndComp') ifTrue: [ ^ self transformAsGeneralizationAndComposition. ].
	(selection = 'Comp') ifTrue: [ ^ self transformAsComposition. ].
	^ nil.
]

{ #category : #transforming }
OntoUMLTransformGeneralizationSet >> transformAsComposition [
	transformer transformed isDisjoint ifTrue: [ self setName. ].
	^ transformed collect: [ :generalization | OntoUMLTransformComposition transform: generalization withController: controller withTransformer: transformer. ].
]

{ #category : #transforming }
OntoUMLTransformGeneralizationSet >> transformAsGeneralization [
	^ self transformWithCombination: [ :addedClass :composedClass | self combineUsingGeneralization: addedClass with: composedClass. ].
]

{ #category : #transforming }
OntoUMLTransformGeneralizationSet >> transformAsGeneralizationAndComposition [
	^ self transformWithCombination: [ :addedClass :composedClass | self combineUsingGeneralizationAndComposition: addedClass with: composedClass. ].
]

{ #category : #'private - transforming - generalization' }
OntoUMLTransformGeneralizationSet >> transformClassCombination: aIndex [
	(self calculateIndexesFrom: aIndex) < 2 ifTrue:
	 [ ^ {}. ].
	^ self createClassCombination.
]

{ #category : #transforming }
OntoUMLTransformGeneralizationSet >> transformDisjointGeneralization [
	self initializeArrays.
	^ elements collect: [ :element | self createGeneralizationFor: (controller getTransfomedElementFrom: element). ].
]

{ #category : #'private - transforming - generalization' }
OntoUMLTransformGeneralizationSet >> transformWithCombination: aCombinationSelector [
	| maxIndex results |
	self setGeneralProperties.
	self initializeArrays.
	combinationSelector := aCombinationSelector.
	maxIndex := 2 raisedTo: elements size.
	results := ((3 to: maxIndex) flatCollect: [ :i | self transformClassCombination: i. ]) asOrderedCollection. "we can ignore first two indexes"
	results addAll: (elements collect: [ :element | self createGeneralizationFor: (controller getTransfomedElementFrom: element).]).
	^ results.
]
