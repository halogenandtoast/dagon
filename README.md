# Dagon

[![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/halogenandtoast/dagon?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

## What is Dagon?

### Intent

The intent of **Dagon** is to eliminate confusion by providing only a single means of
doing something. This is in stark contrast to **Ruby**, the language **Dagon** is
written in. This design choice is intended to eliminate useless discussions
about indentation and spacing, double quotes versus single quotes and which
method to use. It does this by having strict spacing and indentation rules,
allowing only the use of double quotes, and only having only a single name for
each method (e.g. only supporting `length` instead of `count` and `length`).

### Spacing and Indentation

Dagon has similar indentation rules to **Python** except that the only acceptable form
of indentation is two spaces. More than two spaces or the use of tabs will result in a
syntax error. Operators like `+` and `-` require a space on both sides. `1 + 2` would be
valid while `1+2` would not be. Commas in arrays and hashes must be followed by a space.
`[1, 2, 3]` would be a valid array while `[1,2,3]` would not be.

### Method and Constant names

Due to the rules for using `-` method names can contain `-`. `_` are forbidden from methods names. The reason behind this decision is to allow the naming and usage of method names without having to hit the shift key. Constant names on the other hand do allow for `_` in order to allow you to continue holding the shift key down. Class names should be CamelCased and do not allow for `_` or `-`.

### No null

Using nulls tends to lead to poor coding. For this reason **Dagon** does not support any null type.

### OOP without Class functions

Classes only contain instance methods. There is no provided way for defining methods on a class instead of an instance.

## Examples

```
fibonacci-recursive(n): # hyphens instead of underscores.
  if n <= 1
    n
  else
    fibonacci-recursive(n - 1) + fibonacci-recursive(n - 2)
```

```
fibonacci-imperative(n):
  current: 0
  next: 1

  n.times ->
    temp: next
    next: next + current
    current: temp

  current
```

## Guide

### Assignment and Variables

The assignment operator is `: `. `=` is used for checking equality. Assigning to array uses `[]:`

```
x: 1
another-name: # value
a: [] # a = []
a[0]: 1 # a = [1]
```

### Methods

```
hello-world:
  puts("Hello world!")
```

### Classes

```
Greeter:
  init(name):
    @name: name
  salute:
    puts("Hello #{@name}!")
```

### Passing functions as arguments

You can pass anonymous functions around. They become arguments to the function you are calling

```
5.times ->
  puts("Hello World")

my-fun(number-of-times, block):
  number-of-times.times(block)
```

Additionally functions which have not been sent all their arguments can be passed as well

```
adder(x, y):
  x + y

subtracter(x, y):
  x - y

perform(fun, y):
  fun(y)

perform(adder(3), 4) # 7
perform(subtracter(4), 2) # 2
```

### Conditionals

#### if

`if` statements require an `else`. This is due to the lack of a null value.

```
if my-test() = true
  puts("Was true")
else # this else is required
  puts("Was false")
```

```
if my-test() = true
  puts("Was true")
elseif my-other-test() = true
  puts("The middle road")
else
  puts("Was false")
```

#### while

```
while my-test() = true
  # some code
```

### Exceptions

You can rescue from exceptions by wrapping them in begin/rescue blocks

```
begin ->
  # some code
rescue ->(e)
  # the code for the rescue
```

## Authors

This language was designed and implemented by [Caleb Thompson](/calebthompson) and [Goose Mongeau](/halogenandtoast).

## License

Dagon is released under the [MIT License](http://opensource.org/licenses/MIT)
