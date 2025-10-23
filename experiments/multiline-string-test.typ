#set page(height: auto, margin: 2em, width: 30em)

// Test: Multiline string with inline highlight
// Challenge: Syntax highlighting should recognize this as a string
// even though we skip the opening """

#let test-state = state("test-lines", ())

[
  #show raw.line: it => {
    test-state.update(s => s + (it,))
  }
  ```py
  """
  This is a multiline test string
  with multiple lines here
  """
  ```
]

#context {
  let lines = test-state.get()

  // Skip first line (line 0), show lines 1-3
  let visible-lines = lines.slice(1, 4)

  [= Without inline highlight]

  for (idx, line) in visible-lines.enumerate() {
    [Line #(idx + 1): ]
    text(font: "DejaVu Sans Mono", line.body)
    linebreak()
  }

  [= With inline highlight on "test"]

  // Now try to highlight "test" on line 2 (index 1 in visible-lines)
  // "test" is at position 19-23 in "This is a multiline test string"
  for (idx, line) in visible-lines.enumerate() {
    [Line #(idx + 1): ]

    if idx == 0 and type(line.body) != str {
      // This is line 2 of original, highlight "test"
      let body-type = type(line.body)

      if body-type == content and "children" in line.body.fields() {
        let children = line.body.children
        let parts = ()
        let char-pos = 0

        for child in children {
          let child-content = child.child
          let child-text = if type(child-content) == content {
            child-content.text
          } else {
            str(child-content)
          }
          let child-len = child-text.len()
          let child-start = char-pos
          let child-end = char-pos + child-len

          // Highlight if this child is in range 19-23
          if child-start >= 19 and child-end <= 23 {
            parts.push(box(
              fill: yellow.lighten(50%),
              radius: 0.2em,
              inset: (x: 0.1em),
              child
            ))
          } else {
            parts.push(child)
          }

          char-pos = child-end
        }

        text(font: "DejaVu Sans Mono", parts.join())
      } else {
        text(font: "DejaVu Sans Mono", line.body)
      }
    } else {
      text(font: "DejaVu Sans Mono", line.body)
    }

    linebreak()
  }

  [= Debug: Full line structure]
  repr(lines.at(1))
}
