"
Unit tests verifying generalization set transformation strategy dispatch, group ordering, and composition/generalization selection across sortal and non-sortal OntoUML generalization sets.
"
Class {
	#name : 'OntoUMLGeneralizationSetTransformerTest',
	#superclass : 'OntoUMLAbstractTransformationTest',
	#category : 'OpenPonk-OntoUML-Transformations-Tests-Transformers',
	#package : 'OpenPonk-OntoUML-Transformations-Tests',
	#tag : 'Transformers'
}

{ #category : 'running' }
OntoUMLGeneralizationSetTransformerTest >> tearDown [

	OntoUMLGeneralizationSetTransformer savedTransformation: nil.
	super tearDown
]

{ #category : 'tests' }
OntoUMLGeneralizationSetTransformerTest >> testGeneralReturnsTransformedGeneralClassAndNameAccessors [

	| generalClass specificClass transformedGeneral generalizationSet transformer controller |
	generalClass := OPUMLClass new name: 'Person'.
	specificClass := OPUMLClass new name: 'Student'.
	generalizationSet := OPUMLGeneralizationSet new.
	generalizationSet generalizations add: (OPUMLGeneralization new
			 general: generalClass;
			 specific: specificClass;
			 yourself).
	controller := self newControllerWithTransformedClassesFor: {
			              generalClass.
			              specificClass }.
	transformedGeneral := controller getTransformedElementFrom: generalClass.

	transformer := OntoUMLGeneralizationSetTransformer new
		               controller: controller;
		               transformed: generalizationSet;
		               name: 'roles - XOR';
		               yourself.

	self assert: transformer general identicalTo: transformedGeneral.
	self assert: transformer name equals: 'roles - XOR'
]

{ #category : 'tests' }
OntoUMLGeneralizationSetTransformerTest >> testSavedTransformationAndDefaultTransformationAccessors [

	OntoUMLGeneralizationSetTransformer savedTransformation: 'Gen'.
	self assert: OntoUMLGeneralizationSetTransformer savedTransformation equals: 'Gen'.
	self
		assert: (OntoUMLGeneralizationSetTransformer defaultTransformation isKindOf: BlockClosure)
		description: 'defaultTransformation must answer a transformation block'
]

{ #category : 'tests' }
OntoUMLGeneralizationSetTransformerTest >> testTransformEmptyGeneralizationSetReturnsEmptyArray [

	| controller generalizationSet result |
	controller := OntoUMLTransformationController new.
	generalizationSet := OPUMLGeneralizationSet new.

	result := OntoUMLGeneralizationSetTransformer transform: generalizationSet withController: controller.

	self assertEmpty: result.
	self assertEmpty: controller transformedModel packagedElements
]

{ #category : 'tests' }
OntoUMLGeneralizationSetTransformerTest >> testTransformNonSortalGeneralizationSetCreatesGeneralizationsWithoutPackagedElements [

	| categoryClass kindClassA kindClassB generalizationSet controller transformedGeneral transformedSpecificA transformedSpecificB result |
	categoryClass := OPUMLClass new
		                 name: 'Agent';
		                 applyStereotype: OntoUMLCategory new;
		                 yourself.
	kindClassA := OPUMLClass new
		              name: 'Person';
		              applyStereotype: OntoUMLKind new;
		              yourself.
	kindClassB := OPUMLClass new
		              name: 'Organization';
		              applyStereotype: OntoUMLKind new;
		              yourself.
	generalizationSet := OPUMLGeneralizationSet new
		                     name: 'agentPartition';
		                     isDisjoint: true;
		                     isCovering: true;
		                     yourself.
	generalizationSet generalizations addAll: {
			(OPUMLGeneralization new
				 general: categoryClass;
				 specific: kindClassA;
				 yourself).
			(OPUMLGeneralization new
				 general: categoryClass;
				 specific: kindClassB;
				 yourself) }.
	controller := self newControllerWithTransformedClassesFor: {
			              categoryClass.
			              kindClassA.
			              kindClassB }.

	result := OntoUMLGeneralizationSetTransformer transform: generalizationSet withController: controller.

	transformedGeneral := controller getTransformedElementFrom: categoryClass.
	transformedSpecificA := controller getTransformedElementFrom: kindClassA.
	transformedSpecificB := controller getTransformedElementFrom: kindClassB.
	self assert: result size equals: 2.
	self assert: transformedGeneral isAbstract description: 'Covering generalization set must mark general class abstract'.
	self assert: transformedSpecificA generalizations size equals: 1.
	self assert: transformedSpecificA generalizations first general identicalTo: transformedGeneral.
	self assert: transformedSpecificB generalizations size equals: 1.
	self assert: transformedSpecificB generalizations first general identicalTo: transformedGeneral.
	self assertEmpty: controller transformedModel packagedElements
]

{ #category : 'tests' }
OntoUMLGeneralizationSetTransformerTest >> testTransformSortalGeneralizationSetDispatchesAllGroupsIncludingPhaseMixinAndUnstereotyped [

	| kindClass phaseClass roleClass phaseMixinClass roleMixinClass mixinClass subKindClass plainClass generalizationSet controller result transformedAssociations transformedSubKind transformedPlain |
	kindClass := OPUMLClass new
		             name: 'Entity';
		             applyStereotype: OntoUMLKind new;
		             yourself.
	phaseClass := OPUMLClass new
		              name: 'ActivePhase';
		              applyStereotype: OntoUMLPhase new;
		              yourself.
	roleClass := OPUMLClass new
		             name: 'WorkerRole';
		             applyStereotype: OntoUMLRole new;
		             yourself.
	phaseMixinClass := OPUMLClass new
		                   name: 'TempPhaseMixin';
		                   applyStereotype: OntoUMLPhaseMixin new;
		                   yourself.
	roleMixinClass := OPUMLClass new
		                  name: 'ClientRoleMixin';
		                  applyStereotype: OntoUMLRoleMixin new;
		                  yourself.
	mixinClass := OPUMLClass new
		              name: 'MixedAspect';
		              applyStereotype: OntoUMLMixin new;
		              yourself.
	subKindClass := OPUMLClass new
		                name: 'RigidSubKind';
		                applyStereotype: OntoUMLSubKind new;
		                yourself.
	plainClass := OPUMLClass new name: 'PlainSubclass'.
	generalizationSet := OPUMLGeneralizationSet new
		                     name: 'mixed';
		                     isDisjoint: true;
		                     yourself.
	generalizationSet generalizations addAll: ({
			 phaseClass.
			 roleClass.
			 phaseMixinClass.
			 roleMixinClass.
			 mixinClass.
			 subKindClass.
			 plainClass } collect: [ :specificClass |
				 OPUMLGeneralization new
					 general: kindClass;
					 specific: specificClass;
					 yourself ]).
	controller := self newControllerWithTransformedClassesFor: {
			              kindClass.
			              phaseClass.
			              roleClass.
			              phaseMixinClass.
			              roleMixinClass.
			              mixinClass.
			              subKindClass.
			              plainClass }.

	OntoUMLGeneralizationSetTransformer instVarNamed: #transformationIndex put: nil.
	result := [ OntoUMLGeneralizationSetTransformer transform: generalizationSet withController: controller ] ensure: [
		          OntoUMLGeneralizationSetTransformer initializeTransformationIndex ].

	transformedAssociations := controller transformedModel packagedElements select: [ :each | each isKindOf: OPUMLAssociation ].
	self assert: result size equals: 6.
	self assert: transformedAssociations size equals: 5.
	self
		assertCollection: (transformedAssociations collect: [ :each | each memberEnds second type name ])
		hasSameElements: #( 'ActivePhase' 'WorkerRole' 'TempPhaseMixin' 'ClientRoleMixin' 'MixedAspect' ).
	transformedAssociations do: [ :each | self assert: each name equals: 'mixed - XOR' ].
	self assertEmpty: (self collectAssociationValidationWarningsIn: controller transformedModel).

	transformedSubKind := controller getTransformedElementFrom: subKindClass.
	transformedPlain := controller getTransformedElementFrom: plainClass.
	self assert: transformedSubKind generalizations size equals: 1.
	self assert: transformedPlain generalizations size equals: 1.
	self assert: transformedPlain generalizations first general identicalTo: (controller getTransformedElementFrom: kindClass).
	self assertEmpty: (controller transformedModel packagedElements select: [ :each | each isKindOf: OPUMLGeneralization ])
]
