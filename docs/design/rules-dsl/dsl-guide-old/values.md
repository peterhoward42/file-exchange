# Values in the DSL

There are lots of places in a DSL script that require a value to be given.
Values for parameters, return values, inside calculations, returned from
searches etc.

Values are not just primitive types like floats and strings, they can also be
compound objects like ENTITYs or DAs.

Values are strongly typed. See the chapter on types.

There are also lots of places the values can come from, or be calculated or
specified.

Values are a sufficiently involved topic that you can think of it as a sub
domain of the DSL, and this chapter describes the VALUES subsystem.

The principle is that wherever the DSL expects to find a value, you must provide
it using the VAL keyword using the various constructs below. This principle aims
to create a single source of truth for what forms values can take and how these
alternatives are expressed in the DSL's YAML.

### Getting started example:

Here's the simplest form of VALUE you can have.

```
VAL:
  SOURCE: LITERAL
  TYPE: STRING
  L: "foo"
```

Here's how you could use a VALUE in context to set the value of a variable to the
literal string "foo".

```
VAR-ASSIGN:
  NAME: "my-var"
  RHS:
   VAL:
     SOURCE: LITERAL
     TYPE: FLOAT
     LIT: foo
```

### Using the contents of a VARIABLE as a VALUE

```
VAL:
 SOURCE: VARIABLE
 TYPE: STRING
 NAME: my-var
```

### Quick Look Ahead to the different SOURCEs available

- LITERAL
- VARIABLE
- MODULE-INPUT
- RULE-INPUT
- RULE-RETVAL
- BOOK-RETVAL
- CALC

### MODULE-INPUT

```
VAL:
 SOURCE: MODULE-INPUT
 TYPE: STRING
 NAME: size-required
```

### RULE-INPUT

```
VAL:
 SOURCE: RULE-INPUT
 TYPE: STRING
 NAME: size-required
```

### RULE-RETVAL (same for BOOK-RETVAL)

This is short for "one of a RULE's return values". It implies that
this VAL is being used inside a RULE block.

A rule can return multiple values, and each one is named.
This example selects the returned value named "disk-array" from those returned by the 
rule.

```
VAL:
 SOURCE: RULE-RETVAL
 TYPE: STRING
 NAME: disk-array
```

### CALC

Let's start by setting out the scope of a CALC and its anatomy.

A CALC is like a function in a conventional programming language. It has a name
to describe its behaviour, it takes zero, one, or more *operands*, and in our
DSL, a CALC returns exactly **one** value.

Here is how you use a CALC as a VALUE

```
VAL:
  SOURCE: CALC:
    ..calc body goes here..
  TYPE: STRING
```

And here's an example CALC that returns 3 times the value of a FLOAT 
variable called "my-float".

```
CALC:
  FUNCTION: MULT
  OPERANDS:
    - LHS:
	    VAL:
          SOURCE: VARIABLE
          TYPE: FLOAT
          NAME: my-var
    - RHS:
	    VAL:
          SOURCE: LITERAL
          TYPE: FLOAT
          LIT: 3.0
```

You say which type of calculation you want with the FUNCTION key, and there
is list of these built-in to the language. 

The operands you then have to specify depend on which FUNCTION you chose, and
the operands have names that imply what role they have in the function. In our
case `LHS` and `RHS` they are abbrevations for left-hand-side and right-hand-side. The
reference material for FUNCTIONS will tell you which OPERAND names are required.

Note that each operand is in of itself just another VALUE. It is a recursive
definition. It follows that the DSL can express more complex nested calculations.

### Bringing in STRING calcs, and variadic operands.

Despite the word CALC implying numeric calculations it really just means
function, and so works just as well for string operations.

This example takes three string literals, and concatenates them with a hyphen
between.

```
CALC:
  FUNCTION: JOIN
  OPERANDS:
    - SEPARATOR:
	    VAL:
          SOURCE: LITERAL
          TYPE: STRING
          LIT: "-"
    - VARIADIC:
	    VAL:
          SOURCE: LITERAL
          TYPE: STRING
          LIT: foo
    - VARIADIC:
	    VAL:
          SOURCE: LITERAL
          TYPE: STRING
          LIT: bar
    - VARIADIC:
	    VAL:
          SOURCE: LITERAL
          TYPE: STRING
          LIT: baz
```

### There are some wierd but highly relevant CALCs available

This example takes a string operand like "volume-42" and would
return "volume-43".

```
CALC:
  FUNCTION: INCREMENT-STRING
  OPERANDS:
    - THE-STRING:
	    VAL:
          SOURCE: LITERAL
          TYPE: STRING
          LIT: volume-42
```

### Some CALCS operate on LISTS

LISTS is one of the built-in types in the DSL. Note also that the declaration
of a LIST includes also the MEMBER-TYPE. If you want to get at one of the members
of a LIST, or maybe a sub-set of them - there are CALCS to help you do this.

I'm not going to write out full examples anymore - I'm sure you can infer what
they would look like now. Instead I'll use a sort of shorthand to get the message
across with less writing.

```
INDEX(my-list, 3)
FIRST(my-list)
LAST(my-list)
SLICE(my-list, from-index, to-index)
FIND-FIRST-MATCH(my-list, my-regex)
FIND-ALL-MATCHEs(my-list, my-regex)
SORT(my-list)
```

### Some CALCS operate on ENTITIES and DOMAIN-ARTIFACTS

These are types which have named fields. You use a CALC to get the value from
an individual field.

```GET-FIELD-VALUE(my-entity, field-name)```
