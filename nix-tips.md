<!-- -*- coding: utf-8; -*- -->

# The Nix Expression Language

## Syntax

In the following definitions, `…` should be interpreted as meaning
"a spot where any valid Nix syntax can be put".

In the following definitions, any time something is called a "_foo_ literal",
that refers to the syntax, whereas a "_foo_ value" will mean the runtime value
associated with evaluating that piece of syntax. The only exception to this
convention is a "lambda"; the runtime representation of which will be referred
to as a "closure".

For clarity I may sometimes eschew these conventions in favor of directly giving
syntax examples; e.g.: I might refer to environment literals as `<…>` literals.

### Functions

- `foo: …` is a **lambda**.
  - The stuff to the left of `:` in a lambda is called a **pattern**.
  - The stuff to the right of `:` in a lambda is the **lambda body**.
  - `foo` is a **parameter**, the simplest kind of pattern.
- `s@{ foo, bar ? "baz", ... }: …` is a more complicated lambda.
  - `{ … }` is called a **set pattern**.
  - `s@…` is called an **as pattern**.
  - `foo` is a **parameter** (same as in the previous example).
  - `bar ? "baz"` is an **optional parameter**
    and `"baz"` is the **default value** for `bar`.
  - `{ …, ... }` is a **varargs set pattern**.
    - Note that `...` is literally a Nix token here, not any meta-syntax
      on my part.
    - FIXME: this naming should be better

### Variable Binding

- `let foo = bar; inherit baz; in quux` is a **`let`-clause**.
  - `foo = bar;` is a **`let`(-clause) binding**.
  - `quux` is the **`let`(-clause) body**.
  - `inherit baz;` is an **`inherit`ed binding**.
- `with foo; bar` is a **`with`-clause**.
  - `foo` is the **included set** of this `with` clause.
  - `bar` is the **`with`-clause body**.

### Attribute Sets

- `{ foo = "bar"; }` is an **attribute set**.
  - `foo = "bar";` is an **attribute binding**
    - `foo` is the **name** of this binding.
    - `"bar"` is the **value** of this binding.
- `rec { foo = bar; bar = 5; }` is a **recursive attribute set**.
- `foo.bar.baz` is an **attribute path**.
- `inherit …;` is an **inherited attribute**.

### Strings and Paths

- A string is a piece of syntax
- `"foo"` is a **string literal**.
- `''foo''` is a **multiline string literal**.
  - These are sometimes called "double-single-quoted strings".
- `${foo}` is an **antiquotation**, and in this context we would say that
  `foo` has been **antiquoted**.
- A string that uses antiquotation, like `"foo ${bar} baz"`, may be called
  a **quasiquotation**. A plain string is called a **quotation**.
- `foo/bar/baz` is a **path literal**
  (_not_ to be confused with an attribute path).
- `https://github.com` is a **URI literal**.
  - These are discouraged, because they make parsing Nix much harder
    (the colon conflicts with the syntax for lambdas), and there isn't much
    benefit to having them as literals in the language.
- `<foo>` is an **environment literal** (for lack of a better name).
  - Sometimes these are also called **`<…>` literals**.

### Built-in Functions and Operators

- There are a number of keywords and operators in Nix that could just as well
  be functions defined in terms of an element of `builtins`. I will list their
  desugarings here (`===>` separates the sugared syntax from the desugared
  syntax):
  - `a ++ b ===> FIXME`

### Other

- `f x` (juxtaposition) is a **function application (expression)**.
- `if … then … else …` is a **conditional (expression)**.
- `… or …` is an **or clause**.
- `assert …; …` is an **assertion** or **assert clause**.
- `5` is a **numeric literal** or **integer**.
- `null` is a **null literal**.
- A **comment** is a piece of code that does not affect evaluation at all.
  - `// …` is a **single-line comment**.
  - `/* … */` is a **multiline comment**.

## Semantics

### Antiquotation

- It can go in some surprising places:
  - `{ ${"foo"} = 5; }` evaluates to `{ "foo" = 5; }`.
  - `let ${"foo"} = 5; in foo` evaluates to `5`.

### The `or` keyword

- Somewhat surprisingly, this keyword does **not** mean boolean OR.
- Instead, it has the following syntax: `ATTR_PATH or NIX_EXPR`
- For example: `foo.bar.baz or quux`
- The semantics of an expression using `or` are that the attribute path on the
  left hand side is evaluated, and if, along the way, one of the attribute
  sets doesn't have the requested key, then the right hand side is returned
  instead.
- It basically "catches" non-existent attribute exceptions.
- Examples:
  - `({ foo = { bar = {}; }}).foo.bar.baz or 5` evaluates to `5`.
  - `({ foo = 4; }).foo or 5` evaluates to `4`.

### `NIX_PATH=…`, `-I …`, and `<…>` literals

- An **environment value**, is a environment prefix or pair.
  - An **(environment) pair** is an `=`-separated pair of a string and a path.
    The string is called the "key", while the path is the "value".
  - An **(environment) prefix** is a path to a folder.
- The `…` in `NIX_PATH=…` or `-I …` will heretofore be referred to as a
  **environment definition**.
- Formally, an environment definition consists of an ordered, `:`-separated list
  of environment values.
- Once `NIX_PATH` and any `-I` arguments are parsed and merged together, we have
  a value that we will call an **environment**.
- Environments are ordered lists of environment values such that no two pairs
  have the same key.
- When `NIX_PATH` and `-I` are merged, `-I` takes precedence over `NIX_PATH`.
- When there are two or more environment values with the same key in the same
  environment definition, only the first value is considered; the rest are
  discarded.
  - Note that this happens *before* merging of environment definitions.
- A
- If `NIX_PATH` is set to `foo=path1:foo=path2:path3`, then:
  1. The semantics of `<foo>` is defined by:
    - `if(exists(path1)) { return path1; }`
    - `if(exists(path3/foo)) { return path3/foo; }`
    - `throw;`
  2. The semantics of `<foo/a/b/c>` is defined by:
    - `if(exists(path1/a/b/c)) { return path1/a/b/c; }`
    - `if(exists(path3/foo/a/b/c)) { return path3/foo/a/b/c; }`
    - `throw;`
  3. The semantics of `<foo>/a/b/c` is defined by:
    - `return (<foo> + "/a/b/c");`
    - (note that `<foo>` has the same semantics as in example (i))
- If we have `NIX_PATH="foo=path1"` and then we run
  `nix-instantiate -I "foo=path2" -E "<foo>"`, the result will be `path2`
  rather than `path1`.
- To summarize:
  - `NIX_PATH=…` and `-I …` are the same, except that pair in `-I`
    overrides any pair with the same key in `NIX_PATH`.
  -
  - `-I` arguments take precedence over `NIX_PATH`
  - Duplicated keys in `NIX_PATH=…` (or `-I …`) are ignored, and the value of
    the first instance of the requested key is always used.


### `null`

- It is good to note that `null == {}` evaluates to false.
- In general, there is no literal `L` such that `L == null` will be true,
  other than `null` itself.

### `builtins`

- This is an attribute set that is *always* in scope during Nix evaluation.
  It essentially defines the primitive operations of Nix.

<!-- Local Variables:                   -->
<!-- mode:                 markdown     -->
<!-- markdown-enable-math: nil          -->
<!-- comment-column:       80           -->
<!-- eval:                 (fci-mode 1) -->
<!-- End:                               -->
