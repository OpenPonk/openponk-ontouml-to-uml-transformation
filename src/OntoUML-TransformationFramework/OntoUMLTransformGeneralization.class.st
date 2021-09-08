Class {
	#name : #OntoUMLTransformGeneralization,
	#superclass : #OntoUMLTransformation,
	#category : #'OntoUML-TransformationFramework-Transformations'
}

{ #category : #transforming }
OntoUMLTransformGeneralization >> transform [
	| generalization |
	generalization := OPUMLGeneralization new.
	generalization specific: (controller getTransfomedElementFrom: transformed specific).
	generalization general: (controller getTransfomedElementFrom: transformed general).
	controller addElementToTransformedModel: generalization.
	^ generalization.
]
