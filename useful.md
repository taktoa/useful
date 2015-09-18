# Introduction

This document contains useful information on various things in programming.
Any time I find something that I end up looking up multiple times, I put it
in here.

Copyright © 2015 Remy Goldschmidt <taktoa@gmail.com>

This work is licensed under the
[Creative Commons Attribution 4.0 International License][cc-by].

# Shell

## Bash syntax

### Special variables

| Variable | Description                                  |
| -------- | -------------------------------------------- |
| `\$#`    | The number of command-line arguments.        |
| `\$?`    | Exit value of the last executed command.     |
| `\$0`    | The name/path of the command executed.       |
| `\$*`    | All the arguments, unquoted.                 |
| `"\$@"`  | All the arguments, individually quoted.      |

### Iteration

```bash
for i in \$(ls); do
    echo item: \$i
done

for i in `seq 1 10`; do
    echo item: \$i
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

# Bitcoin

The following is edited from a conversation between myself and a friend.

The block chain self-adjusts the difficulty of finding a block, to ensure that 
the global hashing power finds a block every twenty minutes on average.

If, for example, all of North America (heretofore referred to as `NA`) was
isolated from the rest of the internet for $4$ hours, and `NA` had $30 \%$ of
the global hashing power, the chain would fork, and NA's version would be much
shorter.

When the networks re-connect, the longer chain always wins, so the fork `NA`
made gets deleted.  Any transactions within that fork go back to the pool of
pending transactions and re-enter new blocks as they are "mined" and possibly
get rejected (e.g.: if you spent the same coins in Europe and North America
during the partition).

Each block also has a Merkle root hash (and tree) for all of the transactions
within it.

Every block in the chain contains the following fields:

| Size (B)  | Description                             | Header? |
| --------- | --------------------------------------- | ------- |
| $4$       | A magic number.                         | No      |
| $4$       | The size of the entire block.           | No      |
| $4$       | The Bitcoin version.                    | Yes     |
| $32$      | The Merkle hash for the previous block. | Yes     |
| $32$      | A Merkle hash of all transactions.      | Yes     |
| $4$       | The timestamp.                          | Yes     |
| $4$       | The difficulty target.                  | Yes     |
| $4$       | The `no-once` value.                    | Yes     |
| $1$-$9$   | The transaction count.                  | No      |
| unlimited | The raw transactions.                   | No      |

The hash for a block is just `SHA256(SHA256(header))` where `header` is an
80-bytes bitstring (the fields it is composed of are marked in the table).

You may notice that it's only hashing the 80-byte header (not including the size
and magic number) and to be valid, the first x bits of the hash must be 0. For
example:

`00000000000000001e8d6829a8a21adc5d38d0a473b144b6765798e61f98bd1d`

The `no-once` is your main way to fudge the hash; you just increment it and
re-hash.

If your hashing rate is under $2^{32}$, then things are simple. You can increment
the timestamp before `no-once` overflows, but if the hashing rate goes over
$2^{32}$ blocks per second, you run into problems.

The proper solution is a bit deeper. The transactions within every block will
remove $x$ BTC and add $x + 25$ BTC.

Formally:
* There exists a set $\mathbf{B}$ (representing an amount of `BTC`)
  with the following bijection to the rationals:
  * $\mathrm{btc}      : \mathbb{Q} \to \mathbf{B}$
  * $\mathrm{btc}^{-1} : \mathbf{B} \to \mathbb{Q}$
* There is an set of all blocks named $\mathcal{B}$.
* For convenience, $i_b = \abs{\mathcal{B}}$.
* The set $\mathcal{T}$ is shorthand for
  $\bigcup_{b \in \mathcal{B}} \mathcal{T}_b$
* A block $b \in \mathbf{B}$ is associated with the following:
  * A set of transactions named $\mathcal{T}_b$.
* A transaction $t \in \mathcal{T}_b$ is associated with the following:
  * A set of input transactions  $\mathcal{I}_t \subseteq X$
    * $X = \{ x ~ | ~ \mathrm{prec}(x, t) \land x \in \mathcal{T} \}$
  * A set of outputs $\mathcal{O}_t \subseteq (\mathbf{B} \times \mathcal{T})*$
* If, for some transaction $t$,
  we have $s_o = \sum_{A \in \mathcal{O}_t} \sum_{p \in A} \mathrm{amt}(p)$
  and     $s_i = \sum_{b \in \mathcal{I}_t}
                 \sum_{m \in \mathcal{T}_b}
                 \sum_{o \in \mathcal{O}_m} (f(o) \cdot \mathrm{amt}(o))$,
  then $s_o - s_i = \mathrm{btc}(25)$
  * where
    * $\mathrm{amt} : \mathbf{B} \times \mathcal{T} \to \mathbf{B}$
    * $f(o) = \begin{cases} 1 & o \in \mathcal{I}_t \\
                            0 & \mathrm{otherwise}
              \end{cases}$

The block creation record contains the public key of the "winner" (the one who
verified the block). So if you generate a new bitcoin address (keypair), you get
a new public key, which gives a new transaction, which changes the Merkle root
hash. So for every receiving address, you can do another $2^{32}$ hashes/second.

## A neat hack

Since SHA256 operates on $64$ byte blocks, but the header is $80$ bytes and the
`no-once` is the final $4$ bytes. So you can hash the first $64$ bytes of the
header, and save the SHA256 state, and then re-compute the hash over the last
$16$ bytes (`timestamp` + `difficulty` + `no-once`) in a fraction of the time.
You restore the internal state each time, because the first $64$ bytes haven't
changed.

The second round of SHA256 stops you from completely cheating, but you can still
almost double your hashing rate in this way.

## Transactions as programs

When you set the receiver of a transaction, you are creating a program that
takes some inputs, and only if that program returns true does somebody have
permission to spend the output of the transaction. When you then choose to spend
it, you must supply the inputs for that program, and solve the math
problem. Also, when you do spend a transaction, you must spend the entire thing
at once.

Fees work by leaving an imbalance on purpose. For example, I supply the solution
to a transaction worth $1$ BTC, and I then create an output worth $0.9$ BTC. The
person solving the block can then freely choose where the remaining $0.1$ BTC
goes.

## Difficulty

Difficulty is also calculated in a simple way. $2016$ blocks takes about $4$
weeks under ideal conditions. The Bitcoin client takes the timestamp of the
current block, and that of the block $2016$ blocks previous, and if there are
more than $4$ weeks between their timestamps, then the difficulty lowers; if
there are fewer than $4$ weeks between their timestamps, difficulty rises.

All nodes (clients) follow the same rules, and adjust it by the same amount, so
they can agree on what the new difficulty is. Concretely, the difficulty is
simply how many $0$ bits the hash must have, so an increase of $1$ in difficulty
makes it twice as hard to mine a block.

## Altcoins

About the only difference between Bitcoin, and the various altcoins, is the 
hashing algorithm used.

Some of them use scrypt, which requires a relatively high amount of memory,
which makes it rather expensive to do with an FPGA or ASIC miner.

## Example block

As an example of all the preceding information on blocks and transactions,
[this](bitcoin-example) block has $4$ transactions in it.

* The first transaction created $50$ BTC out of thin air, and took the extra
  $0.01$ BTC that was left-over from the other three transactions.
* The second transaction sent $0.5$ BTC to `addr2`, and $29$ BTC to `addr3`;
  I'm guessing `addr3` was himself.
* The third took some BTC from three different addresses, and sent it to two,
  likely the destination and himself. This transaction consolidates several
  addresses into one.
* Finally, the fourth cleaned out two addresses entirely, sending them to a new
  one.

Every time you refer to a transaction, you refer to it by the hash, which covers
all of the inputs and outputs of that transaction.

They recommend that you give everybody a different address for sending things
to, so if I wanted to receive BTC from three people, I would ideally have a
balance on three different addresses.

The reason to do it this way is that it allows me to identify who sent me what
and also makes it such that they cannot talk to one another and determine they
sent money to the same person.

Also, the outputs are using a hash of the public key. When you create an input
to solve the output, you supply the public key. In theory, once the public key
is posted, somebody could brute-force your private key. Thus, every address
should be single-use, for maximal security.

Once you spend the coins at an address, you are recomended to spend _everything_
sent to that address, and never receive money again

--------------------------------------------------------------------------------

[cc-by]:
  http://creativecommons.org/licenses/by/4.0/
[bitcoin-example]:
  https://blockexplorer.com/block/00000000000000001e8d6829a8a21adc5d38d0a473b144b6765798e61f98bd1d
