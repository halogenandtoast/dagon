# Error

In exceptional cases, it is useful to raise errors from software. Dagon provides
the `Error` class, which is special in that it defines `::raise`, which bubbles
up through the callstack unless caught and is finally raised in Ruby, generally
halting the program's execution.

```dagon
Error.raise("Something has gone wrong")
```

```dagon
DivideByZeroError(Error):
  @message: "Cannot divide by zero"

divide(numerator, denominator):
  if denominator = 0
    DivideByZeroError.raise(denominator)
```
