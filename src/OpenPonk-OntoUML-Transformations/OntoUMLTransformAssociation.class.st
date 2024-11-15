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
	association name: transformed name;
		isDerived: transformed isDerived.
	self tranformAssociationEnd: transformed memberEnds first forAssociation: association.
	self tranformAssociationEnd: transformed memberEnds second forAssociation: association.
	self copyCommentsFrom: transformed to: association. 
	association memberEnds addAll: association ownedEnds asArray.
	^ association.
]

{ #category : 'transforming' }
OntoUMLTransformAssociation >> tranformAssociationEnd: aAssociationEnd forAssociation: aAssociation [

	| property |
	property := OPUMLProperty new.
	property
		name: aAssociationEnd name;
		lowerValue: aAssociationEnd lowerValue;
		upperValue: aAssociationEnd upperValue;
		type: (controller getTransfomedElementFrom: aAssociationEnd type).
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
		ifNotNil: [ "isNavigable"
			property owningClass:
				(controller getTransfomedElementFrom: aAssociationEnd owningClass) ].
	^ property
]

{ #category : 'transforming' }
OntoUMLTransformAssociation >> transform [
	| association |
	association := self createAssociation.
	controller addTranformationLinkBetween: transformed and: association.
	controller addElementToTransformedModel: association.
	^ association.
]
