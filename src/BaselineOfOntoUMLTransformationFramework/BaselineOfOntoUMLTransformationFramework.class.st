Class {
	#name : #BaselineOfOntoUMLTransformationFramework,
	#superclass : #BaselineOf,
	#category : #BaselineOfOntoUMLTransformationFramework
}

{ #category : #baselines }
BaselineOfOntoUMLTransformationFramework >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ spec
				baseline: 'OntoUMLModelQuery-Plugin'
				with: [ spec
						className: 'BaselineOfOntoUMLModelQuery';
						repository: 'github://openponk/ontouml-modelquery';
						loads: 'plugin' ].
			spec
				project: 'OntoUMLModelQuery'
				copyFrom: 'OntoUMLModelQuery-Plugin'
				with: [ spec loads: 'default' ].
			spec package: 'OntoUML-TransformationFramework'.
			spec
				group: 'plugin'
				with: #('OntoUMLModelQuery-Plugin' 'OntoUML-TransformationFramework').
			spec
				group: 'default'
				with: #(OntoUMLModelQuery 'OntoUML-TransformationFramework') ]
]
