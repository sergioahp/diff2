## 5. Other functions

### 5.1. Skip (`codly-skip`)

Convenience function for setting the skips, see the `skips` argument of the `codly` function.

### 5.2. Range (`codly-range`)

Convenience function for setting the range, see the `range` argument of the `codly` function. If you provide more than one range, as a list of arguments, it will set the `ranges` argument instead.

With a single range:

| Example code | Typst | Rendered output |
| :--- | :--- | :--- |
| 1 `#codly-range(2, end: 2)` | | 2 if n <= 1: |
| 2 ``py | | |
| 3 `def fib(n):` | | |
| 4 `if n <= 1:` | | |
| 5 `return n` | | |
| 6 `return fib(n - 1) + fib(n - 2)` | | |
| 7 `fib(25)` | | |
| 8 ``` | | |

With more than one range:

| Example code | Typst | Rendered output |
| :--- | :--- | :--- |
| 1 `#codly-range(2, end: 2, (4, 5))` | | 2 if n <= 1: |
| 2 ``py | | 4 return fib(n - 1) + fib(n - 2) |
| 3 `def fib(n):` | | 5 fib(25) |
| 4 `if n <= 1:` | | |
| 5 `return n` | | |
| 6 `return fib(n - 1) + fib(n - 2)` | | |
| 7 `fib(25)` | | |
| 8 ``` | | |

### 5.3. Offset (`codly-offset`)

Convenience function for setting the offset, see the `offset` argument of the `codly` function.

### 5.4. Local (`local`)

Codly provides a convenience function called `local` that allows you to locally override the global settings for a specific code block. This is useful when you want to apply a specific style to a code block without affecting the rest of the code blocks in your document. It works by overriding the default codly show rule locally with an override of the arguments by those you provide. It does not rely on states (much) and should no longer add layout passes to the rendering which could cause documents to not converge.

> **Warning**
> When using `nested: false` on your local states, the outermost local state will be overriden by the inner local state(s). This means that the inner local state will be the only one that is applied to the code block. And that any previous local states (in the same hierarchy) will be ignored for subsequent code blocks.

> **Info**
> Once custom elements become available in Typst, and codly moves to using those and set rules, this limitation will be lifted and you will be able to use nested local states without performance impact.

| Example code | Typst | Rendered output |
| :--- | :--- | :--- |
| 1 `*Global state with red color*` | | **Global state with red color** |
| 2 `#codly(fill: red)` | | 1 = Example |
| 3 ``typ | | 2 *Hello, World!* |
| 4 `= Example` | | **Locally set it to gray** |
| 5 `*Hello, World!*` | | 1 = Example |
| 6 ``` | | 2 *Hello, World!* |
| 7 `*Locally set it to gray*` | | **It's back to being red** |
| 8 `#local(` | | 1 = Example |
| 9 `fill: luma(240),` | | 2 *Hello, World!* |
| 10 ``typ | | |
| 11 `= Example` | | |
| 12 `*Hello, World!*` | | |
| 13 ``` | | |
| 14 `)` | | |
| 15 `* It's back to being red*` | | |
| 16 ``typ | | |
| 17 `= Example` | | |
| 18 `*Hello, World!*` | | |
| 19 ``` | | |

#### 5.4.1. Local state for per-language configuration

Additionally, local settings can be used to set per-language configuration using a show rule on your `raw` blocks. This can be done in one of two ways: by using a show rule on `raw.where(block: true, lang: "<lang>")` and calling the `local` function, or by using the `codly` function. The main differentiators are that the `local` function is faster and does not rely on states, while the `codly` function is more flexible, but slower and **will also style all following blocks**, you must therefore manually reset the changes.

> **Experiment**
> This should work in most cases, but this feature should be considered experimental. Please report any issues you encounter on GitHub: <https://github.com/Dherse/codly>.

> **Info**
> Note that you only want to do show rules on `raw` blocks where `block: true`, otherwise this will make your document slow.

> **Warning**
> If you use the `local` function in a show rule, nested local states **will not work** with the settings you have set! Use the `codly` method instead. If using the `codly` method, and you **must** manually reset the changed settings in the show rule!

| Example code | Typst | Rendered output |
| :--- | :--- | :--- |
| 1 `#show raw.where(block: true, lang: "rust"): local.with(` | | **Numbered with Roman numerals** |
| 2 `number-format: numbering.with("I")` | | I fn main() { |
| 3 `)` | | II println!("Rust code has Roman numbers"); |
| 4 | | III } |
| 5 `#show raw.where(block: true, lang: "py"): it => {` | | **Numbered with circled numbers** |
| 6 `codly(number-format: numbering.with("①"))` | | ① print("Python code has circled numbers") |
| 7 `it` | | **Override with local state** |
| 8 `codly(number-format: numbering.with("1"))` | | 1 print("Python code is green") |
| 9 `}` | | |
| 10 | | |
| 11 `*Numbered with Roman numerals*` | | |
| 12 ``rust | | |
| 13 `fn main() {` | | |
| 14 `println!("Rust code has Roman numbers");` | | |
| 15 `}` | | |
| 16 ``` | | |
| 17 | | |
| 18 `*Numbered with circled numbers*` | | |
| 19 ``py | | |
| 20 `print("Python code has circled numbers")` | | |
| 21 ``` | | |
| 22 | | |
| 23 `*Override with local state*` | | |
| 24 `#local(` | | |
| 25 `fill: blue.lighten(80%),` | | |
| 26 ``py | | |
| 27 `print("Python code is green")` | | |
| 28 ``` | | |
| 29 `)` | | |

#### 5.4.2. Nested local state

Codly does support nested local state, the innermost local state will override the outermost local state. This allows you to have different styles for different parts of your code block. This function takes the same arguments as the `codly` function, but only the arguments that are different from the global settings need to be provided.

> **Warning**
> Nested local states can slow down documents significantly if over-used (explicitly set `nested: true`). Use them sparingly and only when necessary. Another solution is to use the normal `codly` function before and after your code block. You can also use the the argument `nested: false` on `local` to prevent nested local states, which significantly reduces the performance impact.

| Example code | Typst | Rendered output |
| :--- | :--- | :--- |
| 1 `*Global state with red color*` | | **Global state with red color** |
| 2 `#codly(fill: red)` | | 1 = Example |
| 3 ``typ | | 2 *Hello, World!* |
| 4 `= Example` | | **Locally set it to blue** |
| 5 `*Hello, World!*` | | 1 = Example |
| 6 ``` | | 2 *Hello, World!* |
| 7 `*Locally set it to blue*` | | **Now it's green:** |
| 8 `#local(` | | 1 = Example |
| 9 `nested: true,` | | 2 *Hello, World!* |
| 10 `fill: blue,` | | **Now its zebras are also blue:** |
| 11 `) [` | | 1 = Example |
| 12 ``typ | | 2 *Hello, World!* |
| 13 `= Example` | | **Back to blue:** |
| 14 `*Hello, World!*` | | 1 = Example |
| 15 ``` | | 2 *Hello, World!* |
| 16 `*Now it's green:*` | | **Back to red:** |
| 17 `#local(nested: true, fill: green) [` | | 1 = Example |
| 18 ``typ | | 2 *Hello, World!* |
| 19 `= Example` | | |
| 20 `*Hello, World!*` | | |
| 21 ``` | | |
| 22 `]` | | |
| 23 `*Now its zebras are also blue:*` | | |
| 24 `#local(nested: true, zebra-fill: blue) [` | | |
| 25 ``typ | | |
| 26 `= Example` | | |
| 27 `*Hello, World!*` | | |
| 28 ``` | | |
| 29 `]` | | |
| 30 | | |
| 31 `*Back to blue:*` | | |
| 32 ``typ | | |
| 33 `= Example` | | |
| 34 `*Hello, World!*` | | |
| 35 ``` | | |
| 36 `]` | | |
| 37 `*Back to red:*` | | |
| 38 ``typ | | |
| 39 `= Example` | | |
| 40 `*Hello, World!*` | | |
| 41 ``` | | |

### 5.5. No Codly (`no-codly`)

This is a convenience function equivalent to `local(enabled: false, body)`.

| Example code | Typst | Rendered output |
| :--- | :--- | :--- |
| 1 `*Enabled codly*` | | **Enabled codly** |
| 2 ``typ | | 1 = Example |
| 3 `= Example` | | 2 *Hello, World!* |
| 4 `*Hello, World!*` | | **Disabled codly** |
| 5 ``` | | = Example |
| 6 | | *Hello, World!* |
| 7 `*Disabled codly*` | | |
| 8 `#no-codly[` | | |
| 9 ``typ | | |
| 10 `= Example` | | |
| 11 `*Hello, World!*` | | |
| 12 ``` | | |
| 13 `]` | | |

### 5.6. Yes Codly (`yes-codly`)

This is a convenience function equivalent to `local(enabled: false, body)`.

| Example code | Typst | Rendered output |
| :--- | :--- | :--- |
| 1 `*Disabled codly*` | | **Disabled codly** |
| 2 `#codly(enabled: false)` | | = Example |
| 3 ``typ | | *Hello, World!* |
| 4 `= Example` | | **Enabled codly** |
| 5 `*Hello, World!*` | | 1 = Example |
| 6 ``` | | 2 *Hello, World!* |
| 7 | | |
| 8 `*Enabled codly*` | | |
| 9 `#yes-codly[` | | |
| 10 ``typ | | |
| 11 `= Example` | | |
| 12 `*Hello, World!*` | | |
| 13 ``` | | |
| 14 `]` | | |

### 5.7. Enable (`codly-enable`)

Enables codly globally, equivalent to `codly(enabled: true)`.

| Example code | Typst | Rendered output |
| :--- | :--- | :--- |
| 1 `*Disabled codly*` | | **Disabled codly** |
| 2 `#codly-disable()` | | = Example |
| 3 ``typ | | *Hello, World!* |
| 4 `= Example` | | **Enabled codly** |
| 5 `*Hello, World!*` | | 1 = Example |
| 6 ``` | | 2 *Hello, World!* |
| 7 `#codly-enable()` | | |
| 8 `*Enabled codly*` | | |
| 9 ``typ | | |
| 10 `= Example` | | |
| 11 `*Hello, World!*` | | |
| 12 ``` | | |

### 5.8. Disable (`codly-disable`)

Disables codly globally, equivalent to `codly(enabled: false)`.

| Example code | Typst | Rendered output |
| :--- | :--- | :--- |
| 1 `*Enabled codly*` | | **Enabled codly** |
| 2 ``typ | | 1 = Example |
| 3 `= Example` | | 2 *Hello, World!* |
| 4 `*Hello, World!*` | | **Disabled codly** |
| 5 ``` | | = Example |
| 6 | | *Hello, World!* |
| 7 `*Disabled codly*` | | |
| 8 `#codly-disable()` | | |
| 9 ``typ | | |
| 10 `= Example` | | |
| 11 `*Hello, World!*` | | |
| 12 ``` | | |

### 5.9. Reset (`codly-reset`)

Resets all codly settings to their default values. This is useful when you want to reset the settings of a code block to the default values after applying local settings.

| Example code | Typst | Rendered output |
| :--- | :--- | :--- |
| 1 `*Global state with red color*` | | **Global state with red color** |
| 2 `#codly(fill: red)` | | 1 = Example |
| 3 ``typ | | 2 *Hello, World!* |
| 4 `= Example` | | **Reset it** |
| 5 `*Hello, World!*` | | 1 = Example |
| 6 ``` | | 2 *Hello, World!* |
| 7 `*Reset it*` | | |
| 8 `#codly-reset()` | | |
| 9 ``typ | | |
| 10 `= Example` | | |
| 11 `*Hello, World!*` | | |
| 12 ``` | | |

***
