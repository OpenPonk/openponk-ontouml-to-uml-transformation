Class {
	#name : #OntoUMLTransformSubQuantityOf,
	#superclass : #OntoUMLTransformation,
	#category : #'OntoUML-TransformationFramework-Transformations'
}

{ #category : #transforming }
OntoUMLTransformSubQuantityOf >> transform [
	| association |
	association := OntoUMLTransformAssociation transform: transformed withController: controller withTransformer: transformer.
	association memberEnds do: [ :end | self transformEnd: end forAssociation: association. ].
	self transformName: association.
	^ association.
]

{ #category : #transforming }
OntoUMLTransformSubQuantityOf >> transformEnd: aEnd forAssociation: aAssociation [
	({ 'shared'. 'composite'. } includes: aEnd aggregation) ifTrue: [ aEnd owningClass: (aAssociation memberEnds reject: [ :end | end = aEnd. ]) first type. ].
	aEnd aggregation: 'none'.
]

{ #category : #transforming }
OntoUMLTransformSubQuantityOf >> transformName: aAssociation [
	(aAssociation name notNil and: [ aAssociation name ~= ''. ]) ifFalse: [ aAssociation name: 'containment'. ].
]
