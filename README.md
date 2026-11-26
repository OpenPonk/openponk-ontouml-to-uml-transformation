# OpenPonk: OntoUML to UML Transformation

[![Nightly](https://github.com/OpenPonk/openponk-ontouml-to-uml-transformation/actions/workflows/nightly.yml/badge.svg)](https://github.com/OpenPonk/openponk-ontouml-to-uml-transformation/actions/workflows/nightly.yml) [![Coverage Status](https://coveralls.io/repos/github/OpenPonk/openponk-ontouml-to-uml-transformation/badge.svg?branch=master)](https://coveralls.io/github/OpenPonk/openponk-ontouml-to-uml-transformation?branch=master)

Model-to-model transformation from conceptual OntoUML models to implementation-level UML class models, extending [`class-editor`](https://github.com/OpenPonk/class-editor). Included automatically in `class-editor` (`complete`) and all-in-one builds.

## Installation

See [openponk.org/#direct-installation](https://openponk.org/#direct-installation) for the supported Pharo version.

```smalltalk
Metacello new
	baseline: 'OpenPonkOntoUMLTransformations';
	repository: 'github://OpenPonk/openponk-ontouml-to-uml-transformation';
	load.
```

## Documentation

Part of the [OpenPonk](https://openponk.org) platform. For architecture, the repository catalog, and contributing guidelines, see [`OpenPonk/.github`](https://github.com/OpenPonk/.github/blob/main/profile/README.md).
