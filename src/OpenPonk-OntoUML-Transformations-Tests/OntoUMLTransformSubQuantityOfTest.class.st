"
Unit tests verifying transformation of OntoUML subQuantityOf associations into plain navigable UML containment associations.
"
Class {
	#name : 'OntoUMLTransformSubQuantityOfTest',
	#superclass : 'OntoUMLAbstractTransformationTest',
	#category : 'OpenPonk-OntoUML-Transformations-Tests-Transformations',
	#package : 'OpenPonk-OntoUML-Transformations-Tests',
	#tag : 'Transformations'
}

{ #category : 'tests' }
OntoUMLTransformSubQuantityOfTest >> testTransformSubQuantityOfMovesCompositeEndAndUsesSymbolAggregation [

	| controller wholeClass partClass transformedWhole transformedPart association wholeEnd partEnd resultAssociation resultWholeEnd resultPartEnd |
	controller := OntoUMLTransformationController new.
	wholeClass := OPUMLClass new name: 'Beer'.
	partClass := OPUMLClass new name: 'Alcohol'.
	transformedWhole := OPUMLClass new name: 'Beer'.
	transformedPart := OPUMLClass new name: 'Alcohol'.
	controller addTransformationLinkBetween: wholeClass and: transformedWhole.
	controller addTransformationLinkBetween: partClass and: transformedPart.

	association := self createAssociationFrom: wholeClass to: partClass with: OntoUMLSubQuantityOf new.
	wholeEnd := association memberEnds first.
	partEnd := association memberEnds second.
	partEnd aggregation: OPUMLAggregationKind composite.

	resultAssociation := OntoUMLTransformSubQuantityOf
		                     transform: association
		                     withController: controller
		                     withTransformer: OntoUMLAssociationTransformer new.

	self assert: resultAssociation name equals: 'containment'.
	self assert: resultAssociation memberEnds size equals: 2.
	resultWholeEnd := resultAssociation memberEnds first.
	resultPartEnd := resultAssociation memberEnds second.
	self assert: resultWholeEnd aggregation identicalTo: OPUMLAggregationKind none.
	self assert: resultPartEnd aggregation identicalTo: OPUMLAggregationKind none.
	self assert: resultWholeEnd owningAssociation identicalTo: resultAssociation.
	self assert: resultWholeEnd owningClass identicalTo: nil.
	self assert: resultPartEnd owningAssociation identicalTo: nil.
	self assert: resultPartEnd owningClass identicalTo: transformedWhole
]

{ #category : 'tests' }
OntoUMLTransformSubQuantityOfTest >> testTransformSubQuantityOfMovesSharedEndAndPreservesExistingName [

	| controller wholeClass partClass transformedWhole transformedPart association resultAssociation resultWholeEnd resultPartEnd validationWarnings |
	controller := OntoUMLTransformationController new.
	wholeClass := OPUMLClass new name: 'Juice'.
	partClass := OPUMLClass new name: 'Water'.
	transformedWhole := OPUMLClass new name: 'Juice'.
	transformedPart := OPUMLClass new name: 'Water'.
	controller addTransformationLinkBetween: wholeClass and: transformedWhole.
	controller addTransformationLinkBetween: partClass and: transformedPart.

	association := self createAssociationFrom: wholeClass to: partClass with: OntoUMLSubQuantityOf new.
	association name: 'contains'.
	association memberEnds first aggregation: OPUMLAggregationKind shared.

	resultAssociation := OntoUMLTransformSubQuantityOf
		                     transform: association
		                     withController: controller
		                     withTransformer: OntoUMLAssociationTransformer new.

	self assert: resultAssociation name equals: 'contains'.
	self assert: (controller getTransformedElementFrom: association) identicalTo: resultAssociation.
	self assertCollection: controller transformedModel packagedElements hasSameElements: { resultAssociation }.

	resultWholeEnd := resultAssociation memberEnds first.
	resultPartEnd := resultAssociation memberEnds second.
	self assert: resultWholeEnd aggregation identicalTo: OPUMLAggregationKind none.
	self assert: resultPartEnd aggregation identicalTo: OPUMLAggregationKind none.
	self assert: resultWholeEnd owningAssociation identicalTo: nil.
	self assert: resultWholeEnd owningClass identicalTo: transformedPart.
	self assert: resultPartEnd owningAssociation identicalTo: resultAssociation.

	validationWarnings := OrderedCollection new.
	[ (OPUmlAssociationViewModel new model: resultAssociation) validate ]
		on: OPModelInvalid
		do: [ :warning |
				validationWarnings add: warning messageText.
				warning resume ].
	self assertEmpty: validationWarnings
]

{ #category : 'tests' }
OntoUMLTransformSubQuantityOfTest >> testTransformSubQuantityOfReplacesEmptyNameWithContainment [

	| controller wholeClass partClass association resultAssociation |
	controller := OntoUMLTransformationController new.
	wholeClass := OPUMLClass new name: 'Wine'.
	partClass := OPUMLClass new name: 'Alcohol'.
	controller addTransformationLinkBetween: wholeClass and: (OPUMLClass new name: 'Wine').
	controller addTransformationLinkBetween: partClass and: (OPUMLClass new name: 'Alcohol').

	association := self createAssociationFrom: wholeClass to: partClass with: OntoUMLSubQuantityOf new.
	association name: ''.

	resultAssociation := OntoUMLTransformSubQuantityOf
		                     transform: association
		                     withController: controller
		                     withTransformer: OntoUMLAssociationTransformer new.

	self assert: resultAssociation name equals: 'containment'
]
