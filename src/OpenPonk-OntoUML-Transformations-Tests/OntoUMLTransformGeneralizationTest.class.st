"
Unit tests verifying transformation of individual OntoUML generalizations into plain UML generalizations.
"
Class {
	#name : 'OntoUMLTransformGeneralizationTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-OntoUML-Transformations-Tests-Transformations',
	#package : 'OpenPonk-OntoUML-Transformations-Tests',
	#tag : 'Transformations'
}

{ #category : 'tests' }
OntoUMLTransformGeneralizationTest >> testTransformMapsEndpointsCopiesCommentsAndAddsToTransformedModel [

	| controller generalClass specificClass transformedGeneral transformedSpecific generalization sourceComment resultGeneralization |
	controller := OntoUMLTransformationController new.
	generalClass := OPUMLClass new name: 'Entity'.
	specificClass := OPUMLClass new name: 'Agent'.
	transformedGeneral := OPUMLClass new name: 'Entity'.
	transformedSpecific := OPUMLClass new name: 'Agent'.
	controller addTransformationLinkBetween: generalClass and: transformedGeneral.
	controller addTransformationLinkBetween: specificClass and: transformedSpecific.

	generalization := OPUMLGeneralization new
		                  general: generalClass;
		                  specific: specificClass;
		                  yourself.
	sourceComment := OPUMLComment new body: 'Generalization note'.
	generalization ownedComments: { sourceComment }.

	resultGeneralization := OntoUMLTransformGeneralization
		                        transform: generalization
		                        withController: controller
		                        withTransformer: OntoUMLGeneralizationTransformer new.

	self assert: resultGeneralization class identicalTo: OPUMLGeneralization.
	self assert: resultGeneralization general identicalTo: transformedGeneral.
	self assert: resultGeneralization specific identicalTo: transformedSpecific.
	self assert: resultGeneralization ownedComments size equals: 1.
	self assert: resultGeneralization ownedComments first body equals: 'Generalization note'.
	self deny: resultGeneralization ownedComments first identicalTo: sourceComment.
	self assertCollection: controller transformedModel packagedElements hasSameElements: { resultGeneralization }.
	self assertCollection: transformedSpecific generalizations hasSameElements: { resultGeneralization }
]
