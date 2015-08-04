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

```haskell
pkgs.writeText :: FileName -> String -> IO FilePath
```


[cc-by]: http://creativecommons.org/licenses/by/4.0/
