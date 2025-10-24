# Preserving Syntax Highlighting with Character-Level Inline Highlights

## The Problem

When working with `raw.line` elements in Typst, we want to add inline highlights at specific character positions while preserving the syntax highlighting colors that Typst's syntax highlighter applies.

For example, in a Python multiline string:
```python
"""
This is a multiline test string
"""
```

We want to highlight the word "test" with a yellow box while keeping the gray color that Python's syntax highlighter applies to string content.

## The Challenge

### Structure of raw.line.body

A `raw.line.body` is a `styled` element:
```typst
styled(child: [This is a multiline test string], ..)
```

For single-token content (like a Python string), the entire line is ONE styled element with:
- `.child`: The text content
- `.styles`: The styling information (contains the gray color)
- `.func()`: A function to reconstruct the styled element

### Why Simple Approaches Fail

**Approach 1: Extract text via `.child.text`**
```typst
let text = line.body.child.text.slice(20, 24) // "test"
text // ❌ Lost gray color - returns black text
```

**Approach 2: Iterate clusters and rebuild**
```typst
for (i, c) in text.clusters().enumerate() {
  parts.push(c) // ❌ Clusters are plain strings, lost styling
}
```

Both lose the syntax highlighting because we're working with plain text, not styled content.

## The Solution

Use `.func()` and `.styles` to reconstruct styled elements with sliced text:

```typst
// 1. Get the styling function and styles
let style-func = styled-elem.func()
let styles = styled-elem.styles

// 2. Slice the text
let full-text = styled-elem.child.text
let before = full-text.slice(0, 20)
let highlighted = full-text.slice(20, 24)  // "test"
let after = full-text.slice(24)

// 3. Reconstruct styled elements with same styling
style-func([#before], styles)
box(
  fill: yellow,
  style-func([#highlighted], styles)  // ✅ Gray text in yellow box!
)
style-func([#after], styles)
```

## How It Works

- `styled-elem.func()` returns the `styled()` constructor function
- First argument: The content to style
- Second argument: The styles to apply (includes the gray color)
- This recreates a styled element with new content but original styling

## Token vs Character Granularity

### Token-Based (for multi-token lines)

When `line.body` is a sequence with `.children`:
```typst
sequence(
  styled(child: [def], ..),
  styled(child: [ ], ..),
  styled(child: [cool_function], ..),
  ...
)
```

Each child is already a separate styled token. We can only wrap entire tokens in boxes.

### Character-Based (for single-token lines)

When `line.body` is a single styled element (like a long string), we can:
1. Extract the function and styles
2. Slice at any character position
3. Reconstruct styled elements for each slice

## Key Files

- `multiline-string-test.typ`: Shows the problem (single styled element)
- `char-based-highlight.typ`: Failed attempt (lost colors)
- `explore-styles-field.typ`: **Success!** Shows the `.func()` and `.styles` solution

## Important Notes

- The `.styles` field is opaque - we can't inspect it, but we can pass it to `.func()`
- This works for both single-color tokens and multi-color tokens
- For multiline strings, Python's highlighter preserves context even when we skip the opening `"""`
- Character positions use `.clusters()` for Unicode safety

---

# Eliminating Spacing from Show Rule Blocks

## The Problem

When using show rules to collect `raw.line` elements, wrapping them in content blocks `[...]` creates unwanted spacing in the document:

```typst
[
  #show raw.line: it => {
    state.update(s => s + (it,))
  }
  #code-block
]
```

This causes visible whitespace and displacement of surrounding content, even though the show rule is meant to just collect data without rendering.

## Why It Happens

- Content blocks `[...]` are rendered as part of document layout
- Even when show rules consume the `raw.line` elements, the outer block and brackets take up space
- Using `hide[]` makes content invisible but **still reserves layout space**

## The Solution

Wrap the collection block with `place([...])`:

```typst
place([
  #show raw.line: it => {
    state.update(s => s + (it,))
  }
  #code-block
])
```

### How It Works

1. **Show rule**: Already consumes the `raw.line` elements, so nothing renders
2. **`place()`**: Removes the content block from normal document flow
3. **Result**: No visual output AND no spacing impact

**Note**: Initially tried `place(hide[...])` but `hide[]` is unnecessary since the show rule already prevents rendering. `place([...])` alone is sufficient and simpler.

## Experiments Tried

See `spacing-solution.typ` for comprehensive tests:

| Approach | Visible? | Takes Space? | Collects Lines? |
|----------|----------|--------------|-----------------|
| `[...]` show rule | No* | Yes ❌ | Yes |
| `hide[...]` | No | Yes ❌ | Yes |
| `place(hide[...])` | No | **No ✅** | **Yes ✅** |
| `place([...])` | No | **No ✅** | **Yes ✅** |
| `metadata(...)` | No | No ✅ | No ❌ |
| Show rule returns `none` | Shows code | Yes ❌ | No ❌ |
| Show rule returns `[]` | Shows code | Yes ❌ | No ❌ |

*The show rule consumes raw.line elements so nothing renders, but the block still takes layout space.

**Winner**: `place([...])` - simplest solution that eliminates all spacing while preserving show rule functionality.

## Key Files

- `spacing-solution.typ`: Comprehensive tests showing all approaches (including `place(hide[...])`)
- `../state-solution.typ`: Main implementation using `place([...])` (lines 151-164)
