"
Metacello baseline for the OpenPonk OntoUML Transformations package, defining its package dependencies and load configurations.
"
Class {
	#name : 'BaselineOfOpenPonkOntoUMLTransformations',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfOpenPonkOntoUMLTransformations',
	#package : 'BaselineOfOpenPonkOntoUMLTransformations'
}

{ #category : 'baselines' }
BaselineOfOpenPonkOntoUMLTransformations >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ spec
				baseline: 'OpenPonkOntoUMLModelQuery-Plugin'
				with: [ spec
						className: 'BaselineOfOpenPonkOntoUMLModelQuery';
						repository: 'github://OpenPonk/ontouml-modelquery:v5.0.1';
						loads: 'plugin' ].
			spec
				project: 'OpenPonkOntoUMLModelQuery'
				copyFrom: 'OpenPonkOntoUMLModelQuery-Plugin'
				with: [ spec loads: 'default' ].
			spec package: 'OpenPonk-OntoUML-Transformations'.
			spec
				group: 'plugin'
				with: #('OpenPonkOntoUMLModelQuery-Plugin' 'OpenPonk-OntoUML-Transformations').
			spec
				group: 'default'
				with: #(OpenPonkOntoUMLModelQuery 'OpenPonk-OntoUML-Transformations') ]
]
