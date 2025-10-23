// for some reason width auto or too small breaks the background color of code
#set page(height:auto, margin:4em, width: 40em)
#let diff(before, after) = {
  let before-state = state("before-lines", ())
  let after-state = state("after-lines", ())

  // Collect before lines
  [
    #show raw.line: it => {
      before-state.update(s => s + (it,))
    }
    #before
  ]

  // Collect after lines
  [
    #show raw.line: it => {
      after-state.update(s => s + (it,))
    }
    #after
  ]

  // Build grid inside context block
  context {
    let before-lines = before-state.get()
    let after-lines = after-state.get()

    let rows = ()

    // Add before lines (removed lines)
    for (idx, line) in before-lines.enumerate() {
    let bg-color = red.transparentize(80%)
      rows.push((
        box(
          // fill: bg-color,
          inset: (
            left: 0.2em,
            right: 0.8em,
            top: 0.20em,
            bottom: 0.20em
          ),
          text(font: "DejaVu Sans Mono", [#(idx + 1)])
        ),
        box(
          fill: bg-color,
          inset: (
            left: 0.1em,
            right: 0.1em,
            top: 0.25em,
            bottom: 0.25em
          ),
          text(font: "DejaVu Sans Mono", line.body)
      )))
    }

    // Add after lines (added lines)
    for (idx, line) in after-lines.enumerate() {
      let bg-color = green.transparentize(80%)
      rows.push((
        box(
          // fill: bg-color,
          inset: (
            left: 0.2em,
            right: 0.8em,
            top: 0.20em,
            bottom: 0.20em
          ),
          text(font: "DejaVu Sans Mono", [#(idx + 1)])
        ),
        box(
          fill: bg-color,
          inset: (
            left: 0.1em,
            right: 0.1em,
            top: 0.25em,
            bottom: 0.25em
          ),
          text(font: "DejaVu Sans Mono", line.body)
      )))
    }

    // Return the grid
    grid(
      columns: (auto, 1fr),
      row-gutter: 0.0em,
      ..rows.flatten(),
    )
  }
}


= Diff Output

#diff(
```py
def cool_function():
  """
  Returns: A number
  """
  return 2
print(f"{k+5=}")
```,
```py
print(f"{5+6=}")
print(f"{9+5=}")
print(f"{10+5=}")
```
)
