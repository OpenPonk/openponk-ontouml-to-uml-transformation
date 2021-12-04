Class {
	#name : #OntoUMLTransformAssociation,
	#superclass : #OntoUMLTransformation,
	#category : #'OntoUML-TransformationFramework-Transformations'
}

{ #category : #transforming }
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

{ #category : #transforming }
OntoUMLTransformAssociation >> tranformAssociationEnd: aAssociationEnd forAssociation: aAssociation [
	^ OPUMLProperty new
		name: aAssociationEnd name;
		lowerValue: aAssociationEnd lowerValue;
		upperValue: aAssociationEnd upperValue;
		type: (controller getTransfomedElementFrom: aAssociationEnd type);
		owningAssociation: aAssociation;
		owningClass: (aAssociationEnd owningClass ifNotNil: [controller getTransfomedElementFrom: aAssociationEnd owningClass]); "isNavigable"
		isStatic: aAssociationEnd isStatic;
		isReadOnly: aAssociationEnd isReadOnly;
		isDerived: aAssociationEnd isDerived;
		isOrdered: aAssociationEnd isOrdered;		
		isUnique: aAssociationEnd isUnique;
		visibility: aAssociationEnd visibility;
		aggregation: aAssociationEnd aggregation.
		
]

{ #category : #transforming }
OntoUMLTransformAssociation >> transform [
	| association |
	association := self createAssociation.
	controller addTranformationLinkBetween: transformed and: association.
	controller addElementToTransformedModel: association.
	^ association.
]
