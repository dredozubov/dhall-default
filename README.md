# dhall-default

Generate default records from types.

# Installation

```
cabal new-install --overwrite-policy=always --installdir=/where/to/install
```

# Usage

```bash
% dhall-default --filename io.k8s.apiextensions-apiserver.pkg.apis.apiextensions.v1beta1.ServiceReference.dhall
  { path = None Text, port = None Natural }
: { path : Optional Text, port : Optional Natural }
```
