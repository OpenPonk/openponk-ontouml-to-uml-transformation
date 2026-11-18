"
Abstract base test case providing shared UML association fixture helpers for OntoUML transformation unit tests.
"
Class {
	#name : 'OntoUMLAbstractTransformationTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-OntoUML-Transformations-Tests-Transformations',
	#package : 'OpenPonk-OntoUML-Transformations-Tests',
	#tag : 'Transformations'
}

{ #category : 'testing' }
OntoUMLAbstractTransformationTest class >> isAbstract [

	^ self == OntoUMLAbstractTransformationTest
]

{ #category : 'utilities' }
OntoUMLAbstractTransformationTest >> collectAssociationValidationWarningsIn: aUMLPackage [

	| validationWarnings |
	validationWarnings := OrderedCollection new.
	aUMLPackage packagedElements select: [ :each | each isKindOf: OPUMLAssociation ] thenDo: [ :association |
			[ (OPUmlAssociationViewModel new model: association) validate ]
				on: OPModelInvalid
				do: [ :warning |
						validationWarnings add: warning messageText.
						warning resume ] ].
	^ validationWarnings
]

{ #category : 'utilities' }
OntoUMLAbstractTransformationTest >> createAssociationFrom: aSourceClass to: aTargetClass [

	| association |
	association := OPUMLAssociation new.
	OPUMLProperty new
		name: '';
		lowerValue: (OPUMLLiteralInteger new value: 1);
		upperValue: (OPUMLLiteralUnlimitedNatural new value: 1);
		owningAssociation: association;
		type: aSourceClass.
	OPUMLProperty new
		name: '';
		lowerValue: (OPUMLLiteralInteger new value: 1);
		upperValue: (OPUMLLiteralUnlimitedNatural new value: 1);
		owningAssociation: association;
		type: aTargetClass.
	association memberEnds addAll: association ownedEnds.
	^ association
]

{ #category : 'utilities' }
OntoUMLAbstractTransformationTest >> createAssociationFrom: aSourceClass to: aTargetClass with: aStereotype [

	| association |
	association := self createAssociationFrom: aSourceClass to: aTargetClass.
	association applyStereotype: aStereotype.
	^ association
]

{ #category : 'utilities' }
OntoUMLAbstractTransformationTest >> newControllerWithTransformedClassesFor: aSourceClasses [

	| controller |
	controller := OntoUMLTransformationController new.
	aSourceClasses do: [ :sourceClass |
		controller addTransformationLinkBetween: sourceClass and: (OPUMLClass new name: sourceClass name) ].
	^ controller
]
