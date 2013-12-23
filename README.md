# The Esoteric Order of Dagon

This is a language designed and implemented by [Caleb Thompson](/calebthompson) and [Goose Mongeau](/halogenandtoast).

You can call it Dagon for short.


## Dagon As She is Wrote

```
fibonacci-recursive(n): # fuckin hyphens instead of underscores.
  if n <= 1, return n  #leading conditionals. comma rather than semicolon to separate statements
  self(n - 1) + self(n - 2)
```

```
fibonacci-imperative(n):
  current: 0
  next: 1

  n.times
    temp: next
    next +: current
    current: temp

  current
```

### Hello

```
puts("Hello World")
```

Outputs strings "Hello " "World\n" (same result as above):

```
print("Hello ")
print("World\n")
```

## Syntax

### Assignment

```
x: 1
Integer x: 1 # strongly typed
x: "string" # raises error or warning: Invalid type (assigning String to Integer)
```

### Classes

/^(?:[A-Z][a-z]+)+:$/

```
MyClass:
  # here lies the definition
Plant:
  # defintion
Tree(Plant):
  # tree stuff

```

### Methods

/^(?:[a-z]+-?)+[^-][\(\)]?:\n  $/

```
do-stuff:
  # definition
stuff:
  # definition
print():
  # definition
```

### Variables

/^(?:[a-z]+-?)+[^-]: $/

```
name: # value
another-name: # value
```

## License

Dagon is released under the [MIT License](http://opensource.org/licenses/MIT)
