#set page(height: auto, margin: 4em, width: 40em)

// ============================================================================
// NEW DIFF FUNCTION SIGNATURE - Test Suite
// ============================================================================
//
// This file contains comprehensive tests for the redesigned diff() function.
// The new signature supports:
// - Line-level diffs (context, removed, added)
// - Character-level inline highlighting for modifications
// - Flexible line number display
// - Stateless, pure function design
//

// ============================================================================
// HELPER FUNCTIONS (from state-solution.typ)
// ============================================================================

#let build-inline-char-level(styled-elem, spans) = {
  if spans.len() == 0 {
    return styled-elem
  }

  let style-func = styled-elem.func()
  let styles = styled-elem.styles
  let full-text = styled-elem.child.text

  let valid-spans = spans.filter(s => s.start < full-text.len() and s.end <= full-text.len())

  if valid-spans.len() == 0 {
    return styled-elem
  }

  let sorted-spans = valid-spans.sorted(key: s => s.start)

  let parts = ()
  let cursor = 0

  for span in sorted-spans {
    if span.start > cursor {
      let before-text = full-text.slice(cursor, span.start)
      parts.push(style-func([#before-text], styles))
    }

    let highlight-text = full-text.slice(span.start, span.end)
    parts.push(box(
      fill: span.fill,
      inset: (x: 0.1em, y: 0.0em),
      outset: (x: 0.0em, y: 0.15em),
      style-func([#highlight-text], styles)
    ))

    cursor = span.end
  }

  if cursor < full-text.len() {
    let after-text = full-text.slice(cursor)
    parts.push(style-func([#after-text], styles))
  }

  parts.join()
}

#let build-inline-multitoken(line-body, line-text, spans) = {
  let children = line-body.children
  let parts = ()
  let char-pos = 0

  for child in children {
    let child-text = if "child" in child.fields() {
      child.child.text
    } else if type(child) == content {
      child.text
    } else {
      str(child)
    }
    let child-start = char-pos
    let child-end = char-pos + child-text.len()

    let child-spans = ()
    for span in spans {
      let overlap-start = calc.max(span.start, child-start)
      let overlap-end = calc.min(span.end, child-end)

      if overlap-start < overlap-end {
        child-spans.push((
          start: overlap-start - child-start,
          end: overlap-end - child-start,
          fill: span.fill
        ))
      }
    }

    if child-spans.len() > 0 and "styles" in child.fields() {
      parts.push(build-inline-char-level(child, child-spans))
    } else {
      parts.push(child)
    }

    char-pos = child-end
  }

  parts.join()
}

#let build-inline-smart(line-body, line-text, spans) = {
  if spans.len() == 0 {
    return line-body
  }

  if "children" in line-body.fields() {
    return build-inline-multitoken(line-body, line-text, spans)
  } else {
    return build-inline-char-level(line-body, spans)
  }
}

// ============================================================================
// NEW DIFF FUNCTION
// ============================================================================

#let diff-new(
  lines: (),

  // Styling options
  removed-bg: red.transparentize(80%),
  added-bg: green.transparentize(80%),
  context-bg: none,

  removed-inline: red.transparentize(20%),
  added-inline: green.transparentize(30%),

  // Display options
  show-line-numbers: true,
  font: "DejaVu Sans Mono",
) = {
  // State to collect line content from raw blocks
  let line-state = state("diff-line-collector", ())

  let rows = ()

  for line-record in lines {
    let line-type = line-record.type
    let line-num = line-record.line-num
    let content-block = line-record.content
    let spans = line-record.at("spans", default: ())

    // Determine background color
    let bg-color = if line-type == "removed" {
      removed-bg
    } else if line-type == "added" {
      added-bg
    } else {
      context-bg
    }

    // Reset state for this line
    line-state.update(_ => ())

    // Collect the line using show rule
    place([
      #show raw.line: it => {
        line-state.update(s => s + (it,))
      }
      #content-block
    ])

    // Build the rendered content
    let rendered-content = context {
      let collected-lines = line-state.get()

      if collected-lines.len() == 0 {
        // No line collected, return raw content
        content-block
      } else {
        // Get first line (should only be one)
        let line = collected-lines.at(0)

        // Apply character-level highlights if present
        if spans.len() > 0 {
          text(font: font, build-inline-smart(line.body, line.text, spans))
        } else {
          text(font: font, line.body)
        }
      }
    }

    // Add line number prefix (optional)
    let line-num-cell = if show-line-numbers {
      box(
        inset: (left: 0.2em, right: 0.8em, top: 0.20em, bottom: 0.20em),
        text(font: font, str(line-num))
      )
    } else {
      []
    }

    // Add line type indicator (optional visual indicator)
    let indicator = if line-type == "removed" {
      text(fill: red, "−")
    } else if line-type == "added" {
      text(fill: green, "+")
    } else {
      [ ]
    }

    // Build row
    rows.push((
      line-num-cell,
      indicator,
      box(
        fill: bg-color,
        inset: (left: 0.5em, right: 0.1em, top: 0.25em, bottom: 0.25em),
        width: 1fr,
        rendered-content
      )
    ))
  }

  // Return grid
  grid(
    columns: (auto, auto, 1fr),
    row-gutter: 0.0em,
    ..rows.flatten()
  )
}

// ============================================================================
// TEST 1: Simple Context Lines
// ============================================================================

= Test 1: Context Lines Only

#diff-new(
  lines: (
    (
      type: "context",
      line-num: 1,
      content: ```python
      def main():
      ```
    ),
    (
      type: "context",
      line-num: 2,
      content: ```python
          return 0
      ```
    ),
  )
)

// ============================================================================
// TEST 2: Simple Addition and Deletion
// ============================================================================

= Test 2: Simple Addition and Deletion

#diff-new(
  lines: (
    (
      type: "context",
      line-num: 10,
      content: ```python
      def calculate():
      ```
    ),
    (
      type: "removed",
      line-num: 11,
      content: ```python
          result = old_method()
      ```
    ),
    (
      type: "added",
      line-num: 11,
      content: ```python
          result = new_method()
      ```
    ),
    (
      type: "context",
      line-num: 12,
      content: ```python
          return result
      ```
    ),
  )
)

// ============================================================================
// TEST 3: Modified Line with Character-Level Highlights
// ============================================================================

= Test 3: Modified Line with Character Highlights

#diff-new(
  lines: (
    (
      type: "removed",
      line-num: 5,
      content: ```python
      result = calculate_total(a, b)
      ```
      ,
      spans: (
        (start: 0, end: 6, fill: red.transparentize(20%)),    // "result"
        (start: 9, end: 24, fill: red.transparentize(20%)),   // "calculate_total"
      ),
    ),
    (
      type: "added",
      line-num: 5,
      content: ```python
      output = compute_sum(x, y)
      ```
      ,
      spans: (
        (start: 0, end: 6, fill: green.transparentize(30%)),  // "output"
        (start: 9, end: 20, fill: green.transparentize(30%)), // "compute_sum"
      ),
    ),
  )
)

// ============================================================================
// TEST 4: Multiple Changes in One Hunk
// ============================================================================

= Test 4: Multiple Changes in One Hunk

#diff-new(
  lines: (
    (
      type: "context",
      line-num: 20,
      content: ```python
      class Calculator:
      ```
    ),
    (
      type: "removed",
      line-num: 21,
      content: ```python
          def add(self, a, b):
      ```
      ,
      spans: (
        (start: 8, end: 11, fill: red.transparentize(20%)),  // "add"
      ),
    ),
    (
      type: "added",
      line-num: 21,
      content: ```python
          def sum(self, a, b):
      ```
      ,
      spans: (
        (start: 8, end: 11, fill: green.transparentize(30%)),  // "sum"
      ),
    ),
    (
      type: "removed",
      line-num: 22,
      content: ```python
              return a + b
      ```
    ),
    (
      type: "added",
      line-num: 22,
      content: ```python
              return a + b  # Fixed
      ```
      ,
      spans: (
        (start: 20, end: 28, fill: green.transparentize(30%)),  // "# Fixed"
      ),
    ),
    (
      type: "context",
      line-num: 23,
      content: ```python

      ```
    ),
  )
)

// ============================================================================
// TEST 5: Non-Contiguous Line Numbers (Skipped Lines)
// ============================================================================

= Test 5: Skipped Lines (Non-Contiguous Line Numbers)

#diff-new(
  lines: (
    (
      type: "context",
      line-num: 1,
      content: ```python
      import sys
      ```
    ),
    // ... lines 2-98 skipped ...
    (
      type: "context",
      line-num: 99,
      content: ```python
      def process():
      ```
    ),
    (
      type: "removed",
      line-num: 100,
      content: ```python
          old_logic()
      ```
    ),
    (
      type: "added",
      line-num: 100,
      content: ```python
          new_logic()
      ```
    ),
    (
      type: "context",
      line-num: 101,
      content: ```python
          return
      ```
    ),
  )
)

// ============================================================================
// TEST 6: Complex Multi-Token Highlights
// ============================================================================

= Test 6: Complex Multi-Token Line with Multiple Highlights

#diff-new(
  lines: (
    (
      type: "removed",
      line-num: 15,
      content: ```python
      result = calculate_total(old_var, legacy_func())
      ```
      ,
      spans: (
        (start: 0, end: 6, fill: red.transparentize(20%)),    // "result"
        (start: 9, end: 24, fill: red.transparentize(20%)),   // "calculate_total"
        (start: 25, end: 32, fill: red.transparentize(20%)),  // "old_var"
        (start: 34, end: 45, fill: red.transparentize(20%)),  // "legacy_func"
      ),
    ),
    (
      type: "added",
      line-num: 15,
      content: ```python
      output = compute_sum(new_var, modern_func())
      ```
      ,
      spans: (
        (start: 0, end: 6, fill: green.transparentize(30%)),   // "output"
        (start: 9, end: 20, fill: green.transparentize(30%)),  // "compute_sum"
        (start: 21, end: 28, fill: green.transparentize(30%)), // "new_var"
        (start: 30, end: 41, fill: green.transparentize(30%)), // "modern_func"
      ),
    ),
  )
)

// ============================================================================
// TEST 7: String Literal Modifications
// ============================================================================

= Test 7: String Literal with Character Highlights

#diff-new(
  lines: (
    (
      type: "context",
      line-num: 50,
      content: ```python
      def greet(name):
      ```
    ),
    (
      type: "removed",
      line-num: 51,
      content: ```python
          return "Hello, World!"
      ```
      ,
      spans: (
        (start: 15, end: 20, fill: red.transparentize(20%)),  // "World"
      ),
    ),
    (
      type: "added",
      line-num: 51,
      content: ```python
          return f"Hello, {name}!"
      ```
      ,
      spans: (
        (start: 14, end: 16, fill: green.transparentize(30%)), // "f\""
        (start: 16, end: 22, fill: green.transparentize(30%)), // "{name}"
      ),
    ),
  )
)

// ============================================================================
// TEST 8: Pure Additions (No Removals)
// ============================================================================

= Test 8: Pure Additions

#diff-new(
  lines: (
    (
      type: "context",
      line-num: 30,
      content: ```python
      def foo():
      ```
    ),
    (
      type: "added",
      line-num: 31,
      content: ```python
          # New comment
      ```
    ),
    (
      type: "added",
      line-num: 32,
      content: ```python
          new_feature()
      ```
    ),
    (
      type: "context",
      line-num: 33,
      content: ```python
          pass
      ```
    ),
  )
)

// ============================================================================
// TEST 9: Pure Deletions (No Additions)
// ============================================================================

= Test 9: Pure Deletions

#diff-new(
  lines: (
    (
      type: "context",
      line-num: 60,
      content: ```python
      def bar():
      ```
    ),
    (
      type: "removed",
      line-num: 61,
      content: ```python
          # Deprecated comment
      ```
    ),
    (
      type: "removed",
      line-num: 62,
      content: ```python
          deprecated_func()
      ```
    ),
    (
      type: "context",
      line-num: 63,
      content: ```python
          pass
      ```
    ),
  )
)

// ============================================================================
// TEST 10: Edge Case - Empty Line Modifications
// ============================================================================

= Test 10: Empty Lines

#diff-new(
  lines: (
    (
      type: "context",
      line-num: 70,
      content: ```python
      def test():
      ```
    ),
    (
      type: "removed",
      line-num: 71,
      content: ```python

      ```
    ),
    (
      type: "context",
      line-num: 72,
      content: ```python
          pass
      ```
    ),
  )
)
