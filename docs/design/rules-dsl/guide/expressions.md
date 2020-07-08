# Values and Expressions

There are lots of places in *Rules* where you need to specify a value. Like 42,
or "foo", or FALSE. 

Very often you'll want to provide the value by giving the name of a variable
instead of a *literal* like 42. It doesn't have to be a variable with a
built-in type. It can also be a LIST or MAP type or one of your user-defined
types.

The other way you can provide a value is by specifying an *expression*. Like
```40 + 2```.  In the simplest case, an expression is just a calculation. But
it can also include string manipulations.  This chapter is all about
*expression*s.

## Getting the Flavour

Here are some examples to give you an informal idea of a few different types
of expression.

```
len(candidate-volumes) != 0

candidate.HasNotBeenSet() || candidate.size_available > suitable_volume.size_available

last-volume-name[0:3] + last-volume-name.LastNCharacters(2)
```

## What is the first example showing us?

```
len(candidate-volumes) != 0
```

This expression could be spoken as:

> Does the LIST I constructed earlier, held in my *candidate-volumes* 
> variable have at least one volume in it?

```len``` is a function built in into the expression mini langauge that counts
how many elements there are in a list. There are several other built in
functions like this. 

The ```!=``` fragment has its usual meaning of "not equal", and is just one of
several *relational* operators built into the experssion language.

## What is the second example telling us?

```
candidate.HasNotBeenSet() || candidate.size_available < required-size
```

Again recall the relevant variable declaration:

```
candidate: DA volume
```

So the type of this variable is a Domain Artifact (DA) volume. In other words
this variable is intended to refer to a real Volume on the estate. The real
(full) script does a search for a suitable volume to create a file share on. If
that part succeeds, the variable will indeed refer to a real volume on the
estate.  But maybe it didn't find any. In this case the variable won't ever
have been assigned a value. So the first part of the expression is checking to
see if the variable has been set.

The ```||``` has the usual meaning of "or", and is just one of the *logical*
operators built-in to the expression language.

So thus far, this expression is saying:

> If no candidate volume was found, or ...

Then it goes on to see if the space available on the volume is sufficient, i.e.
whether it is greater than the required-size. You may recall that
*required-size* was declared to be the name of a DSL script input parameter.

``` 
MODULE-INPUTS:
  required-size: FLOAT
  name-for-share: STRING
```

Note the use of another of the *relational* operators ```>```, again taking its
usual meaning of "greater than".

This example includes accessing the *size-available* field on the
volume. *volume* is a DA, and DA's behave pretty much the same as user-defined
types and thus have fields like this. The syntax for accessing fields is to use
a dot like this ```my-thing.my-field```.

So to wrap up that example, you would speak it as:

> If we didn't find a suitable candidate volume, or even if we did, if it's not
> big enough...

This expression evaluates to a Boolean value (True or False) and is likely
intended to be used as the *condition* in a conditional action (see Actions).

## What is the third example telling us?

```
last-volume-name[0:3] + last-volume-name.LastNCharacters(2)
```

The first fragment is extracting a substring from the STRING variable
last-volume-name. Specifically, the first 3 characters. This is using the slice
notation you find in many languages, where the first number is the (zero-based)
index into the string you want the substring to start at. The second number is
the index into the string that marks where the substring should end
(exclusive).

The second fragment ```last-volume-name.LastNCharacters(2)``` is again
extracting a sub string, but it wants to extract the last 2 characters, and you
cannot express that wish with this slice notation. So instead it uses a
built-in method that is available on STRINGs to do so.

And finally the two extracted sub strings are "added" together using the
```+``` operator. When the operands are STRINGs, this plus operator is taken to
mean concatenation. This expression of course evaluates to a STRING.


## Reveal! - This is a 3rd Party Expression Language

What is described above is not something the SAFE project has invented.
Instead it's been describing a THIRD PARTY Expression Language. Specifically
the language implemented by the *antonmedv/expr* Go package. You can read the
specification for that language [here](https://github.com/antonmedv/expr/blob/master/docs/Language-Definition.md).

Incorporating a 3rd party expression evaluation package not only saves a large
amount of design and coding for us, but it also provides a richness, quality
and maturity that we could not attain.

> Nb. We also considered an alternative library:
> [cel-go](https://github.com/google/cel-go) from Google. But we were
> disappointed with how difficult it was to learn, and with its lack of
> adequate documentation.

## But the SAFE DSL and the antonmedv/expr package are interwoven

No 3rd Party expression package can give us the features we need on its own.

For example, *antonmedv/expr* gives us slices ```last-volume-name[0:3]```. But
it **did not** provide the *LastNCharacters* method:
```last-volume-name.LastNCharacters(2)```. The library is designed to let us
add custom methods like *LastNCharacters*  alongside it's own built in 
methods. We don't know yet what the full suite of our custom methods will be. 
But when we do they will be documented here.

Similarly *antonmedv/expr* **does** provide the dot notation for accessing
fields ```candidate.size_available```. But of course it can't work unless we,
somehow behind the scenes, tell it in advance about all the user defined types
you have defined in your YAML - and thus what fields are available in each 
variable. (This is development/research work in progress for us).
