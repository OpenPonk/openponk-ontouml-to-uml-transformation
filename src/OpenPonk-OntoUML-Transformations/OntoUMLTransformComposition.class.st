Class {
	#name : 'OntoUMLTransformComposition',
	#superclass : 'OntoUMLTransformation',
	#category : 'OpenPonk-OntoUML-Transformations-Transformations',
	#package : 'OpenPonk-OntoUML-Transformations',
	#tag : 'Transformations'
}

{ #category : 'transforming' }
OntoUMLTransformComposition >> createComposition [

	| composition |
	composition := OPUMLAssociation new.
	composition name: transformer name.

	composition memberEnds add: (self
			 createCompositionEndFor: composition
			 withEndType: transformed general
			 withOpposingEnd: transformed specific
			 navigable: false).
	composition memberEnds add: (self
			 createCompositionEndFor: composition
			 withEndType: transformed specific
			 withOpposingEnd: transformed general
			 navigable: true).
	self assert: composition memberEnds size = 2 description: [
		'Generated association has only 1 end. '
		, (transformer transformed generalizations size = 1
				 ifTrue: [
				 ' Might be caused by generalization set with only 1 generalization' ]
				 ifFalse: [ '' ]) ].
	^ composition
]

{ #category : 'transforming' }
OntoUMLTransformComposition >> createCompositionEndFor: aComposition withEndType: anEndType withOpposingEnd: aOpposingEndType navigable: isNavigable [

	| property |
	property := OPUMLProperty new.
	property
		name: '';
		lowerValue: (OPUMLLiteralInteger new value: 1);
		upperValue: (OPUMLLiteralInteger new value: 1);
		type: (controller getTransfomedElementFrom: anEndType).

	isNavigable
		ifTrue: [
			property owningClass:
				(controller getTransfomedElementFrom: aOpposingEndType) ]
		ifFalse: [ property owningAssociation: aComposition ].

	^ property
]

{ #category : 'transforming' }
OntoUMLTransformComposition >> transform [
	| composition |
	composition := self createComposition.
	controller addElementToTransformedModel: composition.
	^ composition.
]
