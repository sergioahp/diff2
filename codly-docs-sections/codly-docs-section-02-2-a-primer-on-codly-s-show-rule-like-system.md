## 2. A primer on Codly's show-rule like system

Codly uses a function called `codly` to create a kind of show-rule which you can use to configure how your code blocks are displayed. The `codly` function takes a set of arguments that define how the code block should be displayed. Here is the equivalent definition of the `codly` function:

```typst
let codly(
  enabled: true,
  offset: 0,
  offset-from: none,
  range: none,
  ranges: (),
  languages: (:),
  display-name: true,
  display-icon: true,
  default-color: rgb("#283593"),
  radius: 0.32em,
  inset: 0.32em,
  fill: none,
  zebra-fill: luma(240),
  stroke: 1pt + luma(240),
  lang-inset: 0.32em,
  lang-outset: (x: 0.32em, y: 0pt),
  lang-radius: 0.32em,
  lang-stroke: (lang) => lang.color + 0.5pt,
  lang-fill: (lang) => lang.color.lighten(80%),
  lang-format: codly.default-language-block,
  number-format: (number) => [ #number ],
  number-align: left + horizon,
  number-placement: "outside",
  smart-indent: false,
  annotations: none,
  annotation-format: numbering.with("(1)"),
  highlights: none,
  highlight-radius: 0.32em,
  highlight-fill: (color) => color.lighten(80%),
  highlight-stroke: (color) => 0.5pt + color,
  highlight-inset: 0.32em,
  highlight-outset: 0pt,
  highlight-clip: true,
  reference-by: line,
  reference-sep: "-",
  reference-number-format: numbering.with("1"),
  header: none,
  header-repeat: false,
  header-transform: (x) => x,
  header-cell-args: (),
  footer: none,
  footer-repeat: false,
  footer-transform: (x) => x,
  footer-cell-args: (),
  breakable: false,
) = {}
```

The `codly` functions acts like a set-rule, this means that calling it will set the configuration for all code blocks that follow it, with the exception of a few arguments that are explicitly set for each code block. To perform changes locally, you can use the `local` function, or set the arguments before the code block and reset them after to their previous values.

> **Warning**
> Unlike regular set-rules in native Typst, there are two considerations:
> *   The `codly` function uses states to store the configuration, this means that it is dependent on layout order for the order in which settings are applied.
> *   The `codly` function is not local, it sets the configuration for all code blocks that follow it in layout order, unless overriden by another `codly` call. This means that you cannot use it to set the configuration for a specific code block. To perform this, use the `local` function to set the configuration for a specific "section".

### 2.1. Enabled (`enabled`)

| </> Type | `bool` |
| :--- | :--- |
| {*} Default value | `true` |
| Contextual function | ✓ yes |
| Automatically reset | x no |
| Already released in 1.3.1 | ✓ yes |

Whether codly is enabled or not. If it is disabled, the code block will be displayed as a normal code block, without any additional codly-specific formatting. This is useful if you want to disable codly for a specific block. You can also disable codly locally using the `no-codly` function, or disable it and enable it again using the `codly-disable` and `codly-enable` functions.

#### 2.1.1. Example

| Example code | Typst | Rendered output |
| :--- | :--- | :--- |
| 1 `*Enabled = true*:` | | **Enabled = true:** |
| 2 `#codly(enabled: true)` | | 1 Hello, world! |
| 3 ``typ | | |
| 4 Hello, world! | | **Enabled = false:** |
| 5 ``` | | Hello, world! |
| 6 | | |
| 7 `*Enabled = false*:` | | |
| 8 `#codly(enabled: false)` | | |
| 9 ``typ | | |
| 10 Hello, world! | | |
| 11 ``` | | |

### 2.2. Header (`header`)

| </> Type | `content` or `none` |
| :--- | :--- |
| {*} Default value | `none` |
| Contextual function | ✓ yes |
| Automatically reset | ✓ yes |
| Already released in 1.3.1 | ✓ yes |

An optional header to display above the code block. It can be optionally repeated on all subsequent pages with the `header-repeat` argument. And additional customizations are available with the `header-cell-args` and `header-transform` arguments.

#### 2.2.1. Example

| Example code | Typst | Rendered output |
| :--- | :--- | :--- |
| 1 `#codly(header: [*Hello, world!*])` | | **Hello, world!** |
| 2 ``typ | | 1 Hello, world! |
| 3 Hello, world! | | |
| 4 ``` | | |

### 2.3. Header Repeat (`header-repeat`)

| </> Type | `bool` |
| :--- | :--- |
| {*} Default value | `false` |
| Contextual function | ✓ yes |
| Automatically reset | x no |
| Already released in 1.3.1 | ✓ yes |

Whether to repeat the header on each page. This is only applicable if a header is provided, if the code block is `breakable`, and if it actually breaks on more than one page. For more information see `grid.header:repeat`.

### 2.4. Header Cell Args (`header-cell-args`)

| </> Type | `array`, `dictionary`, or `arguments` |
| :--- | :--- |
| {*} Default value | `()` |
| Contextual function | ✓ yes |
| Automatically reset | x no |
| Already released in 1.3.1 | ✓ yes |

Additional arguments to be provided to the `grid.cell` containing the header. Lets you customize the header cell further. Internally, codly wraps the content of the `header` argument in a `grid.cell` with these arguments. The only argument that is always common is the `body` argument which is the value of the `header` argument, and the `colspan` which is always set to 2.

For a full description of the argument, look at the documentation of the `grid.cell` function.

#### 2.4.1. Example

| Example code | Typst | Rendered output |
| :--- | :--- | :--- |
| 1 `//Centering the header:` | | **Hello, world!** |
| 2 `#codly(` | | 1 Hello, world! |
| 3 `header: [*Hello, world!*],` | | |
| 4 `header-cell-args: (align: center, )` | | |
| 5 `)` | | |
| 6 | | |
| 7 ``typ | | |
| 8 `Hello, world!` | | |
| 9 ``` | | |

### 2.5. Header Transform (`header-transform`)

| </> Type | `function` |
| :--- | :--- |
| {*} Default value | `(x) => x` |
| Contextual function | x no |
| Automatically reset | x no |
| Already released in 1.3.1 | ✓ yes |

Function that transforms the header into arbitrary content to be stored in the `grid.cell`. Can be seen as a show-rule for the header. This allows to perform global transformation/show-rule like operations on the header.

#### 2.5.1. Example

| Example code | Typst | Rendered output |
| :--- | :--- | :--- |
| 1 `//Making the header bold and blue:` | | **Hello, world!** |
| 2 `#codly(` | | 1 Hello, world! |
| 3 `header: [Hello, world!],` | | |
| 4 `header-transform: (x) => {` | | |
| 5 `set text(fill: blue)` | | |
| 6 `strong(x)` | | |
| 7 `}` | | |
| 8 `)` | | |
| 9 | | |
| 10 ``typ | | |
| 11 `Hello, world!` | | |
| 12 ``` | | |

### 2.6. Footer (`footer`)

| </> Type | `content` or `none` |
| :--- | :--- |
| {*} Default value | `none` |
| Contextual function | ✓ yes |
| Automatically reset | ✓ yes |
| Already released in 1.3.1 | ✓ yes |

An optional footer to display below the code block. See `header` for more information.

#### 2.6.1. Example

| Example code | Typst | Rendered output |
| :--- | :--- | :--- |
| 1 `#codly(footer: [*Hello, world!*])` | | 1 Hello, world! |
| 2 ``typ | | **Hello, world!** |
| 3 `Hello, world!` | | |
| 4 ``` | | |

### 2.7. Footer Repeat (`footer-repeat`)

| </> Type | `bool` |
| :--- | :--- |
| {*} Default value | `false` |
| Contextual function | ✓ yes |
| Automatically reset | x no |
| Already released in 1.3.1 | ✓ yes |

Whether to repeat the footer on each page. See `header-repeat` for more information.

### 2.8. Footer Cell Args (`footer-cell-args`)

| </> Type | `array`, `dictionary`, or `arguments` |
| :--- | :--- |
| {*} Default value | `()` |
| Contextual function | ✓ yes |
| Automatically reset | x no |
| Already released in 1.3.1 | ✓ yes |

Additional arguments to be provided to the `grid.cell` containing the footer. See `header-cell-args` for more information.

#### 2.8.1. Example

| Example code | Typst | Rendered output |
| :--- | :--- | :--- |
| 1 `//Centering the footer:` | | 1 Hello, world! |
| 2 `#codly(` | | **Hello, world!** |
| 3 `footer: [*Hello, world!*],` | | |
| 4 `footer-cell-args: (align: center, )` | | |
| 5 `)` | | |
| 6 | | |
| 7 ``typ | | |
| 8 `Hello, world!` | | |
| 9 ``` | | |

### 2.9. Footer Transform (`footer-transform`)

| </> Type | `function` |
| :--- | :--- |
| {*} Default value | `(x) => x` |
| Contextual function | x no |
| Automatically reset | x no |
| Already released in 1.3.1 | ✓ yes |

Function that transforms the footer into arbitrary content to be stored in the `grid.cell`. Can be seen as a show-rule for the footer. See `header-transform` for more information.

#### 2.9.1. Example

| Example code | Typst | Rendered output |
| :--- | :--- | :--- |
| 1 `//Making the footer bold and blue:` | | 1 Hello, world! |
| 2 `#codly(` | | **Hello, world!** |
| 3 `footer: [Hello, world!],` | | |
| 4 `footer-transform: (x) => {` | | |
| 5 `set text(fill: blue)` | | |
| 6 `strong(x)` | | |
| 7 `}` | | |
| 8 `)` | | |
| 9 | | |
| 10 ``typ | | |
| 11 `Hello, world!` | | |
| 12 ``` | | |

### 2.10. Offset (`offset`)

| </> Type | `int` |
| :--- | :--- |
| {*} Default value | `0` |
| Contextual function | ✓ yes |
| Automatically reset | ✓ yes |
| Already released in 1.3.1 | ✓ yes |

The offset to apply to line numbers.
This is purely cosmetic, only impacting the shown line numbers in the final output.

#### 2.10.1. Example

| Example code | Typst | Rendered output |
| :--- | :--- | :--- |
| 1 `*No offset*:` | | **No offset:** |
| 2 ``typ | | 1 Hello, world! |
| 3 `Hello, world!` | | |
| 4 ``` | | **Offset by 5:** |
| 5 | | 6 Hello, world! |
| 6 `*Offset by 5*:` | | |
| 7 `#codly(offset: 5)` | | |
| 8 ``typ | | |
| 9 `Hello, world!` | | |
| 10 ``` | | |

### 2.11. Offset from other code block (`offset-from`)

| </> Type | `none` or `label` |
| :--- | :--- |
| {*} Default value | `none` |
| Contextual function | ✓ yes |
| Automatically reset | ✓ yes |
| Already released in 1.3.1 | ✓ yes |

The offset to apply to line numbers, relative to another code block. This is useful when you want to match line numbers between two code blocks. This code block will continue the line numbers from the other code block, with the specified offset.

This is done by giving a `label` to the parent raw block, and then setting it as the `offset-from` on the second code block.

> **Info**
> Note that the offset obtained from the other code block is added to the offset specified in the `offset` argument.

> **Warning**
> **Important:** this feature works with any `offset` set on the other code block, including `offset-from` but may give unexpected results if both code blocks have `offset-from` set to each other or if the preceeding code block has `range` or `skips` set.

> **Experiment**
> This feature should be considered experimental. Please report any issues you encounter on GitHub: <https://github.com/Dherse/codly>.

#### 2.11.1. Example

| Example code | Typst | Rendered output |
| :--- | :--- | :--- |
| 1 ``py | | 1 def fib(n): |
| 2 `def fib(n):` | | 2 if n <= 1: |
| 3 `if n <= 1:` | | 3 return n |
| 4 `return n` | | 4 return fib(n - 1) + fib(n - 2) |
| 5 `return fib(n - 1) + fib(n - 2)` | | **Will continue at line 5** |
| 6 `<\fib-fn>` | | 5 fib(25) |
| 7 ``` | | |
| 8 `*Will continue at line 5*` | | |
| 9 `#codly(offset-from: <fib-fn>)` | | |
| 10 ``py | | |
| 11 `fib(25)` | | |
| 12 ``` | | |

### 2.12. Range (`range`)

| </> Type | `none` or `array` |
| :--- | :--- |
| {*} Default value | `none` |
| Contextual function | ✓ yes |
| Automatically reset | ✓ yes |
| Already released in 1.3.1 | ✓ yes |

The range of line numbers to display, one-indexed. If set to `none`, all lines are displayed. Can also be achieved using the convenience function `codly-range`. If set to `none`, all lines are displayed.

> **Info**
> Line numbers are one-indexed, meaning that to reference the fourth line, you use the number `4`.

#### 2.12.1. Example

| Example code | Typst | Rendered output |
| :--- | :--- | :--- |
| 1 `#codly(range: (2, 4))` | | 2 if n <= 1: |
| 2 ``py | | 3 return n |
| 3 `def fib(n):` | | 4 return fib(n - 1) + fib(n - 2) |
| 4 `if n <= 1:` | | |
| 5 `return n` | | |
| 6 `return fib(n - 1) + fib(n - 2)` | | |
| 7 `fib(25)` | | |
| 8 ``` | | |

### 2.13. Ranges (`ranges`)

| </> Type | `none` or `array` |
| :--- | :--- |
| {*} Default value | `none` |
| Contextual function | ✓ yes |
| Automatically reset | ✓ yes |
| Already released in 1.3.1 | ✓ yes |

The ranges of line numbers to display, one-indexed. If set to `none`, all lines are displayed. Can also be achieved using the convenience function `codly-range` if provided with more than one range. If set to `none`, all lines are displayed. Note that it override the `range` argument.

> **Info**
> Line numbers are one-indexed, meaning that to reference the fourth line, you use the number `4`.

#### 2.13.1. Example

| Example code | Typst | Rendered output |
| :--- | :--- | :--- |
| 1 `#codly(ranges: ((2, 2), (4, 4)))` | | 2 if n <= 1: |
| 2 ``py | | 4 return fib(n - 1) + fib(n - 2) |
| 3 `def fib(n):` | | |
| 4 `if n <= 1:` | | |
| 5 `return n` | | |
| 6 `return fib(n - 1) + fib(n - 2)` | | |
| 7 `fib(25)` | | |
| 8 ``` | | |

### 2.14. Smart skip (`smart-skip`)

| </> Type | `bool` or `dictionary` |
| :--- | :--- |
| {*} Default value | `false` |
| Contextual function | ✓ yes |
| Automatically reset | x no |
| Already released in 1.3.1 | ✓ yes |

Whether to automatically insert a `skips` entry between ranges of displayed values. They must be discontinuous for a skip to be added. The skip will be the size of the discontinuity. It can also be a dictionary with the keys:
*   `first`: whether to include a skip if the start of the block is outside of the ranges
*   `last`: whether to include a skip if the end of the code block is outside of the ranges
*   `rest`: whether to include a skip for unspecified values and/or in the middle of the code block.

You can specify one or more of these keys, if the `rest` is not specified, it defaults to `none`.

> **Experiment**
> This feature should be considered experimental. Please report any issues you encounter on GitHub: <https://github.com/Dherse/codly>.

#### 2.14.1. Example

| Example code | Typst | Rendered output |
| :--- | :--- | :--- |
| 1 `#codly(` | | 2 if n <= 1: |
| 2 `smart-skip: true,` | | 4 return fib(n - 1) + fib(n - 2) |
| 3 `ranges: ((2, 2), (4, 4))` | | |
| 4 `)` | | |
| 5 ``py | | |
| 6 `def fib(n):` | | |
| 7 `if n <= 1:` | | |
| 8 `return n` | | |
| 9 `return fib(n - 1) + fib(n - 2)` | | |
| 10 `fib(25)` | | |
| 11 ``` | | |

#### 2.14.2. Example: Using a dictionary

| Example code | Typst | Rendered output |
| :--- | :--- | :--- |
| 1 `#codly(` | | 2 if n <= 1: |
| 2 `smart-skip: (` | | 4 return fib(n - 1) + fib(n - 2) |
| 3 `first: false,` | | |
| 4 `last: false,` | | |
| 5 `rest: true` | | |
| 6 `),` | | |
| 7 `ranges: ((2, 2), (4, 4))` | | |
| 8 `)` | | |
| 9 ``py | | |
| 10 `def fib(n):` | | |
| 11 `if n <= 1:` | | |
| 12 `return n` | | |
| 13 `return fib(n - 1) + fib(n - 2)` | | |
| 14 `fib(25)` | | |
| 15 ``` | | |

### 2.15. Languages (`languages`)

| </> Type | `dictionary` |
| :--- | :--- |
| {*} Default value | `(:)` |
| Contextual function | ✓ yes |
| Automatically reset | x no |
| Already released in 1.3.1 | ✓ yes |

The language definitions to use for language block formatting. It is defined as a dictionary where the keys are the language names and each value is another dictionary containing the following keys:

*   `name`: the "pretty" name of the language as a `content`/showable value
*   `color`: the color of the language, if omitted uses the default color
*   `icon`: the icon of the language, if omitted no icon is shown.

If an entry is missing, and language blocks are enabled, will show the "un-prettified" language name, with the default color.

#### 2.15.1. Example

| Example code | Typst | Rendered output |
| :--- | :--- | :--- |
| 1 `#codly(` | | 1 def fib(n): |
| 2 `languages: (` | | 2 if n <= 1: |
| 3 `py: (` | | 3 return n |
| 4 `name: [Python], color: green, icon: ""` | | 4 return fib(n - 1) + fib(n - 2) |
| 5 `),` | | 5 fib(25) |
| 6 `)` | | |
| 7 `)` | | |
| 8 ``py | | |
| 9 `def fib(n):` | | |
| 10 `if n <= 1:` | | |
| 11 `return n` | | |
| 12 `return fib(n - 1) + fib(n - 2)` | | |
| 13 `fib(25)` | | |
| 14 ``` | | |

#### 2.15.2. Pre-existing language definitions

> **Info**
> Check out the `codly-languages` package on Typst universe. It contains pre-definition for many language and is extremely easy to use. You can consider it officially endorsed by the codly author as of the 19th of November 2024.

| Example code | Typst | Rendered output |
| :--- | :--- | :--- |
| 1 `#import "@preview/codly-languages:0.1.7": *` | | 1 fn main() { |
| 2 `#codly(languages: codly-languages)` | | 2 println!("Hello, world!"); |
| 3 ``rust | | 3 } |
| 4 `fn main() {` | | 1 const std = @import("std"); |
| 5 `println!("Hello, world!");` | | 2 |
| 6 `}` | | 3 pub fn main() void { |
| 7 ``` | | 4 std.debug.print("Hello, world!", {}); |
| 8 ``zig | | 5 } |
| 9 `const std = @import("std");` | | |
| 10 | | |
| 11 `pub fn main() void {` | | |
| 12 `std.debug.print("Hello, world!", .{});` | | |
| 13 `}` | | |
| 14 ``` | | |

### 2.16. Default language color (`default-color`)

| </> Type | `color`, `gradient`, or `tiling` |
| :--- | :--- |
| {*} Default value | `rgb("#283593")` |
| Contextual function | ✓ yes |
| Automatically reset | x no |
| Already released in 1.3.1 | ✓ yes |

The default color to use for language blocks. Used when a language is not defined in the `languages` argument. Also note that it is only used when the `lang-format` is its `auto` or you are using it in a custom formatter. If you are using a custom formatter, it is passed to the formatter as a named argument `color`.

#### 2.16.1. Example

| Example code | Typst | Rendered output |
| :--- | :--- | :--- |
| 1 `*Default color*:` | | **Default color:** |
| 2 ``py | | 1 print('Hello, world!') |
| 3 `print('Hello, world!')` | | 2 print('Hello, world!') |
| 4 `print('Hello, world!')` | | |
| 5 ``` | | **Overriden default color:** |
| 6 `*Overriden default color*:` | | 1 print('Hello, world!') |
| 7 `#codly(default-color: orange)` | | 2 print('Hello, world!') |
| 8 ``py | | |
| 9 `print('Hello, world!')` | | |
| 10 `print('Hello, world!')` | | |
| 11 ``` | | |

### 2.17. Radius (`radius`)

| </> Type | `length` |
| :--- | :--- |
| {*} Default value | `0.32em` |
| Contextual function | ✓ yes |
| Automatically reset | x no |
| Already released in 1.3.1 | ✓ yes |

The radius of the border of the code block, see `block.radius` for more information.

#### 2.17.1. Example

| Example code | Typst | Rendered output |
| :--- | :--- | :--- |
| 1 `*Default radius*:` | | **Default radius:** |
| 2 ``py | | 1 print('Hello, world!') |
| 3 `print('Hello, world!')` | | 2 print('Hello, world!') |
| 4 `print('Hello, world!')` | | |
| 5 ``` | | **Overriden radius:** |
| 6 `*Overriden radius*:` | | 1 print('Hello, world!') |
| 7 `#codly(radius: 2em)` | | 2 print('Hello, world!') |
| 8 ``py | | |
| 9 `print('Hello, world!')` | | **Zero radius:** |
| 10 `print('Hello, world!')` | | 1 print('Hello, world!') |
| 11 ``` | | 2 print('Hello, world!') |
| 12 `*Zero radius*:` | | |
| 13 `#codly(radius: 0pt)` | | |
| 14 ``py | | |
| 15 `print('Hello, world!')` | | |
| 16 `print('Hello, world!')` | | |
| 17 ``` | | |

### 2.18. Inset (`inset`)

| </> Type | `length` or `dictionary` |
| :--- | :--- |
| {*} Default value | `0.32em` |
| Contextual function | ✓ yes |
| Automatically reset | x no |
| Already released in 1.3.1 | ✓ yes |

Inset of the code lines, that is the distance between the border and the code lines. It can also be a dictionary with the keys same keys as in the Tyspt built-in `block.inset`.

#### 2.18.1. Example

| Example code | Typst | Rendered output |
| :--- | :--- | :--- |
| 1 `*Default inset*:` | | **Default inset:** |
| 2 ``py | | 1 print('Hello, world!') |
| 3 `print('Hello, world!')` | | |
| 4 ``` | | **Overriden inset:** |
| 5 `*Overriden inset*:` | | 1 print('Hello, world!') |
| 6 `#codly(inset: 1em)` | | |
| 7 ``py | | |
| 8 `print('Hello, world!')` | | |
| 9 ``` | | |

#### 2.18.2. Example: Dictionary inset

| Example code | Typst | Rendered output |
| :--- | :--- | :--- |
| 1 `*Default inset*:` | | **Default inset:** |
| 2 ``py | | 1 print('Hello, world!') |
| 3 `print('Hello, world!')` | | |
| 4 ``` | | **Overriden inset:** |
| 5 `*Overriden inset*:` | | 1 print('Hello, world!') |
| 6 `#codly(inset: (x: 0.32em, y: 0.1em))` | | |
| 7 ``py | | |
| 8 `print('Hello, world!')` | | |
| 9 ``` | | |

### 2.19. Fill (`fill`)

| </> Type | `none`, `color`, `gradient`, or `tiling` |
| :--- | :--- |
| {*} Default value | `none` |
| Contextual function | ✓ yes |
| Automatically reset | x no |
| Already released in 1.3.1 | ✓ yes |

The fill of the code block when not zebra-striped.

#### 2.19.1. Example

| Example code | Typst | Rendered output |
| :--- | :--- | :--- |
| 1 `*Default fill*:` | | **Default fill:** |
| 2 ``py | | 1 print('Hello, world!') |
| 3 `print('Hello, world!')` | | 2 print('Hello, world!') |
| 4 `print('Hello, world!')` | | |
| 5 ``` | | **Overriden fill:** |
| 6 `*Overriden fill*:` | | 1 print('Hello, world!') |
| 7 `#codly(fill: gradient.linear(..color.map.flare))` | | 2 print('Hello, world!') |
| 8 ``py | | |
| 9 `print('Hello, world!')` | | **No fill:** |
| 10 `print('Hello, world!')` | | 1 print('Hello, world!') |
| 11 ``` | | 2 print('Hello, world!') |
| 12 `*No fill*:` | | |
| 13 `#codly(fill: none)` | | |
| 14 ``py | | |
| 15 `print('Hello, world!')` | | |
| 16 `print('Hello, world!')` | | |
| 17 ``` | | |

### 2.20. Zebra fill (`zebra-fill`)

| </> Type | `none`, `color`, `gradient`, or `tiling` |
| :--- | :--- |
| {*} Default value | `luma(240)` |
| Contextual function | ✓ yes |
| Automatically reset | x no |
| Already released in 1.3.1 | ✓ yes |

Background color of the code lines when zebra-stripped. If set to `none`, no zebra-striping is applied.

#### 2.20.1. Example

| Example code | Typst | Rendered output |
| :--- | :--- | :--- |
| 1 `*Default zebra*:` | | **Default zebra:** |
| 2 ``py | | 1 print('Hello, world!') |
| 3 `print('Hello, world!')` | | 2 print('Hello, world!') |
| 4 `print('Hello, world!')` | | |
| 5 ``` | | **No zebra:** |
| 6 `*No zebra*:` | | 1 print('Hello, world!') |
| 7 `#codly(zebra-fill: none)` | | 2 print('Hello, world!') |
| 8 ``py | | |
| 9 `print('Hello, world!')` | | **Overriden zebra:** |
| 10 `print('Hello, world!')` | | 1 print('Hello, world!') |
| 11 ``` | | |
| 12 `*Overriden zebra*:` | | |
| 13 `#codly(zebra-fill: gradient.linear(..color.map.flare))` | | |
| 14 ``py | | |
| 15 `print('Hello, world!')` | | |
| 16 ``` | | |

### 2.21. Stroke (`stroke`)

| </> Type | `none` or `stroke` |
| :--- | :--- |
| {*} Default value | `1pt + luma(240)` |
| Contextual function | ✓ yes |
| Automatically reset | x no |
| Already released in 1.3.1 | ✓ yes |

The stroke to surround the whole code block with?

#### 2.21.1. Example

| Example code | Typst | Rendered output |
| :--- | :--- | :--- |
| 1 `*Default stroke*:` | | **Default stroke:** |
| 2 ``py | | 1 print('Hello, world!') |
| 3 `print('Hello, world!')` | | |
| 4 ``` | | **No stroke:** |
| 5 `*No stroke*:` | | 1 print('Hello, world!') |
| 6 `#codly(stroke: none)` | | |
| 7 ``py | | **Overriden stroke:** |
| 8 `print('Hello, world!')` | | 1 print('Hello, world!') |
| 9 ``` | | |
| 10 `*Overriden stroke*:` | | |
| 11 `#codly(stroke: 1pt + blue)` | | |
| 12 ``py | | |
| 13 `print('Hello, world!')` | | |
| 14 ``` | | |

### 2.22. Language box inset (`lang-inset`)

| </> Type | `length` or `dictionary` |
| :--- | :--- |
| {*} Default value | `0.32em` |
| Contextual function | ✓ yes |
| Automatically reset | x no |
| Already released in 1.3.1 | ✓ yes |

The inset of the language block. This only applies if you're using the default language block formatter. It can also be a dictionary with the keys same keys as in the Tyspt built-in `block.inset`.

#### 2.22.1. Example

| Example code | Typst | Rendered output |
| :--- | :--- | :--- |
| 1 `#codly(lang-inset: 5pt)` | | 1 print('Hello, world!') |
| 2 ``py | | 2 print('Goodbye, world!') |
| 3 `print('Hello, world!')` | | |
| 4 `print('Goodbye, world!')` | | |
| 5 ``` | | |

### 2.23. Language box outset (`lang-outset`)

| </> Type | `dictionary` |
| :--- | :--- |
| {*} Default value | `(x: 0.32em, y: 0em)` |
| Contextual function | ✓ yes |
| Automatically reset | x no |
| Already released in 1.3.1 | ✓ yes |

The X and Y outset of the language block, applied as a `dx` and `dy` during the `place` operation. This applies in every case, whether or not you're using the default language block formatter. The default value is chosen to get rid of the `inset` applied to each line.

#### 2.23.1. Example

| Example code | Typst | Rendered output |
| :--- | :--- | :--- |
| 1 `#codly(lang-outset: (x: -10pt, y: 5pt))` | | 1 print('Hello, world!') |
| 2 ``py | | 2 print('Goodbye, world!') |
| 3 `print('Hello, world!')` | | |
| 4 `print('Goodbye, world!')` | | |
| 5 ``` | | |

### 2.24. Language box radius (`lang-radius`)

| </> Type | `length` |
| :--- | :--- |
| {*} Default value | `0.32em` |
| Contextual function | ✓ yes |
| Automatically reset | x no |
| Already released in 1.3.1 | ✓ yes |

The radius of the border of the language block.

#### 2.24.1. Example

| Example code | Typst | Rendered output |
| :--- | :--- | :--- |
| 1 `#codly(lang-radius: 10pt)` | | 1 print('Hello, world!') |
| 2 ``py | | 2 print('Goodbye, world!') |
| 3 `print('Hello, world!')` | | |
| 4 `print('Goodbye, world!')` | | |
| 5 ``` | | |

### 2.25. Language box stroke (`lang-stroke`)

| </> Type | `none`, `stroke`, or `function` |
| :--- | :--- |
| {*} Default value | `(lang) => lang.color + 0.5pt` |
| Contextual function | x no |
| Automatically reset | x no |
| Already released in 1.3.1 | ✓ yes |

The stroke of the language block. Can be a function that takes in the language dictionary or `none` (see argument `languages`) and returns a stroke.

#### 2.25.1. Example

| Example code | Typst | Rendered output |
| :--- | :--- | :--- |
| 1 `*Fixed stroke*:` | | **Fixed stroke:** |
| 2 `#codly(lang-stroke: 1pt + red)` | | 1 print('Hello, world!') |
| 3 ``py | | 2 print('Goodbye, world!') |
| 4 `print('Hello, world!')` | | |
| 5 `print('Goodbye, world!')` | | **Function mapping:** |
| 6 ``` | | 1 print('Hello, world!') |
| 7 `*Function mapping*:` | | 2 print('Goodbye, world!') |
| 8 `#codly(lang-stroke: (lang) => 2pt + lang.color)` | | |
| 9 ``py | | |
| 10 `print('Hello, world!')` | | |
| 11 `print('Goodbye, world!')` | | |
| 12 ``` | | |

### 2.26. Language box fill (`lang-fill`)

| </> Type | `none`, `color`, `gradient`, `tiling`, or `function` |
| :--- | :--- |
| {*} Default value | `(lang) => lang.color.lighten(80%)` |
| Contextual function | x no |
| Automatically reset | x no |
| Already released in 1.3.1 | ✓ yes |

The background color of the language block. Can be a function that takes in the language dictionary or `none` (see argument `languages`) and returns a stroke.

#### 2.26.1. Example

| Example code | Typst | Rendered output |
| :--- | :--- | :--- |
| 1 `*Fixed fill*:` | | **Fixed fill:** |
| 2 `#codly(lang-fill: red)` | | 1 print('Hello, world!') |
| 3 ``py | | 2 print('Goodbye, world!') |
| 4 `print('Hello, world!')` | | |
| 5 `print('Goodbye, world!')` | | **Function mapping:** |
| 6 ``` | | 1 print('Hello, world!') |
| 7 `*Function mapping*:` | | 2 print('Goodbye, world!') |
| 8 `#codly(lang-fill: (lang) => lang.color.lighten(40%))` | | |
| 9 ``py | | |
| 10 `print('Hello, world!')` | | |
| 11 `print('Goodbye, world!')` | | |
| 12 ``` | | |

### 2.27. Language box formatter (`lang-format`)

| </> Type | `type(auto)`, `none`, or `function` |
| :--- | :--- |
| {*} Default value | `auto` |
| Contextual function | x no |
| Automatically reset | x no |
| Already released in 1.3.1 | ✓ yes |

The formatter for the language block. A value of `none` will not display the language block. To use the default formatter, set to `auto`. The function takes three arguments:

*   `lang`: the language key (e.g. py)
*   `icon`: the language icon, can be none or empty content
*   `color`: the language color

The function should return a content/showable value.

> **Info**
> The language formatter should avoid using `state` as this can lead to quadratic execution time, see [typst/typst#5220](https://github.com/typst/typst/issues/5220) for more information. Internally, when set to `auto`, codly uses an inlined function to avoid using states.

#### 2.27.1. Example

| Example code | Typst | Rendered output |
| :--- | :--- | :--- |
| 1 `*Default formatter*:` | | **Default formatter:** |
| 2 ``py | | 1 print('Hello, world!') |
| 3 `print('Hello, world!')` | | |
| 4 ``` | | **Function mapping:** |
| 5 `*Function mapping*:` | | 1 print('Hello, world!') No! |
| 6 `#codly(lang-format: (_, _) => [No!]))` | | |
| 7 ``py | | |
| 8 `print('Hello, world!')` | | |
| 9 ``` | | |

### 2.28. Display language name (`display-name`)

| </> Type | `bool` |
| :--- | :--- |
| {*} Default value | `true` |
| Contextual function | ✓ yes |
| Automatically reset | x no |
| Already released in 1.3.1 | ✓ yes |

Whether to display the name of the language in the language block. This only applies if you're using the default language block formatter.

#### 2.28.1. Example

| Example code | Typst | Rendered output |
| :--- | :--- | :--- |
| 1 `#codly(` | | 1 print('Hello, world!') |
| 2 `display-name: false,` | | 2 print('Goodbye, world!') |
| 3 `languages: (` | | |
| 4 `py: (` | | |
| 5 `name: [Python], color: green,` | | |
| 6 `icon: ""` | | |
| 7 `),` | | |
| 8 `),` | | |
| 9 `)` | | |
| 10 ``py | | |
| 11 `print('Hello, world!')` | | |
| 12 `print('Goodbye, world!')` | | |
| 13 ``` | | |

### 2.29. Display language icon (`display-icon`)

| </> Type | `bool` |
| :--- | :--- |
| {*} Default value | `true` |
| Contextual function | ✓ yes |
| Automatically reset | x no |
| Already released in 1.3.1 | ✓ yes |

Whether to display the icon of the language in the language block. This only applies if you're using the default language block formatter.

#### 2.29.1. Example

| Example code | Typst | Rendered output |
| :--- | :--- | :--- |
| 1 `#codly(` | | 1 print('Hello, world!') Python |
| 2 `display-icon: false,` | | 2 print('Goodbye, world!') |
| 3 `languages: (` | | |
| 4 `py: (` | | |
| 5 `name: [Python], color: green,` | | |
| 6 `icon: ""` | | |
| 7 `),` | | |
| 8 `),` | | |
| 9 `)` | | |
| 10 ``py | | |
| 11 `print('Hello, world!')` | | |
| 12 `print('Goodbye, world!')` | | |
| 13 ``` | | |

### 2.30. Line number format (`number-format`)

| </> Type | `function` or `none` |
| :--- | :--- |
| {*} Default value | `numbering.with("1")` |
| Contextual function | x no |
| Automatically reset | x no |
| Already released in 1.3.1 | ✓ yes |

The format of the line numbers, a function that takes in number and returns a content. If set to `none`, disables line numbers.

#### 2.30.1. Example

| Example code | Typst | Rendered output |
| :--- | :--- | :--- |
| 1 `#codly(number-format: numbering.with("I."))` | | I. print('Hello, world!') |
| 2 ``py | | II. print('Goodbye, world!') |
| 3 `print('Hello, world!')` | | |
| 4 `print('Goodbye, world!')` | | |
| 5 ``` | | |

### 2.31. Line number alignment (`number-align`)

| </> Type | `alignment` |
| :--- | :--- |
| {*} Default value | `left + horizon` |
| Contextual function | ✓ yes |
| Automatically reset | x no |
| Already released in 1.3.1 | ✓ yes |

The alignment of the numbers.

#### 2.31.1. Example

| Example code | Typst | Rendered output |
| :--- | :--- | :--- |
| 1 `#codly(number-align: right + top)` | | 1 # Iterative Fibonacci |
| 2 ``py | | 2 # As opposed to the recursive |
| 3 `# Iterative Fibonacci` | | 3 # version |
| 4 `# As opposed to the recursive` | | 4 def fib(n): |
| 5 `# version` | | 5 if n <= 1: |
| 6 `def fib(n):` | | 6 return n |
| 7 `if n <= 1:` | | 7 last, current = 0, 1 |
| 8 `return n` | | 8 for _ in range(2, n + 1): |
| 9 `last, current = 0, 1` | | 9 last, current = current, last + current |
| 10 `for _ in range(2, n + 1):` | | 10 return current |
| 11 `last, current = current, last + current` | | 11 fib(25) |
| 12 `return current` | | |
| 13 `fib(25)` | | |
| 14 ``` | | |

### 2.32. Line number placement (`number-placement`)

| </> Type | `str` |
| :--- | :--- |
| {*} Default value | `"inside"` |
| Contextual function | x no |
| Automatically reset | x no |
| Already released in 1.3.1 | ✓ yes |

Sets the placement of the numbers, either `"inside"` (the default) or `"outside"` of the code block.

#### 2.32.1. Example

| Example code | Typst | Rendered output |
| :--- | :--- | :--- |
| 1 `*Line number outside of the block*:` | | **Line number outside of the block:** |
| 2 `#codly(number-placement: "outside")` | | 1 print('Hello, world!') |
| 3 ``py | | 2 print('Goodbye, world!') |
| 4 `print('Hello, world!')` | | |
| 5 `print('Goodbye, world!')` | | **Line number inside of the block:** |
| 6 ``` | | 1 print('Hello, world!') |
| 7 `*Line number inside of the block*:` | | 2 print('Goodbye, world!') |
| 8 `#codly(number-placement: "inside")` | | |
| 9 ``py | | |
| 10 `print('Hello, world!')` | | |
| 11 `print('Goodbye, world!')` | | |
| 12 ``` | | |

### 2.33. Smart indentation (`smart-indent`)

| </> Type | `bool` |
| :--- | :--- |
| {*} Default value | `true` |
| Contextual function | x no |
| Automatically reset | x no |
| Already released in 1.3.1 | ✓ yes |

Whether to use smart indentation, which will check for indentation on a line and use a bigger left side inset instead of spaces. This allows for linebreaks to continue at the same level of indentation. This is on by default, but disabling it can improve performance.

#### 2.33.1. Example

| Example code | Typst | Rendered output |
| :--- | :--- | :--- |
| 1 `*Enabled (default)*:` | | **Enabled (default):** |
| 2 ``py | | 1 def quicksort(L): |
| 3 `def quicksort(L):` | | 2 qsort = lambda L: () if L==[] else qsort([x for x in L[1:] if x< L]) + L[0:1] + qsort([x for x in L[1:] if x>=L]) |
| 4 `qsort = lambda L: () if L==[] else qsort([x for x in L[1:] if x< L[0]]) + L[0:1] + qsort([x for x in L[1:] if x>=L[0]])` | | 3 qsort(L) |
| 5 `qsort(L)` | | |
| 6 ``` | | **Disabled:** |
| 7 `*Disabled*:` | | 1 def quicksort(L): |
| 8 `#codly(smart-indent: false)` | | 2 qsort = lambda L: () if L==[] else qsort([x for x in L[1:] if x< L[0]]) + L[0:1] + qsort([x for x in L[1:] if x>=L[0]]) |
| 9 ``py | | 3 qsort(L)) |
| 10 `def quicksort(L):` | | |
| 11 `qsort = lambda L: () if L==[] else qsort([x for x in L[1:] if x< L[0]]) + L[0:1] + qsort([x for x in L[1:] if x>=L[0]])` | | |
| 12 `qsort(L))` | | |
| 13 ``` | | |

### 2.34. Skip last line if empty (`skip-last-empty`)

| </> Type | `bool` |
| :--- | :--- |
| {*} Default value | `true` |
| Contextual function | ✓ yes |
| Automatically reset | x no |
| Already released in 1.3.1 | ✓ yes |

Whether to automatically skip the last line of the code block if it is empty. This avoids having an unnecessary empty line at the end of the code block.

#### 2.34.1. Example

| Example code | Typst | Rendered output |
| :--- | :--- | :--- |
| 1 `*Enabled (default)*:` | | **Enabled (default):** |
| 2 ``py | | 1 def fib(n): |
| 3 `def fib(n):` | | 2 if n <= 1: |
| 4 `if n <= 1:` | | 3 return n |
| 5 `return n` | | 4 return fib(n - 1) + fib(n - 2) |
| 6 `return fib(n - 1) + fib(n - 2)` | | |
| 7 ``` | | **Disabled:** |
| 8 | | 1 def fib(n): |
| 9 `*Disabled*:` | | 2 if n <= 1: |
| 10 `#codly(skip-last-empty: false)` | | 3 return n |
| 11 ``py | | 4 return fib(n - 1) + fib(n - 2) |
| 12 `def fib(n):` | | 5 |
| 13 `if n <= 1:` | | |
| 14 `return n` | | |
| 15 `return fib(n - 1) + fib(n - 2)` | | |
| 16 ``` | | |
| 17 | | |

### 2.35. Breakable (`breakable`)

| </> Type | `bool` |
| :--- | :--- |
| {*} Default value | `true` |
| Contextual function | x no |
| Automatically reset | x no |
| Already released in 1.3.1 | ✓ yes |

Whether the codeblocks are breakable across page and column breaks.

### 2.36. Skips (`skips`)

| </> Type | `array` or `none` |
| :--- | :--- |
| {*} Default value | `none` |
| Contextual function | ✓ yes |
| Automatically reset | ✓ yes |
| Already released in 1.3.1 | ✓ yes |

Insert a skip at the specified line numbers, setting its offset to the length of the skip. The skip is formatted using the `skip-number` argument. Each skip is an array with two values: the line where the skip is inserted (zero indexed) and the number of lines of the skip. The same behavior can be achieved using the `codly-skip` function.

#### 2.36.1. Example

| Example code | Typst | Rendered output |
| :--- | :--- | :--- |
| 1 `#codly(skips: ((4, 32),))` | | 1 def fib(n): |
| 2 ``py | | 2 if n <= 1: |
| 3 `def fib(n):` | | 3 return n |
| 4 `if n <= 1:` | | 36 return fib(n - 1) + fib(n - 2) |
| 5 `return n` | | 37 fib(25) |
| 6 `return fib(n - 1) + fib(n - 2)` | | |
| 7 `fib(25)` | | |
| 8 ``` | | |

### 2.37. Skip line (`skip-line`)

| </> Type | `content` or `none` |
| :--- | :--- |
| {*} Default value | `align(center)[ ... ]` |
| Contextual function | ✓ yes |
| Automatically reset | x no |
| Already released in 1.3.1 | ✓ yes |

Sets the content with which the line code is filled when a skip is encountered.

#### 2.37.1. Example

| Example code | Typst | Rendered output |
| :--- | :--- | :--- |
| 1 `#codly(` | | 1 def fib(n): |
| 2 `skips: ((4, 32), ),` | | 2 if n <= 1: |
| 3 `skip-line: align(center, emoji.face.shock)` | | 3 return n |
| 4 `)` | | 36 return fib(n - 1) + fib(n - 2) |
| 5 ``py | | 37 fib(25) |
| 6 `def fib(n):` | | |
| 7 `if n <= 1:` | | |
| 8 `return n` | | |
| 9 `return fib(n - 1) + fib(n - 2)` | | |
| 10 `fib(25)` | | |
| 11 ``` | | |

### 2.38. Skip number (`skip-number`)

| </> Type | `content` or `none` |
| :--- | :--- |
| {*} Default value | `[ ... ]` |
| Contextual function | ✓ yes |
| Automatically reset | x no |
| Already released in 1.3.1 | ✓ yes |

Sets the content with which the line number columns is filled when a skip is encountered. If line numbers are disabled, this has no effect.

#### 2.38.1. Example

| Example code | Typst | Rendered output |
| :--- | :--- | :--- |
| 1 `#codly(` | | 1 def fib(n): |
| 2 `skips: ((4, 32), ),` | | 2 if n <= 1: |
| 3 `skip-number: align(center, emoji.face.shock)` | | 3 return n |
| 4 `)` | | 36 return fib(n - 1) + fib(n - 2) |
| 5 ``py | | 37 fib(25) |
| 6 `def fib(n):` | | |
| 7 `if n <= 1:` | | |
| 8 `return n` | | |
| 9 `return fib(n - 1) + fib(n - 2)` | | |
| 10 `fib(25)` | | |
| 11 ``` | | |

### 2.39. Annotations (`annotations`)

| </> Type | `array` or `none` |
| :--- | :--- |
| {*} Default value | `none` |
| Contextual function | ✓ yes |
| Automatically reset | ✓ yes |
| Already released in 1.3.1 | ✓ yes |

The annotations to display on the code block. A list of annotations that are automatically numbered and displayed on the right side of the code block.

Each entry is a dictionary with the following keys:
*   `start`: the line number to start the annotation
*   `end`: the line number to end the annotation, if missing or `none` the annotation will only contain the start line
*   `content`: the content of the annotation as a showable value, if missing or `none` the annotation will only contain the number
*   `label`: if and only if the code block is in a `figure`, sets the label by which the annotation can be referenced.

Generally you probably want the `content` to be contained within a `rotate(90deg)`.

**Note:** Annotations cannot overlap. **Known issues:**
*   Annotations that spread over a page break will not work correctly
*   Annotations on the first line of a code block will not work correctly.
*   Annotations that span lines that overflow (one line of code two lines of text) will not work correctly.

> **Info**
> Line numbers are one-indexed, meaning that to reference the fourth line, you use the number `4`.

> **Experiment**
> This feature should be considered experimental. Please report any issues you encounter on GitHub: <https://github.com/Dherse/codly>.

#### 2.39.1. Example

| Example code | Typst | Rendered output |
| :--- | :--- | :--- |
| 1 `#codly(` | | 1 def fib(n): |
| 2 `annotations: (` | | 2 if n <= 1: |
| 3 `(start: 2, end: 5,` | | 3 return n |
| 4 `content: block(` | | 4 else: |
| 5 `width: 2em,` | | 5 return fib(n - 1) + fib(n - 2) |
| 6 `rotate(-90deg, reflow: true,` | | 6 fib(25) |
| 7 `align(center)[Function body])` | | |
| 8 `)` | | |
| 9 `),` | | |
| 10 `),` | | |
| 11 `)` | | |
| 12 ``py | | |
| 13 `def fib(n):` | | |
| 14 `if n <= 1:` | | |
| 15 `return n` | | |
| 16 `else:` | | |
| 17 `return fib(n - 1) + fib(n - 2)` | | |
| 18 `fib(25)` | | |
| 19 ``` | | |

### 2.40. Annotation formatter (`annotation-format`)

| </> Type | `none` or `function` |
| :--- | :--- |
| {*} Default value | `numbering.with("(1)")` |
| Contextual function | x no |
| Automatically reset | x no |
| Already released in 1.3.1 | ✓ yes |

The format of the annotation number. Can be `none` or a function that formats the annotation number.

### 2.41. Highlight lines (`highlighted-lines`)

| </> Type | `array` or `none` |
| :--- | :--- |
| {*} Default value | `()` |
| Contextual function | ✓ yes |
| Automatically reset | ✓ yes |
| Already released in 1.3.1 | ✓ yes |

Changes the background fill of certain lines to give them the appearance of being highlighted. This is done by specifying an array of a combination of:

*   **line numbers**: the line number (one-indexed) as it is shown in the document (including offsets, skips, etc.)
*   **array of line number & fill**: an array of strictly two elements containing the line number (same as before) and a color, gradient, or pattern fill.

The default highlighting color is controlled by the `highlighted-default-color` argument.

> **Info**
> Line numbers are one-indexed, meaning that to reference the fourth line, you use the number `4`.

#### 2.41.1. Example

| Example code | Typst | Rendered output |
| :--- | :--- | :--- |
| 1 `*Using default highlight color*:` | | **Using default highlight color:** |
| 2 `#codly(` | | 1 def fib(n): |
| 3 `highlighted-lines: (1, 3)` | | 2 if n <= 1: |
| 4 `)` | | 3 return n |
| 5 ``py | | 4 else: |
| 6 `def fib(n):` | | 5 return fib(n - 1) + fib(n - 2) |
| 7 `if n <= 1:` | | 6 fib(25) |
| 8 `return n` | | |
| 9 `else:` | | **Per-line color selection:** |
| 10 `return fib(n - 1) + fib(n - 2)` | | 1 def fib(n): |
| 11 `fib(25)` | | 2 if n <= 1: |
| 12 ``` | | 3 return n |
| 13 `*Per-line color selection*:` | | 4 else: |
| 14 `#codly(` | | 5 return fib(n - 1) + fib(n - 2) |
| 15 `highlighted-lines: ((1, red.lighten(60%)), 2, 3)` | | 6 fib(25) |
| 16 `)``py | | |
| 17 `def fib(n):` | | |
| 18 `if n <= 1:` | | |
| 19 `return n` | | |
| 20 `else:` | | |
| 21 `return fib(n - 1) + fib(n - 2)` | | |
| 22 `fib(25)` | | |
| 23 ``` | | |

### 2.42. Highlight lines default color (`highlighted-default-color`)

| </> Type | `color`, `tiling`, or `gradient` |
| :--- | :--- |
| {*} Default value | `orange.lighten(60%)` |
| Contextual function | ✓ yes |
| Automatically reset | x no |
| Already released in 1.3.1 | ✓ yes |

Changes the default color of highlighted lines.

#### 2.42.1. Example

| Example code | Typst | Rendered output |
| :--- | :--- | :--- |
| 1 `*Using default highlight color*:` | | **Using default highlight color:** |
| 2 `#codly(` | | 1 def fib(n): |
| 3 `highlighted-default-color: green.lighten(60%),` | | 2 if n <= 1: |
| 4 `highlighted-lines: (1, 3)` | | 3 return n |
| 5 `)` | | 4 else: |
| 6 ``py | | 5 return fib(n - 1) + fib(n - 2) |
| 7 `def fib(n):` | | 6 fib(25) |
| 8 `if n <= 1:` | | |
| 9 `return n` | | **Per-line color selection still works:** |
| 10 `else:` | | 1 def fib(n): |
| 11 `return fib(n - 1) + fib(n - 2)` | | 2 if n <= 1: |
| 12 `fib(25)` | | 3 return n |
| 13 ``` | | 4 else: |
| 14 `*Per-line color selection still works*:` | | 5 return fib(n - 1) + fib(n - 2) |
| 15 `#codly(` | | 6 fib(25) |
| 16 `highlighted-lines: ((1, red.lighten(60%)), 2, 3)` | | |
| 17 `)``py` | | |
| 18 `def fib(n):` | | |
| 19 `if n <= 1:` | | |
| 20 `return n` | | |
| 21 `else:` | | |
| 22 `return fib(n - 1) + fib(n - 2)` | | |
| 23 `fib(25)` | | |
| 24 ``` | | |

### 2.43. Highlights (`highlights`)

| </> Type | `array` or `none` |
| :--- | :--- |
| {*} Default value | `none` |
| Contextual function | ✓ yes |
| Automatically reset | x no |
| Already released in 1.3.1 | ✓ yes |

You can apply highlights to the code block using the `highlights` argument. It consists of a list of dictionaries, each with the following keys:

*   `line`: the line number to start highlighting
*   `start`: the character position to start highlighting, zero if omitted or `none`
*   `end`: the character position to end highlighting, the end of the line if omitted or `none`
*   `fill`: the fill of the highlight, defaults to the default color
*   `tag`: an optional tag to be displayed alongside the highlight.
*   `inset`: overrides the global `highlight-inset`.
*   `baseline`: overrides the baseline which is set by default to the bottom component of `highlight-inset`.
*   `clip`: overrides the global `highlight-clip`.
*   `outset`: overrides the global `highlight-outset`.
*   `radius`: overrides the global `highlight-radius`.
*   `label`: if and only if the code block is in a `figure`, sets the label by which the highlight can be referenced.

As with other code block settings, annotations are reset after each code block.

> **Info**
> Line numbers are one-indexed, meaning that to reference the fourth line, you use the number `4`.
> Character positions are zero-indexed, meaning that to reference the fourth character, you use the number `3`.

#### 2.43.1. Example

| Example code | Typst | Rendered output |
| :--- | :--- | :--- |
| 1 `#codly(highlights: (` | | 1 def fib(n): |
| 2 `(line: 4, start: 2, end: none, fill: red),` | | 2 if n <= 1: |
| 3 `(line: 5, start: 13, end: 19, fill: green, tag: "(a)"),` | | 3 return n |
| 4 `(line: 5, start: 26, fill: blue, tag: "(b)"),` | | 4 else: |
| 5 `))` | | 5 return fib(n - 1) (a) + fib(n - 2) (b) |
| 6 ``py | | 6 print(fib(25)) |
| 7 `def fib(n):` | | |
| 8 `if n <= 1:` | | |
| 9 `return n` | | |
| 10 `else:` | | |
| 11 `return fib(n - 1) + fib(n - 2)` | | |
| 12 `print(fib(25))` | | |
| 13 ``` | | |

#### 2.43.2. Example: Local override of highlight parameters

You can override the global highlight parameters for a specific highlight by using the `inset`, `radius`, `clip`, and `outset` keys in the highlight dictionary.

| Example code | Typst | Rendered output |
| :--- | :--- | :--- |
| 1 `#codly(` | | 1 def fib(n): |
| 2 `highlights: (` | | 2 if n <= 1: |
| 3 `(line: 4, start: 2, end: none, fill: red),` | | 3 return n |
| 4 `(line: 5, start: 13, end: 19, fill: green, tag: "(a)", inset: 0.1em, radius: 0.5em),` | | 4 else: |
| 5 `(line: 5, start: 26, fill: blue, tag: "(b)", clip: false)` | | 5 return fib(n - 1) (a) + fib(n - 2) (b) |
| 6 `)` | | 6 print(fib(25)) |
| 7 `)` | | |
| 8 ``py | | |
| 9 `def fib(n):` | | |
| 10 `if n <= 1:` | | |
| 11 `return n` | | |
| 12 `else:` | | |
| 13 `return fib(n - 1) + fib(n - 2)` | | |
| 14 `print(fib(25))` | | |
| 15 ``` | | |

### 2.44. Highlight radius (`highlight-radius`)

| </> Type | `length` |
| :--- | :--- |
| {*} Default value | `0.32em` |
| Contextual function | ✓ yes |
| Automatically reset | ✓ yes |
| Already released in 1.3.1 | ✓ yes |

The radius of the highlights.

### 2.45. Highlight fill (`highlight-fill`)

| </> Type | `function` |
| :--- | :--- |
| {*} Default value | `(color) => color.lighten(80%)` |
| Contextual function | x no |
| Automatically reset | x no |
| Already released in 1.3.1 | ✓ yes |

The fill transformer of the highlights, is a function that takes in the highlight color and returns a fill.

### 2.46. Highlight stroke (`highlight-stroke`)

| </> Type | `stroke` or `function` |
| :--- | :--- |
| {*} Default value | `(color) => 0.5pt + color` |
| Contextual function | x no |
| Automatically reset | x no |
| Already released in 1.3.1 | ✓ yes |

The stroke transformer of the highlights, is a function that takes in the highlight color and returns a stroke.

### 2.47. Highlight inset (`highlight-inset`)

| </> Type | `length` or `dictionary` |
| :--- | :--- |
| {*} Default value | `0.32em` |
| Contextual function | ✓ yes |
| Automatically reset | x no |
| Already released in 1.3.1 | ✓ yes |

The inset of the highlight blocks. It can also be a dictionary with the keys same keys as in the Tyspt built-in `block.inset`.

#### 2.47.1. Example: Alignment of lines

If alignment between highlighted and non-highlighted lines is critical for your use case, as could be the case in presentation, you can set the horizontal inset to be zero, or close to zero, to maintain alignment between the lines.

| Example code | Typst | Rendered output |
| :--- | :--- | :--- |
| 1 `#codly(` | | 1 private val n = 0 |
| 2 `highlight-inset: (x: 0pt, y: 0.32em),` | | 2 private val n = 0 |
| 3 `highlights: ((line: 2, start: 0),)` | | |
| 4 `)` | | |
| 5 ``kotlin | | |
| 6 `private val n = 0` | | |
| 7 `private val n = 0` | | |
| 8 ``` | | |

### 2.48. Highlight outset (`highlight-outset`)

| </> Type | `length` or `dictionary` |
| :--- | :--- |
| {*} Default value | `0em` |
| Contextual function | ✓ yes |
| Automatically reset | x no |
| Already released in 1.3.1 | ✓ yes |

The outset of the highlight blocks. It can also be a dictionary with the keys same keys as in the Tyspt built-in `block.outset`.

### 2.49. Highlight clip (`highlight-clip`)

| </> Type | `bool` |
| :--- | :--- |
| {*} Default value | `true` |
| Contextual function | ✓ yes |
| Automatically reset | x no |
| Already released in 1.3.1 | ✓ yes |

Whether highlight box clips code. See the documentation of the Tyspt built-in `block.clip`.

### 2.50. Reference by (`reference-by`)

| </> Type | `str` |
| :--- | :--- |
| {*} Default value | `"line"` |
| Contextual function | ✓ yes |
| Automatically reset | x no |
| Already released in 1.3.1 | ✓ yes |

The mode by which references are displayed. Two modes are available:

*   `line`: references are displayed as line numbers
*   `item`: references are displayed as items, i.e by the `tag` for highlights and `content` for annotations.

### 2.51. Reference separator (`reference-sep`)

| </> Type | `str` or `content` |
| :--- | :--- |
| {*} Default value | `"-" ` |
| Contextual function | ✓ yes |
| Automatically reset | x no |
| Already released in 1.3.1 | ✓ yes |

The separator to use when referencing highlights and annotations.

### 2.52. Reference number format (`reference-number-format`)

| </> Type | `function` |
| :--- | :--- |
| {*} Default value | `numbering.with("1")` |
| Contextual function | x no |
| Automatically reset | x no |
| Already released in 1.3.1 | ✓ yes |

The format of the reference number line number, only used if `reference-by` is set to `"line"`.

### 2.53. Language name aliases (`aliases`)

| </> Type | `dictionary` |
| :--- | :--- |
| {*} Default value | `(:)` |
| Contextual function | x no |
| Automatically reset | x no |
| Already released in 1.3.1 | ✓ yes |

Creates aliases between languages, allowing them to have separate `languages` but the same syntax highlighting. An example of that could be `cuda` and `c++` having the same highlighting but different icons.

#### 2.53.1. Example

| Example code | Typst | Rendered output |
| :--- | :--- | :--- |
| 1 `#import "@preview/codly-languages:0.1.7": *` | | 1 int main() { |
| 2 | | 2 std::cout << "Hello, World!" << std::endl; |
| 3 `#codly(` | | 3 return 0; |
| 4 `languages: codly-languages,` | | 4 } |
| 5 `aliases: ("cuda": "c++")` | | |
| 6 `)` | | |
| 7 ``cuda | | |
| 8 `int main() {` | | |
| 9 `std::cout << "Hello, World!" << std::endl;` | | |
| 10 `return 0;` | | |
| 11 `}`` | | |

***
