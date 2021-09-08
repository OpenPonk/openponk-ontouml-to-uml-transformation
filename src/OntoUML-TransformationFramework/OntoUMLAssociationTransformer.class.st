Class {
	#name : #OntoUMLAssociationTransformer,
	#superclass : #OntoUMLTransformer,
	#category : #'OntoUML-TransformationFramework-Transformers'
}

{ #category : #accessing }
OntoUMLAssociationTransformer class >> defaultTransformation [
	^ OntoUMLTransformAssociation.
]

{ #category : #transforming }
OntoUMLAssociationTransformer class >> getTransformation: aAssocitaion [
	| stereotypeClass |
	stereotypeClass := OntoUMLModelQuery getStereotypeClass: aAssocitaion.
	^ super getTransformation: stereotypeClass.
]

{ #category : #transforming }
OntoUMLAssociationTransformer class >> initializeTransformationIndex [
	transformationIndex := Dictionary new.
	transformationIndex add: (OntoUMLSubQuantityOf -> OntoUMLTransformSubQuantityOf).
]

{ #category : #transforming }
OntoUMLAssociationTransformer >> transform [
	^ (self class getTransformation: transformed) transform: transformed withController: controller withTransformer: self.
]
