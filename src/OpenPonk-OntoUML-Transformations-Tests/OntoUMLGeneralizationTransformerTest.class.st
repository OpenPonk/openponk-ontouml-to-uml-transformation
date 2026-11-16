"
Unit tests verifying generalization transformer strategy selection for anti-rigid, mixin, and rigid classifiers.
"
Class {
	#name : 'OntoUMLGeneralizationTransformerTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-OntoUML-Transformations-Tests-Transformers',
	#package : 'OpenPonk-OntoUML-Transformations-Tests',
	#tag : 'Transformers'
}

{ #category : 'tests' }
OntoUMLGeneralizationTransformerTest >> testGetTransformationMapsAntiRigidAndMixinSpecificsToComposition [

	| phaseClass roleClass mixinClass roleMixinClass subKindClass plainClass |
	phaseClass := OPUMLClass new
		              applyStereotype: OntoUMLPhase new;
		              yourself.
	roleClass := OPUMLClass new
		             applyStereotype: OntoUMLRole new;
		             yourself.
	mixinClass := OPUMLClass new
		              applyStereotype: OntoUMLMixin new;
		              yourself.
	roleMixinClass := OPUMLClass new
		                  applyStereotype: OntoUMLRoleMixin new;
		                  yourself.
	subKindClass := OPUMLClass new
		                applyStereotype: OntoUMLSubKind new;
		                yourself.
	plainClass := OPUMLClass new.

	OntoUMLGeneralizationTransformer instVarNamed: #transformationIndex put: nil.
	[
		{
			phaseClass.
			roleClass.
			mixinClass.
			roleMixinClass } do: [ :each |
			self assert: (OntoUMLGeneralizationTransformer getTransformation: each) identicalTo: OntoUMLTransformComposition ].
		{
			subKindClass.
			plainClass } do: [ :each |
			self assert: (OntoUMLGeneralizationTransformer getTransformation: each) identicalTo: OntoUMLTransformGeneralization ] ]
		ensure: [ OntoUMLGeneralizationTransformer initializeTransformationIndex ]
]

{ #category : 'tests' }
OntoUMLGeneralizationTransformerTest >> testNameReturnsEmptyString [

	self assert: OntoUMLGeneralizationTransformer new name equals: ''
]

{ #category : 'tests' }
OntoUMLGeneralizationTransformerTest >> testTransformCreatesCompositionForRoleSpecialization [

	| controller generalClass specificClass transformedGeneral transformedSpecific generalization result |
	controller := OntoUMLTransformationController new.
	generalClass := OPUMLClass new
		                name: 'Person';
		                applyStereotype: OntoUMLKind new;
		                yourself.
	specificClass := OPUMLClass new
		                 name: 'Student';
		                 applyStereotype: OntoUMLRole new;
		                 yourself.
	transformedGeneral := OPUMLClass new name: 'Person'.
	transformedSpecific := OPUMLClass new name: 'Student'.
	controller addTransformationLinkBetween: generalClass and: transformedGeneral.
	controller addTransformationLinkBetween: specificClass and: transformedSpecific.
	generalization := OPUMLGeneralization new
		                  general: generalClass;
		                  specific: specificClass;
		                  yourself.

	result := OntoUMLGeneralizationTransformer transform: generalization withController: controller.

	self assert: result class identicalTo: OPUMLAssociation.
	self assert: result name equals: ''.
	self assert: result memberEnds second owningClass identicalTo: transformedGeneral.
	self assertCollection: controller transformedModel packagedElements hasSameElements: { result }
]

{ #category : 'tests' }
OntoUMLGeneralizationTransformerTest >> testTransformCreatesGeneralizationForSubKindSpecialization [

	| controller generalClass specificClass transformedGeneral transformedSpecific generalization result |
	controller := OntoUMLTransformationController new.
	generalClass := OPUMLClass new
		                name: 'Person';
		                applyStereotype: OntoUMLKind new;
		                yourself.
	specificClass := OPUMLClass new
		                 name: 'Child';
		                 applyStereotype: OntoUMLSubKind new;
		                 yourself.
	transformedGeneral := OPUMLClass new name: 'Person'.
	transformedSpecific := OPUMLClass new name: 'Child'.
	controller addTransformationLinkBetween: generalClass and: transformedGeneral.
	controller addTransformationLinkBetween: specificClass and: transformedSpecific.
	generalization := OPUMLGeneralization new
		                  general: generalClass;
		                  specific: specificClass;
		                  yourself.

	result := OntoUMLGeneralizationTransformer transform: generalization withController: controller.

	self assert: result class identicalTo: OPUMLGeneralization.
	self assert: result general identicalTo: transformedGeneral.
	self assert: result specific identicalTo: transformedSpecific.
	self assertCollection: controller transformedModel packagedElements hasSameElements: { result }
]
