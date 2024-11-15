Class {
	#name : 'OntoUMLTransformSubQuantityOf',
	#superclass : 'OntoUMLTransformation',
	#category : 'OpenPonk-OntoUML-Transformations-Transformations',
	#package : 'OpenPonk-OntoUML-Transformations',
	#tag : 'Transformations'
}

{ #category : 'transforming' }
OntoUMLTransformSubQuantityOf >> transform [
	| association |
	association := OntoUMLTransformAssociation transform: transformed withController: controller withTransformer: transformer.
	association memberEnds do: [ :end | self transformEnd: end forAssociation: association. ].
	self transformName: association.
	^ association.
]

{ #category : 'transforming' }
OntoUMLTransformSubQuantityOf >> transformEnd: anEnd forAssociation: aAssociation [

	({ 'shared'. 'composite' } includes: anEnd aggregation) ifTrue: [
		anEnd owningAssociation: nil.
		anEnd owningClass:
			(aAssociation memberEnds reject: [ :end | end = anEnd ]) first type ].
	anEnd aggregation: 'none'
]

{ #category : 'transforming' }
OntoUMLTransformSubQuantityOf >> transformName: aAssociation [
	(aAssociation name notNil and: [ aAssociation name ~= ''. ]) ifFalse: [ aAssociation name: 'containment'. ].
]
