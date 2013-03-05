# Inheritance

Classes can inherit from a single superclass. Classes which do not specify a
superclass implicitly inherit from `Object`.

```
Noun:
  to-s:
    "noun"
Noun.superclass
# => Object
```
```
Dog(Animal):
  emote:
    puts("Bark!")
Dog.superclass
# => Animal
Dog.ancestors
# => [Animal, Object]
```

Classes inherit and have access to both public and private methods and variables
of their ancestors.

`::ancestors` indicates the order in which methods and variables will be looked
up and resolved.

```
Animal:
  -breath:
    # implementation
Can(Animal)
  -purr:
    breath()
```

Behavior can be overridden by re-defining methods.

```
Wolf:
  interact-with-human(human):
    eat(human)
Dog(Wolf)
  interact-with-human(human):
    slobber-on(human)
```
