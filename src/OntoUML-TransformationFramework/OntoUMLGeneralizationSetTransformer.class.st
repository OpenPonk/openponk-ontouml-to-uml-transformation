Class {
	#name : #OntoUMLGeneralizationSetTransformer,
	#superclass : #OntoUMLTransformer,
	#instVars : [
		'generalizations',
		'name'
	],
	#category : #'OntoUML-TransformationFramework-Transformers'
}

{ #category : #transforming }
OntoUMLGeneralizationSetTransformer class >> defaultTransformation [
	^ [ :generalizations :controller :transformer | OntoUMLTransformGeneralizationSet transform: generalizations withController: controller withTransformer: transformer. ].
]

{ #category : #transforming }
OntoUMLGeneralizationSetTransformer class >> generalizationSetGroups [
	"Order of elements in collection determines order of the transformation"
	^ { 'Phase'. 'Role'. 'RoleMixin'. 'Mixin'. 'Object'. "Object = all remaining GenSet groups" }.
]

{ #category : #transforming }
OntoUMLGeneralizationSetTransformer class >> initializeTransformationIndex [
	transformationIndex  := Dictionary new.
	transformationIndex add: ('Phase' -> [ :generalizations :controller :transformer | OntoUMLTransformGeneralizationSet transformAsComposition: generalizations withController: controller withTransformer: transformer. ]).
	transformationIndex add: ('Role' -> [ :generalizations :controller :transformer | OntoUMLTransformGeneralizationSet transformAsComposition: generalizations withController: controller withTransformer: transformer. ]).
	transformationIndex add: ('RoleMixin' -> [ :generalizations :controller :transformer | OntoUMLTransformGeneralizationSet transformAsComposition: generalizations withController: controller withTransformer: transformer. ]).
	transformationIndex add: ('Mixin' -> [ :generalizations :controller :transformer | OntoUMLTransformGeneralizationSet transformAsComposition: generalizations withController: controller withTransformer: transformer. ]).
]

{ #category : #accessing }
OntoUMLGeneralizationSetTransformer >> general [
	^ controller getTransfomedElementFrom: transformed generalizations first general.
]

{ #category : #accessing }
OntoUMLGeneralizationSetTransformer >> name [

	^ name
]

{ #category : #accessing }
OntoUMLGeneralizationSetTransformer >> name: anObject [

	name := anObject
]

{ #category : #transforming }
OntoUMLGeneralizationSetTransformer >> transform [
	generalizations := OrderedCollection new.
	generalizations addAll: transformed generalizations.
	^ self class generalizationSetGroups collect: [ :group | self transformGroup: group. ].
]

{ #category : #transforming }
OntoUMLGeneralizationSetTransformer >> transformGroup: aGroup [
	| transformedGeneralizations transformation result |
	transformedGeneralizations := generalizations select: [ :generalization | OntoUMLModelQuery isStereotypeOf: generalization specific oclKindOf: aGroup. ].
	transformation := self class getTransformation: aGroup.
	result := transformation value: transformedGeneralizations value: controller value: self.
	generalizations removeAll: transformedGeneralizations.
	^ result.
]
