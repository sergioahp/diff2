# Development Guide for Claude

## Project Overview

This is a Typst-based diff viewer with character-level inline highlighting that preserves syntax highlighting colors.

## Main Files

- **`state-solution.typ`**: Main implementation with complete diff functionality
  - Character-level inline highlighting
  - Line range selection
  - Multi-token and single-token support
  - Three comprehensive test cases

- **`experiments/`**: Research and discovery directory
  - `explore-styles-field.typ`: **BREAKTHROUGH** - Shows the working solution
  - `LEARNINGS.md`: Complete documentation of the discovery process
  - Other `.typ` files: Failed approaches and explorations

## Core Discovery

The key insight from experiments: styled elements can be reconstructed while preserving syntax colors:

```typst
styled-elem.func()([#text-slice], styled-elem.styles)
```

This allows:
- Slicing text at any character position
- Maintaining original syntax highlighting colors
- Building inline highlights that preserve styling

## Why State and Context?

**State**: Typst's `show raw.line` rule processes lines individually during document layout. We need to collect all lines first before building the grid. State allows us to accumulate `raw.line` elements across multiple invocations of the show rule.

**Context**: State values are only accessible within a `context` block. The grid must be built inside `context` because:
1. We need to call `state.get()` to retrieve collected lines
2. Grid construction depends on runtime values (line count, content)
3. Typst requires context-aware code to be wrapped in `context {}`

Without this pattern, we'd only have access to individual lines, not the complete set needed for grid construction.

## Testing Procedure

### Quick Test

```bash
typst compile state-solution.typ state-solution.png --format png
```

Then view the PNG to verify:
- Test 1: Multi-token highlights
- Test 2: Single-token with line ranges
- Test 3: Multiple highlights per line

### Detailed Inspection

For specific features or debugging:

1. **Create a test file** in the root directory:
   ```typst
   #set page(height: auto, margin: 2em, width: 35em)

   #let test-state = state("test-lines", ())

   [
     #show raw.line: it => {
       test-state.update(s => s + (it,))
     }
     ```py
     # Your code here
     ```
   ]

   #context {
     let lines = test-state.get()
     // Introspect and debug here
     repr(lines.at(0))
   }
   ```

2. **Compile and extract text**:
   ```bash
   typst compile test.typ && pdftotext test.pdf -
   ```

3. **Visual inspection**:
   ```bash
   typst compile test.typ test.png --format png
   ```

### Character Position Finding

To find exact character positions for highlights:

```typst
#context {
  let line = lines.at(0)
  for (i, c) in line.text.clusters().enumerate() {
    [#i: "#c" ]
  }
}
```

Compile with `pdftotext` to see character indices.

## Common Tasks

### Adding a New Test Case

1. Add to `state-solution.typ` after existing tests
2. Use the `#diff()` function with parameters:
   - `before`: Code block (before version)
   - `after`: Code block (after version)
   - `before-inline`: Array of `(line: N, start: X, end: Y, fill: color)`
   - `after-inline`: Array of `(line: N, start: X, end: Y, fill: color)`
   - `before-range`: Optional `(start, end)` for line selection
   - `after-range`: Optional `(start, end)` for line selection

3. Compile and verify visually

### Debugging Syntax Highlighting Loss

If highlights lose colors:

1. Check if using `.text` instead of `.body`
2. Verify `styled-elem.func()` and `.styles` are being used
3. Look at `experiments/explore-styles-field.typ` for reference
4. Check `LEARNINGS.md` for common pitfalls

### Debugging State Issues

If tests show wrong content or accumulate:

- Verify `before-state.update(_ => ())` is called at start of `diff()`
- Check if using unique state names
- Look for state leakage between `#diff()` calls

## Line Numbering

- Line numbers are **1-based** (line 1 is the first line)
- Character positions are **0-based** (char 0 is the first character)
- Line ranges are **inclusive** `(start, end)` includes both start and end lines

## Tools Used

- `typst compile file.typ`: Compile to PDF
- `typst compile file.typ output.png --format png`: Compile to PNG
- `pdftotext file.pdf -`: Extract text from PDF for debugging
- `repr()`: Typst function to introspect data structures

## Verification Checklist

Before committing changes:

- [ ] All three test cases compile without errors
- [ ] Syntax highlighting preserved in visual output
- [ ] Line numbers match expected values
- [ ] Inline highlights appear at correct positions
- [ ] No state leakage between tests
- [ ] Character positions are accurate

## File Structure Expectations

```
diff2/
├── state-solution.typ          # Main implementation + tests
├── experiments/
│   ├── LEARNINGS.md           # Key documentation
│   ├── explore-styles-field.typ  # Working solution reference
│   └── *.typ                  # Other experiments
├── CLAUDE.md                  # This file
└── *.png, *.pdf              # Generated outputs (git ignored)
```

## Known Limitations

1. **Box radius removed**: Multi-token highlights with radius create visual gaps
2. **Non-overlapping spans**: Assumes highlight spans don't overlap
3. **State names**: Uses fixed state names "before-lines" and "after-lines"

## Future Improvements

- Smart radius (only on edges of continuous runs)
- Support for overlapping highlights
- Configurable colors
- Side-by-side diff mode
- Unique state IDs per diff instance
