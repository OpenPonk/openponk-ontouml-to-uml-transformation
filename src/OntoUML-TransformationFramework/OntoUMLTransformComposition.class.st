Class {
	#name : #OntoUMLTransformComposition,
	#superclass : #OntoUMLTransformation,
	#category : #'OntoUML-TransformationFramework-Transformations'
}

{ #category : #transforming }
OntoUMLTransformComposition >> createComposition [
	| composition |
	composition := OPUMLAssociation new.
	composition name: transformer name.
	self createCompositionEndFor: composition withEndType: transformed general withOpposingEnd: transformed specific navigable: false.
	self createCompositionEndFor: composition withEndType: transformed specific withOpposingEnd: transformed general navigable: true.
	composition memberEnds addAll: composition ownedEnds.
	^ composition.
]

{ #category : #transforming }
OntoUMLTransformComposition >> createCompositionEndFor: aComposition withEndType: aEndType withOpposingEnd: aOpposingEndType navigable: aBoolean [
	| end |
	end := OPUMLProperty new
		name: '';
		lowerValue: (OPUMLLiteralInteger new value: 1);
		upperValue: (OPUMLLiteralInteger new value: 1);
		association: aComposition;
		type: (controller getTransfomedElementFrom: aEndType).
	aBoolean ifTrue: [ end owningClass: (controller getTransfomedElementFrom: aOpposingEndType). ].
	^ end.
]

{ #category : #transforming }
OntoUMLTransformComposition >> transform [
	| composition |
	composition := self createComposition.
	controller addElementToTransformedModel: composition.
	^ composition.
]
