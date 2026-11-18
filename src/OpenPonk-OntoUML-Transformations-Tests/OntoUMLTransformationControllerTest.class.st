"
Unit tests verifying full-model OntoUML-to-UML transformation orchestration and element mapping on the transformation controller.
"
Class {
	#name : 'OntoUMLTransformationControllerTest',
	#superclass : 'OntoUMLAbstractTransformationTest',
	#category : 'OpenPonk-OntoUML-Transformations-Tests-Controllers',
	#package : 'OpenPonk-OntoUML-Transformations-Tests',
	#tag : 'Controllers'
}

{ #category : 'utilities' }
OntoUMLTransformationControllerTest >> buildSampleOntoUMLPackage [

	| sourcePackage personClass studentClass employeeClass subKindClass beerClass alcoholClass regularAssociation subQuantityAssociation selfAssociation |
	sourcePackage := OPUMLPackage new name: 'Sample OntoUML'.
	personClass := self newStereotypedClassNamed: 'Person' stereotype: OntoUMLKind new.
	OPUMLProperty new
		name: 'fullName';
		owningClass: personClass.
	OPUMLOperation new
		name: 'identify';
		owningClass: personClass.
	studentClass := self newStereotypedClassNamed: 'Student' stereotype: OntoUMLRole new.
	employeeClass := self newStereotypedClassNamed: 'Employee' stereotype: OntoUMLRole new.
	subKindClass := self newStereotypedClassNamed: 'Adult' stereotype: OntoUMLSubKind new.
	beerClass := self newStereotypedClassNamed: 'Beer' stereotype: OntoUMLQuantity new.
	alcoholClass := self newStereotypedClassNamed: 'Alcohol' stereotype: OntoUMLQuantity new.
	OPUMLGeneralization new
		general: personClass;
		specific: subKindClass.
	regularAssociation := self createAssociationFrom: personClass to: beerClass with: OntoUMLMaterial new.
	regularAssociation name: 'drinks'.
	subQuantityAssociation := self createAssociationFrom: beerClass to: alcoholClass with: OntoUMLSubQuantityOf new.
	subQuantityAssociation memberEnds second aggregation: OPUMLAggregationKind composite.
	selfAssociation := (self createAssociationFrom: personClass to: personClass)
		                   name: 'knows';
		                   yourself.
	sourcePackage packagedElements addAll: {
			personClass.
			studentClass.
			employeeClass.
			subKindClass.
			beerClass.
			alcoholClass.
			regularAssociation.
			subQuantityAssociation.
			selfAssociation.
			(self newDisjointGeneralizationSetNamed: 'personRoles' general: personClass specifics: {
					 studentClass.
					 employeeClass }) }.
	^ sourcePackage
]

{ #category : 'utilities' }
OntoUMLTransformationControllerTest >> collectValidationWarningsIn: aUMLPackage [

	| validationWarnings |
	validationWarnings := OrderedCollection new.
	[
		aUMLPackage packagedElements
			select: [ :each | each isKindOf: OPUMLAssociation ]
			thenDo: [ :association | (OPUmlAssociationViewModel new model: association) validate ].
		aUMLPackage packagedElements select: [ :each | each isKindOf: OPUMLClass ] thenDo: [ :eachClass |
				eachClass ownedAttributes do: [ :property | (OPUmlClassPropertyViewModel new model: property) validate ].
				eachClass ownedOperations do: [ :operation | (OPUmlOperationViewModel new model: operation) validate ] ] ]
		on: OPModelInvalid
		do: [ :warning |
				validationWarnings add: warning messageText.
				warning resume ].
	^ validationWarnings
]

{ #category : 'utilities' }
OntoUMLTransformationControllerTest >> newDisjointGeneralizationSetNamed: aName general: aGeneralClass specifics: aSpecificClasses [

	| generalizationSet |
	generalizationSet := OPUMLGeneralizationSet new
		                     name: aName;
		                     isDisjoint: true;
		                     yourself.
	generalizationSet generalizations addAll: (aSpecificClasses collect: [ :specificClass |
				 OPUMLGeneralization new
					 general: aGeneralClass;
					 specific: specificClass;
					 yourself ]).
	^ generalizationSet
]

{ #category : 'utilities' }
OntoUMLTransformationControllerTest >> newStereotypedClassNamed: aName stereotype: aStereotype [

	^ OPUMLClass new
		  name: aName;
		  applyStereotype: aStereotype;
		  yourself
]

{ #category : 'tests' }
OntoUMLTransformationControllerTest >> testControllerAccessorsAndElementRegistration [

	| controller originalElements sourceElement transformedElement extraElement |
	controller := OntoUMLTransformationController new.
	sourceElement := OPUMLClass new name: 'Source'.
	transformedElement := OPUMLClass new name: 'Transformed'.
	extraElement := OPUMLAssociation new name: 'Extra'.
	originalElements := { sourceElement }.

	controller originalModel: originalElements.
	controller addTransformationLinkBetween: sourceElement and: transformedElement.
	controller addElementToTransformedModel: transformedElement.
	controller addElementToTransformedModel: extraElement.

	self assert: controller originalModel identicalTo: originalElements.
	self assert: (controller getTransformedElementFrom: sourceElement) identicalTo: transformedElement.
	self assert: controller transformedElements size equals: 1.
	self assertCollection: controller transformedModel packagedElements hasSameElements: {
			transformedElement.
			extraElement }
]

{ #category : 'tests' }
OntoUMLTransformationControllerTest >> testInitializationCreatesEmptyTransformedModelAndMap [

	| controller |
	controller := OntoUMLTransformationController new.
	self assert: controller transformedModel class identicalTo: OPUMLPackage.
	self assert: controller transformedModel name equals: 'UML Model'.
	self assertEmpty: controller transformedModel packagedElements.
	self assertEmpty: controller transformedElements.
	self assert: controller originalModel identicalTo: nil
]

{ #category : 'tests' }
OntoUMLTransformationControllerTest >> testTransformModelTransformsFullOntoUMLPackage [

	| sourcePackage resultModel transformedClasses transformedAssociations transformedGeneralizations personClass |
	sourcePackage := self buildSampleOntoUMLPackage.

	resultModel := OntoUMLTransformationController transformModel: sourcePackage.

	self assert: OntoUMLGeneralizationSetTransformer savedTransformation identicalTo: nil.
	self assert: resultModel class identicalTo: OPUMLPackage.
	self assert: resultModel name equals: 'UML Model'.

	transformedClasses := resultModel packagedElements select: [ :each | each isKindOf: OPUMLClass ].
	transformedAssociations := resultModel packagedElements select: [ :each | each isKindOf: OPUMLAssociation ].
	transformedGeneralizations := transformedClasses flatCollect: #generalizations.

	self
		assertCollection: (transformedClasses collect: #name)
		hasSameElements: #( 'Person' 'Student' 'Employee' 'Adult' 'Beer' 'Alcohol' ).
	personClass := transformedClasses detect: [ :each | each name = 'Person' ].
	self assertCollection: (personClass ownedAttributes collect: #name) includesAll: #( 'fullName' ).
	self assertCollection: (personClass ownedOperations collect: #name) hasSameElements: #( 'identify' ).
	self
		assertCollection: (transformedAssociations collect: #name)
		hasSameElements: #( 'drinks' 'containment' 'personRoles - XOR' 'personRoles - XOR' ).
	self assertEmpty: (resultModel packagedElements select: [ :each | each isKindOf: OPUMLGeneralization ]).
	self assert: transformedGeneralizations size equals: 1.
	self assert: transformedGeneralizations first specific name equals: 'Adult'.
	self assert: transformedGeneralizations first general name equals: 'Person'.
	self assertEmpty: (self collectValidationWarningsIn: resultModel)
]
