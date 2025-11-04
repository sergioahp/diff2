# New Diff Function Signature Design

## Overview

The new `diff()` function will handle line-level diffs with character-level inline highlighting for modified lines. It takes structured Typst content and outputs formatted diff visualization.

## Key Requirements

1. **Line-level diff types**: removed, added, unchanged (context)
2. **Skip lines**: Only show relevant context lines
3. **Color coding**:
   - RED background: Removed lines
   - GREEN background: Added lines
   - No background: Context lines
4. **Character-level highlights**: When removed line ≈ added line, show specific changes
5. **Pure Typst I/O**: Takes Typst content, outputs Typst content (no diffing logic)
6. **Future-proof**: Will integrate with Rust diff engine

## Proposed Signature

```typst
#let diff(
  lines: (),

  // Optional styling
  removed-bg: red.transparentize(80%),
  added-bg: green.transparentize(80%),
  context-bg: none,

  removed-inline: red.transparentize(20%),
  added-inline: green.transparentize(30%),

  // Display options
  show-line-numbers: true,
  font: "DejaVu Sans Mono",
)
```

### Line Record Format

Each line in the `lines` array is a dictionary with these fields:

```typst
// Context line (unchanged)
(
  type: "context",
  line-num: 5,
  content: ```py
  def unchanged_function():
  ```
)

// Removed line (standalone deletion)
(
  type: "removed",
  line-num: 10,
  content: ```py
  old_variable = calculate_old()
  ```
)

// Added line (standalone addition)
(
  type: "added",
  line-num: 15,
  content: ```py
  new_variable = calculate_new()
  ```
)

// Modified line pair (removed with character highlights)
(
  type: "removed",
  line-num: 20,
  content: ```py
  result = calculate_total(a, b)
  ```,
  spans: (
    (start: 0, end: 6, fill: red.transparentize(20%)),    // "result"
    (start: 9, end: 24, fill: red.transparentize(20%)),   // "calculate_total"
  ),
  paired: true,  // Indicates this is part of a modification
)

// Modified line pair (added with character highlights)
(
  type: "added",
  line-num: 20,
  content: ```py
  output = compute_sum(x, y)
  ```,
  spans: (
    (start: 0, end: 6, fill: green.transparentize(30%)),  // "output"
    (start: 9, end: 20, fill: green.transparentize(30%)), // "compute_sum"
  ),
  paired: true,  // Indicates this is part of a modification
)
```

### Field Definitions

- **type**: `"context"`, `"removed"`, or `"added"`
- **line-num**: Integer, original line number (1-based)
- **content**: Raw code block with syntax highlighting (```lang ... ```)
- **spans** (optional): Array of character-level highlights
  - **start**: Character position (0-based)
  - **end**: Character position (0-based, exclusive)
  - **fill**: Background color for this span
- **paired** (optional): Boolean, `true` if part of a modified line pair

## Implementation Strategy

### 1. Line Processing

```typst
for line-record in lines {
  match line-record.type {
    "context" => render-context-line(line-record),
    "removed" => render-removed-line(line-record),
    "added" => render-added-line(line-record),
  }
}
```

### 2. Character-Level Highlighting

Reuse existing `build-inline-smart()` logic:
- Multi-token lines: Use `build-inline-multitoken()`
- Single-token lines: Use `build-inline-char-level()`

### 3. State Management

No state needed! Each line record is self-contained:
- Line content is already extracted from raw blocks
- Line numbers are provided
- Spans are pre-calculated

This makes the function **pure** and **stateless**.

## Benefits of This Design

1. **Separation of Concerns**
   - Diffing logic (Rust) separate from rendering (Typst)
   - Easy to test each component independently

2. **Flexible**
   - Can show any combination of lines
   - Context lines can be anywhere
   - Line numbers can be non-contiguous

3. **Type-Safe**
   - Each line record is well-defined
   - Easy to validate inputs

4. **Extensible**
   - Can add new line types (e.g., "moved", "modified")
   - Can add metadata (author, timestamp, etc.)
   - Can customize colors per line

5. **Composable**
   - Can render multiple diffs on same page
   - No state leakage between calls
   - Can nest or combine diffs

## Migration Path

1. **Phase 1** (Current): Implement new signature alongside old `diff()`
2. **Phase 2**: Create Python/Rust bridge to generate line records
3. **Phase 3**: Integrate with Rust diff engine + Crane build
4. **Phase 4**: Add GitHub Actions CI with tests
5. **Phase 5**: Deprecate old signature

## Example Usage

### Simple Addition/Deletion

```typst
#diff(
  lines: (
    (type: "context", line-num: 10, content: ```py
    def main():
    ```),

    (type: "removed", line-num: 11, content: ```py
        print("Hello")
    ```),

    (type: "added", line-num: 11, content: ```py
        print("Hello, World!")
    ```),

    (type: "context", line-num: 12, content: ```py
        return 0
    ```),
  )
)
```

### Modified Line with Highlights

```typst
#diff(
  lines: (
    (
      type: "removed",
      line-num: 5,
      content: ```python
      result = calculate_total(a, b)
      ```,
      spans: (
        (start: 0, end: 6, fill: red.transparentize(20%)),
        (start: 9, end: 24, fill: red.transparentize(20%)),
      ),
      paired: true,
    ),
    (
      type: "added",
      line-num: 5,
      content: ```python
      output = compute_sum(x, y)
      ```,
      spans: (
        (start: 0, end: 6, fill: green.transparentize(30%)),
        (start: 9, end: 20, fill: green.transparentize(30%)),
      ),
      paired: true,
    ),
  )
)
```

### Large Diff with Skipped Lines

```typst
#diff(
  lines: (
    (type: "context", line-num: 1, content: ```py
    import sys
    ```),

    // Lines 2-98 skipped

    (type: "context", line-num: 99, content: ```py
    def process():
    ```),

    (type: "removed", line-num: 100, content: ```py
        old_logic()
    ```),

    (type: "added", line-num: 100, content: ```py
        new_logic()
    ```),

    (type: "context", line-num: 101, content: ```py
        return result
    ```),
  )
)
```

## Open Questions

1. **Line number display for paired lines**: Show both old/new numbers or just one?
2. **Hunk headers**: Should we add separators between non-contiguous sections?
3. **Collapse context**: Option to collapse large unchanged sections?
4. **Side-by-side mode**: Future enhancement?
5. **Word-level diff**: Use spans to highlight words instead of characters?

## Next Steps

1. Implement new `diff()` function in `state-solution.typ` or new file
2. Create comprehensive test cases
3. Document migration guide for existing users
4. Plan Rust integration architecture
