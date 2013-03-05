TypeError
---------

Assigning to a variable implicitly sets the type of that variable. Subsequent
assignments to that variable cannot be objects which are not of the original
type.

    x: 1 # x is of variable type Integer
    x: 2 # allowed, since 2 and 1 are both Integers
    x: "2" # TypeError

Explicitly typing a variable on declaration sets the variable type. Here, `y`
cannot be assigned any value that is not a string.

    String y: "bananas"
    y: 37  # TypeError

Explicit typing overrides assignment, meaning that the following is invalid.

    Integer count: "four"

Only the initial assignment to a variable sets the variable type.

    Foo:
      # stuff

    Bar(Foo):
      # things

    Qux(Foo):
      # yet more stuff

    baz: Foo() # type of baz is Foo
    baz: Bar() # allowed, because Bar is a Foo.
    baz: Qux() # also allowed. The variable type of baz does not change after
               # the assignment of a Bar.

`void` does not affect the type of a variable.

    trait: void # trait is untyped
    trait: 5 # trait is of type Integer

    category: "animals"
    category: void # Allowed, but type of category remains string
    category: 5 # TypeError

Boolean values are a special case with regard to variable types. Either true or
false can be stored in a variable intially assigned a boolean value, even though
true is typed `Dagon::Core::True` and false is of type `Dagon::Core::False`

    awesome: true
    awesome: false
