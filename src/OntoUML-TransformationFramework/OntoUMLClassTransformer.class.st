Class {
	#name : 'OntoUMLClassTransformer',
	#superclass : 'OntoUMLTransformer',
	#category : 'OntoUML-TransformationFramework-Transformers',
	#package : 'OntoUML-TransformationFramework',
	#tag : 'Transformers'
}

{ #category : 'transforming' }
OntoUMLClassTransformer class >> defaultTransformation [
	^ OntoUMLTransformClass.
]

{ #category : 'transforming' }
OntoUMLClassTransformer class >> getTransformation: aClass [
	| stereotypeClass |
	stereotypeClass := OntoUMLModelQuery getStereotypeClass: aClass.
	^ super getTransformation: stereotypeClass.
]

{ #category : 'transforming' }
OntoUMLClassTransformer class >> initializeTransformationIndex [
	transformationIndex := Dictionary new.
	"Currently there are no class specific transformations."
]

{ #category : 'transforming' }
OntoUMLClassTransformer >> transform [ 
	^ (self class getTransformation: transformed) transform: transformed withController: controller withTransformer: self.
]
