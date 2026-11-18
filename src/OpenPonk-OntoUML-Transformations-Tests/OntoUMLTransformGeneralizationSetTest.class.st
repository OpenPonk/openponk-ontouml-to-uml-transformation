"
Unit tests verifying generalization set refactoring strategies, combination generation, attribute/operation copying, composition validation, and naming edge cases.
"
Class {
	#name : 'OntoUMLTransformGeneralizationSetTest',
	#superclass : 'OntoUMLAbstractTransformationTest',
	#category : 'OpenPonk-OntoUML-Transformations-Tests-Transformations',
	#package : 'OpenPonk-OntoUML-Transformations-Tests',
	#tag : 'Transformations'
}

{ #category : 'utilities' }
OntoUMLTransformGeneralizationSetTest >> newGeneralizationSetWithGeneral: aGeneralClass specifics: aSpecificClasses named: aName [

	| generalizationSet |
	generalizationSet := OPUMLGeneralizationSet new
		                     name: aName;
		                     yourself.
	generalizationSet generalizations addAll: (aSpecificClasses collect: [ :specificClass |
				 OPUMLGeneralization new
					 general: aGeneralClass;
					 specific: specificClass;
					 yourself ]).
	^ generalizationSet
]

{ #category : 'running' }
OntoUMLTransformGeneralizationSetTest >> tearDown [

	OntoUMLGeneralizationSetTransformer savedTransformation: nil.
	super tearDown
]

{ #category : 'tests' }
OntoUMLTransformGeneralizationSetTest >> testSetNameHandlesNamedGeneralNilNamesAndExistingXorSuffix [

	| generalClass specificClass generalizationSet controller transformer transformation |
	generalClass := OPUMLClass new name: 'Person'.
	specificClass := OPUMLClass new name: 'Student'.
	generalizationSet := self newGeneralizationSetWithGeneral: generalClass specifics: { specificClass } named: nil.
	controller := self newControllerWithTransformedClassesFor: {
			              generalClass.
			              specificClass }.
	transformer := OntoUMLGeneralizationSetTransformer new
		               controller: controller;
		               transformed: generalizationSet;
		               yourself.
	transformation := OntoUMLTransformGeneralizationSet
		                  newWithTransformed: generalizationSet generalizations
		                  withController: controller
		                  withTransformer: transformer.

	transformation setName.
	self assert: transformer name equals: 'Person - XOR'.

	"A second call must preserve an existing XOR suffix instead of appending another"
	transformation setName.
	self assert: transformer name equals: 'Person - XOR'.

	generalClass name: nil.
	(controller getTransformedElementFrom: generalClass) name: nil.
	transformer name: nil.
	transformation setName.
	self assert: transformer name equals: ' - XOR'.

	generalizationSet name: 'roles'.
	transformer name: nil.
	transformation setName.
	self assert: transformer name equals: 'roles - XOR'
]

{ #category : 'tests' }
OntoUMLTransformGeneralizationSetTest >> testTransformDisjointGeneralizationCreatesGeneralizationsWithoutPackagedElements [

	| generalClass specificA specificB generalizationSet controller transformer result transformedGeneral transformedA transformedB |
	generalClass := OPUMLClass new name: 'Person'.
	specificA := OPUMLClass new name: 'Child'.
	specificB := OPUMLClass new name: 'Adult'.
	generalizationSet := (self
		                      newGeneralizationSetWithGeneral: generalClass
		                      specifics: {
				                      specificA.
				                      specificB }
		                      named: 'ageGroup')
		                     isDisjoint: true;
		                     isCovering: true;
		                     yourself.
	controller := self newControllerWithTransformedClassesFor: {
			              generalClass.
			              specificA.
			              specificB }.
	transformer := OntoUMLGeneralizationSetTransformer new
		               controller: controller;
		               transformed: generalizationSet;
		               yourself.

	result := OntoUMLTransformGeneralizationSet
		          transform: generalizationSet generalizations
		          withController: controller
		          withTransformer: transformer.

	transformedGeneral := controller getTransformedElementFrom: generalClass.
	transformedA := controller getTransformedElementFrom: specificA.
	transformedB := controller getTransformedElementFrom: specificB.
	self assert: result size equals: 2.
	self assert: transformedGeneral isAbstract description: 'Covering generalization set must mark general class abstract'.
	self assert: transformedA generalizations size equals: 1.
	self assert: transformedA generalizations first general identicalTo: transformedGeneral.
	self assert: transformedB generalizations size equals: 1.
	self assert: transformedB generalizations first general identicalTo: transformedGeneral.
	self assertEmpty: controller transformedModel packagedElements
]

{ #category : 'tests' }
OntoUMLTransformGeneralizationSetTest >> testTransformReturnsNilForUnknownSelection [

	| generalClass specificA specificB generalizationSet controller transformer result |
	generalClass := OPUMLClass new name: 'Person'.
	specificA := OPUMLClass new name: 'Student'.
	specificB := OPUMLClass new name: 'Employee'.
	generalizationSet := (self
		                      newGeneralizationSetWithGeneral: generalClass
		                      specifics: {
				                      specificA.
				                      specificB }
		                      named: 'roles')
		                     isDisjoint: false;
		                     yourself.
	controller := self newControllerWithTransformedClassesFor: {
			              generalClass.
			              specificA.
			              specificB }.
	transformer := OntoUMLGeneralizationSetTransformer new
		               controller: controller;
		               transformed: generalizationSet;
		               yourself.
	OntoUMLGeneralizationSetTransformer savedTransformation: 'InvalidChoice'.

	result := OntoUMLTransformGeneralizationSet
		          transform: generalizationSet generalizations
		          withController: controller
		          withTransformer: transformer.

	self assert: result identicalTo: nil.
	self assertEmpty: controller transformedModel packagedElements
]

{ #category : 'tests' }
OntoUMLTransformGeneralizationSetTest >> testTransformWithCompSelectionCreatesCompositionsForDisjointAndOverlappingSets [

	| generalClass specificA specificB overlappingSet disjointSet controller transformer overlappingCompositions disjointCompositions |
	generalClass := OPUMLClass new name: 'Person'.
	specificA := OPUMLClass new name: 'Student'.
	specificB := OPUMLClass new name: 'Employee'.
	overlappingSet := (self
		                   newGeneralizationSetWithGeneral: generalClass
		                   specifics: {
				                   specificA.
				                   specificB }
		                   named: 'roles')
		                  isDisjoint: false;
		                  yourself.
	controller := self newControllerWithTransformedClassesFor: {
			              generalClass.
			              specificA.
			              specificB }.
	transformer := OntoUMLGeneralizationSetTransformer new
		               controller: controller;
		               transformed: overlappingSet;
		               yourself.
	OntoUMLGeneralizationSetTransformer savedTransformation: 'Comp'.

	overlappingCompositions := OntoUMLTransformGeneralizationSet
		                           transform: overlappingSet generalizations
		                           withController: controller
		                           withTransformer: transformer.

	self assert: overlappingCompositions size equals: 2.
	overlappingCompositions do: [ :each | self assert: each name identicalTo: nil ].
	self assertEmpty: (self collectAssociationValidationWarningsIn: controller transformedModel).

	disjointSet := (self
		                newGeneralizationSetWithGeneral: generalClass
		                specifics: {
				                specificA.
				                specificB }
		                named: 'roles')
		               isDisjoint: true;
		               yourself.
	controller := self newControllerWithTransformedClassesFor: {
			              generalClass.
			              specificA.
			              specificB }.
	transformer := OntoUMLGeneralizationSetTransformer new
		               controller: controller;
		               transformed: disjointSet;
		               yourself.

	disjointCompositions := OntoUMLTransformGeneralizationSet
		                        transformAsComposition: disjointSet generalizations
		                        withController: controller
		                        withTransformer: transformer.

	self assert: disjointCompositions size equals: 2.
	disjointCompositions do: [ :each | self assert: each name equals: 'roles - XOR' ].
	self assertEmpty: (self collectAssociationValidationWarningsIn: controller transformedModel)
]

{ #category : 'tests' }
OntoUMLTransformGeneralizationSetTest >> testTransformWithGenAndCompSelectionCreatesValidCompositionsAndCombinations [

	| generalClass specificA specificB generalizationSet controller transformer result transformedClasses combinedClass transformedAssociations |
	generalClass := OPUMLClass new name: 'Person'.
	specificA := OPUMLClass new name: 'Student'.
	specificB := OPUMLClass new name: 'Employee'.
	generalizationSet := (self
		                      newGeneralizationSetWithGeneral: generalClass
		                      specifics: {
				                      specificA.
				                      specificB }
		                      named: 'roles')
		                     isDisjoint: false;
		                     isCovering: true;
		                     yourself.
	controller := self newControllerWithTransformedClassesFor: {
			              generalClass.
			              specificA.
			              specificB }.
	transformer := OntoUMLGeneralizationSetTransformer new
		               controller: controller;
		               transformed: generalizationSet;
		               yourself.
	OntoUMLGeneralizationSetTransformer savedTransformation: 'GenAndComp'.

	result := OntoUMLTransformGeneralizationSet
		          transform: generalizationSet generalizations
		          withController: controller
		          withTransformer: transformer.

	transformedClasses := controller transformedModel packagedElements select: [ :each | each isKindOf: OPUMLClass ].
	transformedAssociations := controller transformedModel packagedElements select: [ :each | each isKindOf: OPUMLAssociation ].
	self assert: result size equals: 6.
	self
		assert: (controller getTransformedElementFrom: generalClass) isAbstract
		description: 'Covering set must mark general class abstract'.
	self assertCollection: (transformedClasses collect: #name) hasSameElements: #( 'StudentEmployee' ).
	combinedClass := transformedClasses first.
	self assert: combinedClass generalizations size equals: 1.
	self assert: combinedClass generalizations first general identicalTo: (controller getTransformedElementFrom: generalClass).
	self assert: transformedAssociations size equals: 2.
	self assertCollection: (transformedAssociations collect: [ :each | each memberEnds first type ]) hasSameElements: {
			(controller getTransformedElementFrom: specificA).
			(controller getTransformedElementFrom: specificB) }.
	transformedAssociations do: [ :each |
			self assert: each memberEnds size equals: 2.
			self assert: each memberEnds first owningClass identicalTo: combinedClass.
			self assert: each memberEnds second type identicalTo: combinedClass.
			self assert: each memberEnds second owningAssociation identicalTo: each ].
	self assertEmpty: (self collectAssociationValidationWarningsIn: controller transformedModel).
	self assertEmpty: (controller transformedModel packagedElements select: [ :each | each isKindOf: OPUMLGeneralization ])
]

{ #category : 'tests' }
OntoUMLTransformGeneralizationSetTest >> testTransformWithGenSelectionCreatesCombinationsWithFullAttributesAndOperations [

	| generalClass specificA specificB attrComment studentAttr associationEnd studentOp employeeAttr employeeOp generalizationSet controller transformer result transformedClasses combinedClass copiedAttr copiedOp validationWarnings |
	generalClass := OPUMLClass new name: 'Person'.
	specificA := OPUMLClass new name: 'Student'.
	specificB := OPUMLClass new name: 'Employee'.
	attrComment := OPUMLComment new body: 'GPA note'.
	studentAttr := OPUMLProperty new
		               name: 'gpa';
		               isStatic: true;
		               isReadOnly: true;
		               isDerived: true;
		               isOrdered: true;
		               isUnique: false;
		               visibility: OPUMLVisibilityKind private;
		               lowerValue: (OPUMLLiteralInteger new value: 0);
		               upperValue: (OPUMLLiteralUnlimitedNatural new value: 1);
		               owningClass: specificA;
		               yourself.
	studentAttr ownedComments: { attrComment }.
	associationEnd := OPUMLProperty new
		                  name: 'navEnd';
		                  owningClass: specificA;
		                  association: OPUMLAssociation new;
		                  yourself.
	studentOp := OPUMLOperation new
		             name: 'enroll';
		             isAbstract: true;
		             visibility: OPUMLVisibilityKind protected;
		             owningClass: specificA;
		             yourself.
	employeeAttr := OPUMLProperty new
		                name: 'salary';
		                owningClass: specificB;
		                yourself.
	employeeOp := OPUMLOperation new
		              name: 'work';
		              owningClass: specificB;
		              yourself.
	generalizationSet := (self
		                      newGeneralizationSetWithGeneral: generalClass
		                      specifics: {
				                      specificA.
				                      specificB }
		                      named: 'roles')
		                     isDisjoint: false;
		                     isCovering: true;
		                     yourself.
	controller := self newControllerWithTransformedClassesFor: {
			              generalClass.
			              specificA.
			              specificB }.
	transformer := OntoUMLGeneralizationSetTransformer new
		               controller: controller;
		               transformed: generalizationSet;
		               yourself.
	OntoUMLGeneralizationSetTransformer savedTransformation: 'Gen'.

	result := OntoUMLTransformGeneralizationSet
		          transform: generalizationSet generalizations
		          withController: controller
		          withTransformer: transformer.

	transformedClasses := controller transformedModel packagedElements select: [ :each | each isKindOf: OPUMLClass ].
	self assert: result size equals: 4.
	self assertCollection: (transformedClasses collect: #name) hasSameElements: #( 'StudentEmployee' ).
	combinedClass := transformedClasses first.
	self assertCollection: (combinedClass ownedAttributes collect: #name) hasSameElements: #( 'gpa' 'salary' ).
	self assertCollection: (combinedClass ownedOperations collect: #name) hasSameElements: #( 'enroll' 'work' ).
	copiedAttr := combinedClass ownedAttributes detect: [ :each | each name = 'gpa' ].
	self deny: copiedAttr identicalTo: studentAttr.
	self assert: copiedAttr owningClass identicalTo: combinedClass.
	self assert: copiedAttr owner identicalTo: nil.
	self assert: copiedAttr isStatic description: 'Combined attribute must preserve isStatic'.
	self assert: copiedAttr isReadOnly description: 'Combined attribute must preserve isReadOnly'.
	self assert: copiedAttr isDerived description: 'Combined attribute must preserve isDerived'.
	self assert: copiedAttr isOrdered description: 'Combined attribute must preserve isOrdered'.
	self deny: copiedAttr isUnique description: 'Combined attribute must preserve isUnique = false'.
	self assert: copiedAttr visibility equals: OPUMLVisibilityKind private.
	self assert: copiedAttr lowerValue value equals: 0.
	self assert: copiedAttr upperValue value equals: 1.
	self assert: copiedAttr ownedComments size equals: 1.
	self assert: copiedAttr ownedComments first body equals: 'GPA note'.
	self deny: copiedAttr ownedComments first identicalTo: attrComment.

	copiedOp := combinedClass ownedOperations detect: [ :each | each name = 'enroll' ].
	self assert: copiedOp owningClass identicalTo: combinedClass.
	self assert: copiedOp isAbstract description: 'Combined operation must preserve isAbstract'.
	self assert: copiedOp visibility equals: OPUMLVisibilityKind protected.

	validationWarnings := OrderedCollection new.
	combinedClass ownedAttributes do: [ :property |
			[ (OPUmlClassPropertyViewModel new model: property) validate ]
				on: OPModelInvalid
				do: [ :warning |
						validationWarnings add: warning messageText.
						warning resume ] ].
	combinedClass ownedOperations do: [ :operation |
			[ (OPUmlOperationViewModel new model: operation) validate ]
				on: OPModelInvalid
				do: [ :warning |
						validationWarnings add: warning messageText.
						warning resume ] ].
	self assertEmpty: validationWarnings.
	self assert: (controller getTransformedElementFrom: specificA) generalizations size equals: 1.
	self assert: (controller getTransformedElementFrom: specificB) generalizations size equals: 1.
	self assertEmpty: (controller transformedModel packagedElements select: [ :each | each isKindOf: OPUMLGeneralization ])
]

{ #category : 'tests' }
OntoUMLTransformGeneralizationSetTest >> testTransformWithGenSelectionSupportsThreeSpecificsAndNilNames [

	| generalClass specificA specificB specificC generalizationSet controller transformedClasses |
	generalClass := OPUMLClass new name: 'Person'.
	specificA := OPUMLClass new name: 'A'.
	specificB := OPUMLClass new name: nil.
	specificC := OPUMLClass new name: 'C'.
	generalizationSet := (self
		                      newGeneralizationSetWithGeneral: generalClass
		                      specifics: {
				                      specificA.
				                      specificB.
				                      specificC }
		                      named: 'threeRoles')
		                     isDisjoint: false;
		                     yourself.
	controller := self newControllerWithTransformedClassesFor: {
			              generalClass.
			              specificA.
			              specificB.
			              specificC }.
	OntoUMLGeneralizationSetTransformer savedTransformation: 'Gen'.

	OntoUMLTransformGeneralizationSet
		transform: generalizationSet generalizations
		withController: controller
		withTransformer: (OntoUMLGeneralizationSetTransformer new
				 controller: controller;
				 transformed: generalizationSet;
				 yourself).

	transformedClasses := controller transformedModel packagedElements select: [ :each | each isKindOf: OPUMLClass ].
	self assertCollection: (transformedClasses collect: #name) hasSameElements: #( 'A' 'AC' 'C' 'AC' ).

	controller := self newControllerWithTransformedClassesFor: {
			              generalClass.
			              specificA.
			              specificB }.
	OntoUMLGeneralizationSetTransformer savedTransformation: 'GenAndComp'.

	OntoUMLTransformGeneralizationSet
		transform: (generalizationSet generalizations asArray first: 2)
		withController: controller
		withTransformer: (OntoUMLGeneralizationSetTransformer new
				 controller: controller;
				 transformed: generalizationSet;
				 yourself).

	transformedClasses := controller transformedModel packagedElements select: [ :each | each isKindOf: OPUMLClass ].
	self assertCollection: (transformedClasses collect: #name) hasSameElements: #( 'A' )
]
