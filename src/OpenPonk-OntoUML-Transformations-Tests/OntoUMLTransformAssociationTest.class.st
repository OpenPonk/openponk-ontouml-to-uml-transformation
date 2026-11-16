"
I am a unit test class verifying the accurate mapping and structural conversion of OntoUML associations into standard UML associations during transformation.
"
Class {
	#name : 'OntoUMLTransformAssociationTest',
	#superclass : 'OntoUMLAbstractTransformationTest',
	#category : 'OpenPonk-OntoUML-Transformations-Tests-Transformations',
	#package : 'OpenPonk-OntoUML-Transformations-Tests',
	#tag : 'Transformations'
}

{ #category : 'tests' }
OntoUMLTransformAssociationTest >> testCreateAssociationCopiesMultiplicities [

	| controller sourceClass targetClass transformedSource transformedTarget association transformer resultAssociation sourceLower sourceUpper resultFirstEnd |
	controller := OntoUMLTransformationController new.
	sourceClass := OPUMLClass new name: 'Source'.
	targetClass := OPUMLClass new name: 'Target'.
	transformedSource := OPUMLClass new name: 'Source'.
	transformedTarget := OPUMLClass new name: 'Target'.
	controller addTransformationLinkBetween: sourceClass and: transformedSource.
	controller addTransformationLinkBetween: targetClass and: transformedTarget.

	association := self createAssociationFrom: sourceClass to: targetClass.
	sourceLower := OPUMLLiteralInteger new value: 0.
	sourceUpper := OPUMLLiteralUnlimitedNatural new value: '*'.
	association memberEnds first
		lowerValue: sourceLower;
		upperValue: sourceUpper.

	transformer := OntoUMLTransformAssociation
		               newWithTransformed: association
		               withController: controller
		               withTransformer: OntoUMLAssociationTransformer new.

	resultAssociation := transformer createAssociation.
	resultFirstEnd := resultAssociation memberEnds first.
	self assert: resultFirstEnd lowerValue value equals: 0.
	self assert: resultFirstEnd upperValue value equals: '*'.
	self deny: resultFirstEnd lowerValue identicalTo: sourceLower.
	self deny: resultFirstEnd upperValue identicalTo: sourceUpper
]

{ #category : 'tests' }
OntoUMLTransformAssociationTest >> testCreateAssociationValidatesWithoutUiController [

	| controller sourceClass targetClass transformedSource transformedTarget association transformer resultAssociation |
	controller := OntoUMLTransformationController new.
	sourceClass := OPUMLClass new name: 'Source'.
	targetClass := OPUMLClass new name: 'Target'.
	transformedSource := OPUMLClass new name: 'Source'.
	transformedTarget := OPUMLClass new name: 'Target'.
	controller addTransformationLinkBetween: sourceClass and: transformedSource.
	controller addTransformationLinkBetween: targetClass and: transformedTarget.

	association := self createAssociationFrom: sourceClass to: targetClass.
	association name: 'rel'.
	association isDerived: false.

	transformer := OntoUMLTransformAssociation
		               newWithTransformed: association
		               withController: controller
		               withTransformer: OntoUMLAssociationTransformer new.

	resultAssociation := transformer createAssociation.
	self assert: resultAssociation class identicalTo: OPUMLAssociation.
	self deny: resultAssociation identicalTo: association.
	self assert: resultAssociation name equals: 'rel'.
	self deny: resultAssociation isDerived description: 'Transformed association must preserve isDerived = false'.
	self assert: resultAssociation memberEnds size equals: 2.
	self assert: resultAssociation memberEnds first type identicalTo: transformedSource.
	self assert: resultAssociation memberEnds second type identicalTo: transformedTarget.
	self assert: resultAssociation memberEnds first owningAssociation identicalTo: resultAssociation.
	self assert: resultAssociation memberEnds second owningAssociation identicalTo: resultAssociation
]

{ #category : 'tests' }
OntoUMLTransformAssociationTest >> testTransformAddsAssociationAndCopiesNavigableEndAndComments [

	| controller sourceClass targetClass transformedSource transformedTarget association sourceComment resultAssociation navigableEnd nonNavigableEnd |
	controller := OntoUMLTransformationController new.
	sourceClass := OPUMLClass new name: 'Source'.
	targetClass := OPUMLClass new name: 'Target'.
	transformedSource := OPUMLClass new name: 'Source'.
	transformedTarget := OPUMLClass new name: 'Target'.
	controller addTransformationLinkBetween: sourceClass and: transformedSource.
	controller addTransformationLinkBetween: targetClass and: transformedTarget.

	association := OPUMLAssociation new
		               name: 'linksTo';
		               isDerived: true;
		               yourself.
	OPUMLProperty new
		name: 'targetRole';
		isStatic: false;
		isReadOnly: true;
		isDerived: true;
		isOrdered: true;
		isUnique: false;
		visibility: OPUMLVisibilityKind public;
		aggregation: OPUMLAggregationKind shared;
		owningClass: sourceClass;
		type: targetClass;
		association: association.
	OPUMLProperty new
		name: 'sourceRole';
		owningAssociation: association;
		type: sourceClass.
	association memberEnds
		add: sourceClass ownedAttributes first;
		add: association ownedEnds first.
	sourceComment := OPUMLComment new body: 'Assoc note'.
	association ownedComments: { sourceComment }.

	resultAssociation := OntoUMLTransformAssociation
		                     transform: association
		                     withController: controller
		                     withTransformer: OntoUMLAssociationTransformer new.

	self assert: (controller getTransformedElementFrom: association) identicalTo: resultAssociation.
	self assertCollection: controller transformedModel packagedElements hasSameElements: { resultAssociation }.
	self assert: resultAssociation isDerived description: 'Transformed association must preserve isDerived'.
	self assert: resultAssociation ownedComments size equals: 1.
	self assert: resultAssociation ownedComments first body equals: 'Assoc note'.
	self deny: resultAssociation ownedComments first identicalTo: sourceComment.

	navigableEnd := resultAssociation memberEnds first.
	nonNavigableEnd := resultAssociation memberEnds second.
	self assert: navigableEnd name equals: 'targetRole'.
	self assert: navigableEnd owningClass identicalTo: transformedSource.
	self assert: navigableEnd owningAssociation identicalTo: nil.
	self assert: navigableEnd type identicalTo: transformedTarget.
	self assert: navigableEnd aggregation identicalTo: OPUMLAggregationKind shared.
	self assert: navigableEnd isReadOnly description: 'Transformed association end must preserve isReadOnly'.
	self assert: navigableEnd isDerived description: 'Transformed association end must preserve isDerived'.
	self assert: navigableEnd isOrdered description: 'Transformed association end must preserve isOrdered'.
	self deny: navigableEnd isUnique description: 'Transformed association end must preserve isUnique = false'.
	self assert: navigableEnd visibility equals: OPUMLVisibilityKind public.
	self assert: nonNavigableEnd owningAssociation identicalTo: resultAssociation.
	self assert: nonNavigableEnd owningClass identicalTo: nil
]
