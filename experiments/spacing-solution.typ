#set page(height: auto, margin: 2em, width: 35em)

= Test 1: Does hide[] take space between paragraphs?

Text before hide block.
#hide[
  ```py
  def example():
      pass
  ```
]
Text after hide block.

#pagebreak()

= Test 2: What if we use place()?

Text before place.
#place(hide[
  ```py
  def example():
      pass
  ```
])
Text after place.

#pagebreak()

= Test 3: Using metadata (doesn't render at all)

#let test-state = state("test1", ())

Text before.

// Try using metadata to store the code without rendering
#metadata(
  ```py
  def example():
      pass
  ```
)

Text after metadata.

#pagebreak()

= Test 4: Show rule returns none explicitly

#let test-state2 = state("test2", ())

Text before.

{
  show raw.line: it => {
    test-state2.update(s => s + (it,))
    none
  }

  ```py
  def example():
      pass
  ```
}

Text after.

#context {
  [Collected #test-state2.get().len() lines]
}

#pagebreak()

= Test 5: Show rule returns empty array

#let test-state3 = state("test3", ())

Text before.

{
  show raw.line: it => {
    test-state3.update(s => s + (it,))
    []
  }

  ```py
  def example():
      pass
  ```
}

Text after.

#context {
  [Collected #test-state3.get().len() lines]
}
