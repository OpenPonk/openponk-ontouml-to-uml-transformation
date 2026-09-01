"
I execute the transformation of an OntoUML generalization into a standard UML generalization without altering the taxonomic hierarchy.
"
Class {
	#name : 'OntoUMLTransformGeneralization',
	#superclass : 'OntoUMLTransformation',
	#category : 'OpenPonk-OntoUML-Transformations-Transformations',
	#package : 'OpenPonk-OntoUML-Transformations',
	#tag : 'Transformations'
}

{ #category : 'transforming' }
OntoUMLTransformGeneralization >> transform [

	| generalization |
	generalization := OPUMLGeneralization new.
	generalization specific:
		(controller getTransfomedElementFrom: transformed specific).
	generalization general:
		(controller getTransfomedElementFrom: transformed general).
	self copyCommentsFrom: transformed to: generalization.
	controller addElementToTransformedModel: generalization.
	^ generalization
]
