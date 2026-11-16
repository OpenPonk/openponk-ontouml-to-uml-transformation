"
I execute the transformation of an OntoUML stereotyped association into a standard UML association, ensuring correct mapping of member ends and multiplicities.
"
Class {
	#name : 'OntoUMLTransformAssociation',
	#superclass : 'OntoUMLTransformation',
	#category : 'OpenPonk-OntoUML-Transformations-Transformations',
	#package : 'OpenPonk-OntoUML-Transformations',
	#tag : 'Transformations'
}

{ #category : 'transforming' }
OntoUMLTransformAssociation >> createAssociation [

	| association |
	association := OPUMLAssociation new.
	association
		name: transformed name;
		isDerived: transformed isDerived.
	association memberEnds add: (self transformAssociationEnd: transformed memberEnds first forAssociation: association).
	association memberEnds add: (self transformAssociationEnd: transformed memberEnds second forAssociation: association).
	self copyCommentsFrom: transformed to: association.

	self validateAssociation: association.

	^ association
]

{ #category : 'transforming' }
OntoUMLTransformAssociation >> transform [

	| association |
	association := self createAssociation.
	controller addTransformationLinkBetween: transformed and: association.
	controller addElementToTransformedModel: association.
	^ association
]

{ #category : 'transforming' }
OntoUMLTransformAssociation >> transformAssociationEnd: aAssociationEnd forAssociation: aAssociation [

	| property |
	property := OPUMLProperty new.
	property
		name: aAssociationEnd name;
		lowerValue: (self copyMultiplicity: aAssociationEnd lowerValue);
		upperValue: (self copyMultiplicity: aAssociationEnd upperValue);
		type: (controller getTransformedElementFrom: aAssociationEnd type).
	property
		isStatic: aAssociationEnd isStatic;
		isReadOnly: aAssociationEnd isReadOnly;
		isDerived: aAssociationEnd isDerived;
		isOrdered: aAssociationEnd isOrdered;
		isUnique: aAssociationEnd isUnique;
		visibility: aAssociationEnd visibility;
		aggregation: aAssociationEnd aggregation.

	aAssociationEnd owningClass
		ifNil: [ property owningAssociation: aAssociation ]
		ifNotNil: [ "isNavigable" property owningClass: (controller getTransformedElementFrom: aAssociationEnd owningClass) ].
	^ property
]
