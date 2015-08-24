# Introduction

This document contains useful information on various things in programming.
Any time I find something thatI end up looking up multiple times, I put it
in here.

Copyright © 2015 Remy Goldschmidt <taktoa@gmail.com>

This work is licensed under the
[Creative Commons Attribution 4.0 International License][cc-by].

# Shell

## Bash syntax

### Special variables

| Variable | Description                                                       |
| -------- | ----------------------------------------------------------------- |
| `$#`     | The number of command-line arguments.                             |
| `$?`     | Exit value of the last executed command.                          |
| `$0`     | The name/path of the command executed.                            |
| `$*`     | All the arguments, unquoted.                                      |
| `"$@"`   | All the arguments, individually quoted.                           |

### Iteration

```bash
for i in $(ls); do
    echo item: $i
done

for i in `seq 1 10`; do
    echo item: $i
done
```

## Useful programs

### ImageMagick

[ImageMagick Usage][http://www.imagemagick.org/Usage]

```bash
# Scaling
convert input.png -scale 25% output.jpg
convert input.png -scale 256x320 output.jpg
```

# Nix / NixOS

## Function reference

| Function                                          | Return value                         |
| ------------------------------------------------- | ------------------------------------ |
| `pkgs.writeText <file-name> <string>`             | Path of text file                    |
| `pkgs.fetchFromGitHub { owner repo rev sha256 }`  | Path of repository                   |
| `lib.optionalString <boolean> <string>`           | `if <boolean> then <string> else ""` |

# Haskell

## GHC Extensions

```haskell
{-# LANGUAGE Arrows                     #-}
{-# LANGUAGE AutoDeriveTypeable         #-}
{-# LANGUAGE BinaryLiterals             #-}
{-# LANGUAGE ConstrainedClassMethods    #-}
{-# LANGUAGE ConstraintKinds            #-}
{-# LANGUAGE DataKinds                  #-}
{-# LANGUAGE DatatypeContexts           #-}
{-# LANGUAGE DefaultSignatures          #-}
{-# LANGUAGE DeriveAnyClass             #-}
{-# LANGUAGE DeriveDataTypeable         #-}
{-# LANGUAGE DeriveFoldable             #-}
{-# LANGUAGE DeriveFunctor              #-}
{-# LANGUAGE DeriveGeneric              #-}
{-# LANGUAGE DeriveTraversable          #-}
{-# LANGUAGE DisambiguateRecordFields   #-}
{-# LANGUAGE DoAndIfThenElse            #-}
{-# LANGUAGE DoRec                      #-}
{-# LANGUAGE EmptyCase                  #-}
{-# LANGUAGE EmptyDataDecls             #-}
{-# LANGUAGE ExistentialQuantification  #-}
{-# LANGUAGE ExplicitForAll             #-}
{-# LANGUAGE ExplicitNamespaces         #-}
{-# LANGUAGE ExtendedDefaultRules       #-}
{-# LANGUAGE FlexibleContexts           #-}
{-# LANGUAGE FlexibleInstances          #-}
{-# LANGUAGE FunctionalDependencies     #-}
{-# LANGUAGE GADTSyntax                 #-}
{-# LANGUAGE GADTs                      #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE ImplicitParams             #-}
{-# LANGUAGE ImplicitPrelude            #-}
{-# LANGUAGE ImpredicativeTypes         #-}
{-# LANGUAGE IncoherentInstances        #-}
{-# LANGUAGE InstanceSigs               #-}
{-# LANGUAGE KindSignatures             #-}
{-# LANGUAGE LambdaCase                 #-}
{-# LANGUAGE LiberalTypeSynonyms        #-}
{-# LANGUAGE MagicHash                  #-}
{-# LANGUAGE MonadComprehensions        #-}
{-# LANGUAGE MonoLocalBinds             #-}
{-# LANGUAGE MonoPatBinds               #-}
{-# LANGUAGE MultiParamTypeClasses      #-}
{-# LANGUAGE MultiWayIf                 #-}
{-# LANGUAGE NPlusKPatterns             #-}
{-# LANGUAGE NamedFieldPuns             #-}
{-# LANGUAGE NamedWildCards             #-}
{-# LANGUAGE NegativeLiterals           #-}
{-# LANGUAGE NullaryTypeClasses         #-}
{-# LANGUAGE NumDecimals                #-}
{-# LANGUAGE OverlappingInstances       #-}
{-# LANGUAGE OverloadedLists            #-}
{-# LANGUAGE PackageImports             #-}
{-# LANGUAGE PartialTypeSignatures      #-}
{-# LANGUAGE PatternGuards              #-}
{-# LANGUAGE PatternSignatures          #-}
{-# LANGUAGE PatternSynonyms            #-}
{-# LANGUAGE PolyKinds                  #-}
{-# LANGUAGE PolymorphicComponents      #-}
{-# LANGUAGE PostfixOperators           #-}
{-# LANGUAGE Rank2Types                 #-}
{-# LANGUAGE RankNTypes                 #-}
{-# LANGUAGE RebindableSyntax           #-}
{-# LANGUAGE RecordPuns                 #-}
{-# LANGUAGE RecordWildCards            #-}
{-# LANGUAGE RecursiveDo                #-}
{-# LANGUAGE RoleAnnotations            #-}
{-# LANGUAGE ScopedTypeVariables        #-}
{-# LANGUAGE StandaloneDeriving         #-}
{-# LANGUAGE StaticPointers             #-}
{-# LANGUAGE TraditionalRecordSyntax    #-}
{-# LANGUAGE TransformListComp          #-}
{-# LANGUAGE Trustworthy                #-}
{-# LANGUAGE TupleSections              #-}
{-# LANGUAGE TypeFamilies               #-}
{-# LANGUAGE TypeOperators              #-}
{-# LANGUAGE TypeSynonymInstances       #-}
{-# LANGUAGE UnboxedTuples              #-}
{-# LANGUAGE UndecidableInstances       #-}
{-# LANGUAGE UnicodeSyntax              #-}
```

[cc-by]: http://creativecommons.org/licenses/by/4.0/
