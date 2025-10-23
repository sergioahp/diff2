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
      rows.push((
        box(
          fill: red.lighten(80%),
          inset: (x: 0.2em, y: 0.1em),
          radius: 0.2em,
          text(font: "DejaVu Sans Mono", size: 10pt, [- #(idx + 1)])
        ),
        line.body,
      ))
    }

    // Add after lines (added lines)
    for (idx, line) in after-lines.enumerate() {
      rows.push((
        box(
          fill: green.lighten(80%),
          inset: (x: 0.2em, y: 0.1em),
          radius: 0.2em,
          text(font: "DejaVu Sans Mono", size: 10pt, [+ #(idx + 1)])
        ),
        line.body,
      ))
    }

    // Return the grid
    grid(
      columns: (auto, 1fr),
      column-gutter: 0.6em,
      row-gutter: 0.15em,
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
