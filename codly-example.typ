#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#show: codly-init.with()

#codly(languages: codly-languages)

// Diff-style highlighting example using highlighted-lines for full line backgrounds
#codly(
  highlighted-lines: (
    (2, red.transparentize(75%)),    // Line 2: full line transparent red
    (3, green.transparentize(75%))   // Line 3: full line transparent green (more visible)
  ),
  highlight-fill: (color) => color,   // Don't modify the fill color - use it as-is
  highlight-stroke: (color) => 0pt,   // No border on highlights
  highlight-inset: (
    rest: 0pt,
    left: 0pt,
    right: 0pt,
    top: 0em,
    bottom: 0em,
  ),
  highlight-outset: (
    rest: 0pt,
    left: 0pt,
    right: 0pt,
    top: 0.08em,
    bottom: 0.08em,
  ),
  highlights: (
    // Line 2: Intense highlight for "Python 2.7 and 3.7" - saturated red
    (line: 2, start: 71, end: 89, fill: red.transparentize(50%)),
    // Line 3: Intense highlight for "different versions of Python" - saturated green
    (line: 3, start: 71, end: 101, fill: green.transparentize(50%)),
  )
)

```markdown
### Example scenario
As an example scenario, you could have different dev environments for Python 2.7 and 3.7.
As an example scenario, you could have different dev environments for different versions of Python.
```

// Second diff-style example inspired by the image
#codly(
  inset: 0pt,                         // No inset on the code block itself
  radius: 0pt,                        // No rounded corners on code block
  highlighted-lines: (
    (2, red.transparentize(75%)),    // Line 2: removed line - red background
    (3, red.transparentize(75%)),    // Line 3: removed line - red background
    (4, green.transparentize(75%)),  // Line 4: added line - green background
    (5, green.transparentize(75%))   // Line 5: added line - green background
  ),
  highlight-fill: (color) => color,
  highlight-stroke: (color) => 0pt,
  highlight-radius: 0pt,              // No rounded corners on highlights
  highlight-inset: (
    rest: 0pt,
    left: 0pt,
    right: 0pt,
    top: 0em,
    bottom: 0em,
  ),
  highlight-outset: (
    rest: 0pt,
    left: 0pt,
    right: 0pt,
    top: 0.08em,
    bottom: 0.08em,
  ),
  highlights: (
    // Red highlights for removed code fragments (line 2)
    (line: 2, start: 27, end: 32, fill: red.transparentize(40%)),    // "Tensor"
    (line: 2, start: 38, end: 41, fill: red.transparentize(40%)),    // "d_in"
    (line: 2, start: 55, end: 60, fill: red.transparentize(40%)),    // "Tensor"
    // Red highlights for removed code fragments (line 3)
    (line: 3, start: 12, end: 23, fill: red.transparentize(40%)),    // "(x - B_DEC)"
    (line: 3, start: 26, end: none, fill: red.transparentize(40%)),    // "W_ENC = TAU"
    // Green highlights for added code fragments (line 4)
    (line: 4, start: 27, end: 31, fill: green.transparentize(40%)),  // "Array"
    (line: 4, start: 37, end: 43, fill: green.transparentize(40%)),  // "d_model"
    (line: 4, start: 57, end: 61, fill: green.transparentize(40%)),  // "Array"
    // Green highlights for added code fragments (line 5)
    (line: 5, start: 12, end: 13, fill: green.transparentize(40%)),  // "x"
    (line: 5, start: 21, end: none, fill: green.transparentize(40%))   // "W_ENC + BIAS_TOTAL"
  )
)

```python
# Suggested change
def encode_batch(x: Float[Tensor, "b d_in"]) -> Float[Tensor, "b d_sae"]:
    return (x - B_DEC) @ W_ENC - TAU @ W_ENC - TAU
def encode_batch(x: Float[Array, "b d_model"]) -> Float[Array, "b d_sae"]:
    return x @ W_ENC^T + BIAS_TOTAL
```

// Example: Splitting a word in half with precise highlights
#let a = [#codly(
  inset: 0pt,
  radius: 0pt,
  highlighted-lines: (),
  highlight-fill: (color) => color,
  highlight-stroke: (color) => 0pt,
  highlight-radius: 0pt,
  highlight-inset: (
    rest: 0pt,
    left: 0pt,
    right: 0pt,
    top: 0em,
    bottom: 0em,
  ),
  highlight-outset: (
    rest: 0pt,
    left: 0pt,
    right: 0pt,
    top: 0.08em,
    bottom: 0.08em,
  ),
  highlights: (
    // Split "calculate_total_amount" - highlight "calculate" part
    (line: 1, start: 4, end: 13, fill: blue.transparentize(40%)),     // "calculate"
    // Split "calculate_total_amount" - highlight "total" part
    (line: 1, start: 14, end: 19, fill: yellow.transparentize(40%)),  // "total"
    // Split "calculate_total_amount" - highlight "amount" part
    (line: 1, start: 20, end: 26, fill: purple.transparentize(40%)), // "amount"
  )
)

```python
def calculate_total_amount(items):
    return sum(item.price for item in items)
```]


#a

#repr(a)


#let b = [abc#highlight(fill:red)[123]xyz]

#b

#repr(b)

