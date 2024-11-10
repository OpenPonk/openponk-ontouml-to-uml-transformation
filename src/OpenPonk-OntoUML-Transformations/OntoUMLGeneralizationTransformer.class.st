Class {
	#name : 'OntoUMLGeneralizationTransformer',
	#superclass : 'OntoUMLTransformer',
	#category : 'OpenPonk-OntoUML-Transformations-Transformers',
	#package : 'OpenPonk-OntoUML-Transformations',
	#tag : 'Transformers'
}

{ #category : 'transforming' }
OntoUMLGeneralizationTransformer class >> defaultTransformation [
	^ OntoUMLTransformGeneralization.
]

{ #category : 'transforming' }
OntoUMLGeneralizationTransformer class >> getTransformation: aClass [
	| stereotypeClass |
	stereotypeClass := OntoUMLModelQuery getStereotypeClass: aClass.
	^ super getTransformation: stereotypeClass.
]

{ #category : 'transforming' }
OntoUMLGeneralizationTransformer class >> initializeTransformationIndex [
	transformationIndex := Dictionary new.
	transformationIndex add: (OntoUMLPhase -> OntoUMLTransformComposition).
	transformationIndex add: (OntoUMLMixin -> OntoUMLTransformComposition).
	transformationIndex add: (OntoUMLRole -> OntoUMLTransformComposition).
	transformationIndex add: (OntoUMLRoleMixin -> OntoUMLTransformComposition).
	
]

{ #category : 'transforming' }
OntoUMLGeneralizationTransformer >> name [
	^ ''.
]

{ #category : 'transforming' }
OntoUMLGeneralizationTransformer >> transform [ 
	^ (self class getTransformation: transformed specific) transform: transformed withController: controller withTransformer: self.
]
