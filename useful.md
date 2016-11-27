# Introduction

This document contains useful information on various things in programming.
Any time I find something that I end up looking up multiple times, I put it
in here.

Copyright © 2015 Remy Goldschmidt <taktoa@gmail.com>

This work is licensed under the
[Creative Commons Attribution 4.0 International License][cc-by].

[generate-toc-pragma]: IGNORE_BEGIN
# Table of Contents
[generate-toc-pragma]: IGNORE_END

[generate-toc-pragma]: ADD_TOC

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

## The `meta` attribute set

### Attribute descriptions

#### `meta.description`

##### Description

A short (one-line) description of the package.

This is shown by `nix-env -q --description` and also on the release pages.

- Don’t include a period at the end.
- Don’t include newline characters.
- Capitalise the first character.
- For brevity, don’t repeat the name of package; just describe what it does.

Wrong: `libpng is a library that allows you to decode PNG images.`

Right: `A library for decoding PNG images`

##### Examples

```nix
{ # ...
  meta = with stdenv.lib; {
    description = "A program that produces a familiar, friendly greeting";
  };
}
```

#### `meta.longDescription`

##### Description

An arbitrarily long description of the package.

##### Examples

```nix
{ # ...
  meta = with stdenv.lib; {
    longDescription = ''
        GNU Hello is a program that prints "Hello, world!" when you run it.
        It is fully customizable.
    '';
  };
}
```

#### `meta.version`

##### Description

This specifies the package version.

##### Examples

```nix
{ # ...
  meta = with stdenv.lib; {
    version = "3.0";
  };
}
```

#### `meta.branch`

##### Description

This is used to specify that a package is not going to receive updates that are
not in this branch.

##### Examples

For example, Linux kernel `3.0` is supposed to be updated to `3.0.1`, not `3.1`.

This would be specified as:

```nix
{ # ...
  meta = with stdenv.lib; {
    branch = "3.0";
  };
}
```

#### `meta.homepage`

##### Description

The package’s homepage.

##### Examples

```nix
{ # ...
  meta = with stdenv.lib; {
    homepage = "http://www.gnu.org/software/hello/manual/";
  };
}
```

#### `meta.downloadPage`

##### Description

The page where a link to the current version can be found.

##### Examples

```nix
{ # ...
  meta = with stdenv.lib; {
    downloadPage = "http://ftp.gnu.org/gnu/hello/";
  };
}
```

#### `meta.license`

##### Description

The license, or licenses, for the package. One from the attribute set defined in
`nixpkgs/lib/licenses.nix`. At this moment using both a list of licenses and a
single license is valid.

If the license field is in the form of a list representation, then it means that
parts of the package are licensed differently.

Each license should preferably be referenced by their attribute.

The non-list attribute value can also be a space delimited string representation
of the contained attribute `shortNames` or `spdxIds`.

##### Examples

Preferred convention for a single license:

```nix
{ # ...
  meta = with stdenv.lib; {
    # The license attribute
    license = licenses.gpl3;
  };
}
```

Alternative (frowned upon) conventions for a single license:

```nix
{ # ...
  meta = with stdenv.lib; {
    # The license shortName
    license = "gpl3";
    # The license spdxId
    license = "GPL-3.0";
  };
}
```

Preferred convention for multiple licenses:

```nix
{ # ...
  meta = with stdenv.lib; {
    # A list of license attributes
    license = with licenses; [ asl20 free ofl ];
  };
}
```

Alternative (frowned upon) conventions for a multiple licenses:

```nix
{ # ...
  meta = with stdenv.lib; {
    # A space-delimited string of shortNames
    license = "asl20 free ofl";
  };
}
```

#### `meta.maintainers`

##### Description

A list of names and e-mail addresses of the maintainers of this Nix expression.

If you would like to be a maintainer of a package, you may want to add yourself
to `<nixpkgs>/lib/maintainers.nix`.

Maintainer names should be formatted as: `[first-name] [last-name] <[email]>`,
where `[first-name]`, `[last-name]`, and `[email]` represent the maintainer's
first and last names and email address respectively.

##### Examples

Adding a maintainer to `<nixpkgs>/lib/maintainers.nix`:

```nix
/* in <nixpkgs>/lib/maintainers.nix */
{ # ...
  eelco = "Eelco Dolstra <eelco.dolstra@logicblox.com>";
  # ...
}
```

Specifying a single maintainer in a derivation:

```nix
{ # ...
  meta = with stdenv.lib; {
    # This way is easy to extend to multiple maintainers
    maintainers = with maintainers; [ eelco ];
  };
}
```

Alternative way to specify a single maintainer:

```nix
{ # ...
  meta = with stdenv.lib; {
    # This way is slightly more concise
    maintainers = maintainers.eelco;
  };
}
```

Specifying multiple maintainers in a derivation:

```nix
{ # ...
  meta = with stdenv.lib; {
    maintainers = with maintainers; [ alice bob ];
  };
}
```

#### `meta.platforms`

##### Description

The list of Nix platform types on which the package is supported. Hydra builds
packages according to the platform specified. If no platform is specified, the
package does not have prebuilt binaries.

In `stdenv.lib.platforms`, defined in `<nixpkgs>/lib/platforms.nix`, one can
find various common lists of platforms types.

##### Examples

For a package supported on Linux:

```nix
{ # ...
  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };
}
```

For a package supported on all available platforms:

```nix
{ # ...
  meta = with stdenv.lib; {
    platforms = platforms.all;
  };
}
```

##### Common values

For this table, the attribute set `platforms` refers to `stdenv.lib.platforms`.

| Expression                | Description                                    |
| ------------------------- | ---------------------------------------------- |
| **General**               |                                                |
| `platforms.all`           | All available platforms.                       |
| `platforms.none`          | The empty set of platforms.                    |
| **Platform generators**   |                                                |
| `platforms.allBut [foo]`  | All platforms except for `[foo]`.              |
| **Combinations**          |                                                |
| `platforms.gnu`           | Platforms created by/for the GNU project.      |
| `platforms.unix`          | Platforms with some POSIX compliance.          |
| `platforms.mesaPlatforms` | Platforms supporting the Mesa 3D library.      |
| **Operating Systems**     |                                                |
| `platforms.linux`         | Operating systems based on the Linux kernel.   |
| `platforms.darwin`        | Darwin and Mac OS X.                           |
| `platforms.freebsd`       | The FreeBSD operating system.                  |
| `platforms.openbsd`       | The OpenBSD operating system.                  |
| `platforms.netbsd`        | The NetBSD operating system.                   |
| `platforms.cygwin`        | The Cygwin Unix emulation layer for Windows.   |
| `platforms.illumos`       | Operating systems based on the Illumos kernel. |
| **Architectures**         |                                                |
| `platforms.x86_64`        | The AMD64 microarchitecture.                   |
| `platforms.i686`          | The Intel 32-bit microarchitecture.            |
| `platforms.arm`           | Any version of the ARM microarchitecture.      |
| `platforms.mips`          | The MIPS64 microarchitecture.                  |

#### `meta.hydraPlatforms`

##### Description

The list of Nix platform types for which the Hydra (Nix's continuous build
system) instance at <hydra.nixos.org> will build the package.

The default value for `hydraPlatforms` is that of `platforms`.

Thus, the only reason to set `meta.hydraPlatforms` is if you want
http://hydra.nixos.org to build the package on a subset of `meta.platforms`,
or not at all.

##### Examples

To prevent Hydra builds for a particular package:

```nix
{ # ...
  meta = with stdenv.lib; {
    hydraPlatforms = []; # Don't build on Hydra
  };
}
```

To only allow Linux builds on Hydra:

```nix
{ # ...
  meta = with stdenv.lib; {
    hydraPlatforms = stdenv.lib.platforms.linux; # On Hydra, only build Linux
  };
}
```

#### `meta.broken`

If set to true, the package is marked as "broken", meaning that it won’t show up
in `nix-env -qa`, and cannot be built or installed.

Such packages should be removed from Nixpkgs eventually unless they are fixed.

#### `meta.updateWalker`

If set to true, the package is tested to be updated correctly by the
`update-walker.sh` script without additional settings.

Such packages have `meta.version` set and their homepage (or the page
specified by `meta.downloadPage`) contains a direct link to the package
tarball.

### Derivation template

```nix
{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "hello-${version}";
  version = "2.10";

  src = fetchurl {
    url = "mirror://gnu/hello/${name}.tar.gz";
    sha256 = "0ssi1wpaf7plaswqqjwigppsg5fyh99vdlb9kzl7c9lng89ndq1i";
  };

  buildInputs = [ /* Dependencies go here. */ ];

  meta = with stdenv.lib; {
    inherit version;
    homepage = "http://www.gnu.org/software/hello/manual/";
    downloadPage = "http://ftp.gnu.org/gnu/hello/";
    description = "A program that produces a familiar, friendly greeting";
    longDescription = ''
        GNU Hello is a program that prints "Hello, world!" when you run it.
        It is fully customizable.
    '';
    license = with licenses; [ gpl3 ];
    maintainers = with maintainers; [ taktoa ];
    platforms = platforms.all;
  }
}
```

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

--------------------------------------------------------------------------------

# MLT Video Editor

```console
$ melt avformat:foo.mkv length=<L> in=<I> out=<O> -consumer avformat:bar.mp4
```

- Specify at most two of `length`, `in`, and `out`: `length` is the number of
  frames to take, `in` is the start frame, and `out` is the end frame.
- [This][mlt-docs] is useful for reference.

[mlt-docs]:
  http://www.mltframework.org/bin/view/MLT/MltMelt

# Emacs

## Org-mode

### Commonly used keybindings

- TODO-related
  - `C-c C-t` --- `org-todo` --- cycle through TODO states
  - `C-c a t` --- `org-todo-list` --- show the global TODO list
  - Scheduling
    - `C-c C-d` --- `org-deadline` --- insert a DEADLINE keyword
    - `C-c C-s` --- `org-schedule` --- insert a SCHEDULED keyword
    - `C-c / d` --- `org-check-deadlines` --- check deadlines

# SSH

## Setting up an SSH reverse tunnel

Suppose you have two people, Alice and Eve. Alice is a newbie, and has a
computer in a network with no port forwarding, but wants to install Linux or fix
some issue. Eve is an expert, but would very much prefer to run commands in a
shell than to describe them over the phone to Alice. Getting Alice to set up
port forwarding will take longer than describing the necessary commands.

Setting up a VPN would work, but often this is impractical or impossible.
Setting up [toxvpn][] is doable on many systems, but currently Tox has a bug in
which the number of UDP connections it opens will crash some routers.
Is there any other solution? Enter SSH reverse tunnelling.

Suppose that Eve can SSH into a server at `foobar.net` that is on a network with
port 22 (or some other port `<n>`) open. Suppose that Alice is on a laptop with
username `alice`. Suppose that the server at `foobar.net` has two users, `eve`
and `alice`, and that `alice` has an SSH public key in its `authorized_keys`
that is currently on Alice's laptop. Suppose that Alice's laptop has an SSH
public key in its `authorized_keys` that is currently on the `eve` account on
`foobar.net`. Then follow these steps:

1. Run `ssh alice@foobar.net -R 2222:127.0.0.1:22` on Alice's laptop as `alice`
2. Run `ssh alice@localhost -p 2222` on Eve's server as `eve`

[toxvpn]: https://github.com/cleverca22/toxvpn
