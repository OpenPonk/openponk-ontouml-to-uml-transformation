"
Unit tests verifying transformation of OntoUML generalizations into plain UML composition-style navigable associations.
"
Class {
	#name : 'OntoUMLTransformCompositionTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-OntoUML-Transformations-Tests-Transformations',
	#package : 'OpenPonk-OntoUML-Transformations-Tests',
	#tag : 'Transformations'
}

{ #category : 'tests' }
OntoUMLTransformCompositionTest >> testTransformCreatesNavigableAssociationFromGeneralToSpecific [

	| controller generalClass specificClass transformedGeneral transformedSpecific generalization transformer resultComposition nonNavigableEnd navigableEnd validationWarnings |
	controller := OntoUMLTransformationController new.
	generalClass := OPUMLClass new name: 'Person'.
	specificClass := OPUMLClass new name: 'Student'.
	transformedGeneral := OPUMLClass new name: 'Person'.
	transformedSpecific := OPUMLClass new name: 'Student'.
	controller addTransformationLinkBetween: generalClass and: transformedGeneral.
	controller addTransformationLinkBetween: specificClass and: transformedSpecific.
	generalization := OPUMLGeneralization new
		                  general: generalClass;
		                  specific: specificClass;
		                  yourself.
	transformer := OntoUMLGeneralizationSetTransformer new
		               name: 'RoleGS - XOR';
		               yourself.

	resultComposition := OntoUMLTransformComposition
		                     transform: generalization
		                     withController: controller
		                     withTransformer: transformer.

	self assert: resultComposition class identicalTo: OPUMLAssociation.
	self assert: resultComposition name equals: 'RoleGS - XOR'.
	self assertCollection: controller transformedModel packagedElements hasSameElements: { resultComposition }.
	self assert: resultComposition memberEnds size equals: 2.

	nonNavigableEnd := resultComposition memberEnds first.
	navigableEnd := resultComposition memberEnds second.
	self assert: nonNavigableEnd type identicalTo: transformedGeneral.
	self assert: nonNavigableEnd owningAssociation identicalTo: resultComposition.
	self assert: nonNavigableEnd owningClass identicalTo: nil.
	self assert: nonNavigableEnd lowerValue value equals: 1.
	self assert: nonNavigableEnd upperValue value equals: 1.

	self assert: navigableEnd type identicalTo: transformedSpecific.
	self assert: navigableEnd owningAssociation identicalTo: nil.
	self assert: navigableEnd owningClass identicalTo: transformedGeneral.
	self assert: navigableEnd lowerValue value equals: 1.
	self assert: navigableEnd upperValue value equals: 1.

	validationWarnings := OrderedCollection new.
	[ (OPUmlAssociationViewModel new model: resultComposition) validate ]
		on: OPModelInvalid
		do: [ :warning |
				validationWarnings add: warning messageText.
				warning resume ].
	self assertEmpty: validationWarnings
]
