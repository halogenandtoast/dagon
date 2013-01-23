Truthiness
----------

Like Ruby, Dagon objects are truthy by default. Exceptions to this rule are
`false` and `void`, which are falsy.

Classes can also override `Object`'s `truthy`<a name='truthyref'></a>**[\*]**
method to return false and become falsy.


    FalsyClass:
      truthy:
        false

    falsy: FalsyClass()
    if falsy
      "You never get here."

<a name="truthyfn" href="#truthyref">\*</a> The name of this method has not been
finalized.
[\*]: #truthyfn
