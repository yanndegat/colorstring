# colorstring lib for gerbil scheme

Port of https://github.com/mitchellh/colorstring on gerbil scheme.

colorstring is a library for outputting colored strings to a console using a simple inline syntax in your string to specify the color to print as.

For example, the string `[blue]hello [red]world` would output the text
"hello world" in two colors. The API of colorstring allows for easily disabling
colors, adding aliases, etc.

## Usage & Example

Usage is easy enough:

```scheme
(displayln (color "[blue]Hello [red]World!"))
```

Additionally, the `color-map`, `color-reset`, `color-disabled` parameters can be used
to set options such as custom colors, color disabling, etc.
