## 3. Referencing code blocks, highlights, and annotations

This section of the documentation will detail how you can use codly to reference: lines, highlights, and annotations in your code blocks. To do this, here are the requirements that must be met for **each code block**:

*   Numbering of figures must be turned on: `set figure(numbering: ...)` .
*   The code block must be contained within a raw figure: `figure(kind: raw)[...]`.
*   The figure must have a label of its own: `figure(...)[...] <my-label>`.

### 3.1. Shorthand line references

You can reference lines directly, if you have set a label correctly, using the shorthand syntax `@my-label:2` to reference the second line (one-indexed) of the code block with the label `<my-label>`. It will always use the `reference-number-format` argument of the `codly` function to format the line number.

> **Info**
> Line numbers are one-indexed, meaning that to reference the fourth line, you use the number `4`.

> **Experiment**
> Due to upcoming changes to v0.13 of Typst, this entire feature has been re-done to be more robust, but that means that the styling might have changed slightly and it might have introduced new issues. If you find any issues, report them on <https://github.com/Dherse/codly>.

| Example code | Typst | Rendered output |
| :--- | :--- | :--- |
| 1 `#figure(` | | 1 = Example |
| 2 `caption: "A code block with a label"` | | 2 *Hello, world!* |
| 3 `) [` | | **Listing 1: A code block with a label** |
| 8 `] <my-label>` | | I can reference my code block: Listing 1. Or a specific line: Listing 1-2. |
| 9 `I can reference my code block: @my-label. Or a specific line: @my-label:2.` | | |

### 3.2. Highlight references

You can also highlight by reference, to do this, you need to set a label for your highlight in the `highlights` argument of the `codly` function. You can then reference the highlight using the shorthand syntax `@my-highlight` to reference the highlight with the label `<my-highlight>`. There are two supported `reference-by` modes:

*   `"line"`: references the line of the highlight
*   `"item"`: references the tag of the highlight, this requires that the `tag` be set for each tagged highlight.

| Example code | Typst | Rendered output |
| :--- | :--- | :--- |
| 1 `#codly(` | | 1 = Example |
| 2 `highlights: ((line: 2, start: 2, end: 7, label: <hl-1>),` | | 2 *Hello, world!* |
| 3 `))` | | **Listing 2: A code block with a label** |
| 13 `Reference a highlight by its label: @hl-1.` | | Reference a highlight by its label: Listing 2-2. |

And using `"item"` mode:

| Example code | Typst | Rendered output |
| :--- | :--- | :--- |
| 1 `#codly(` | | 1 = Example |
| 2 `highlights: ((line: 2, start: 2, end: 7, label: <hl-2>, tag: [ Highlight ]), ),` | | 2 *Hello, world! Highlight* |
| 3 `reference-by: "item",` | | **Listing 3: A code block with a label** |
| 4 `)` | | Reference a highlight by its label: Listing 3-Highlight. |
| 14 `Reference a highlight by its label: @hl-2.` | | |

***
