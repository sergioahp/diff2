#set text(12pt)

#show raw.line: line => {
  if line.number == 1 {
    {
      set text(fill: blue)
      line
    }
  } else {
    line
  }
}

= Blue Headlines for Code Blocks

Any block of raw code will now render its first line in blue, thanks to the `raw.line` show rule above.

```python
def encode(x):
    return x @ W + b
```

```rust
fn main() {
    println!("Hello, world!");
}
```
