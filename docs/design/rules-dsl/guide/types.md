# DSL Guide - TYPES

Types are a central and important part of the DSL.

They allow type checking of scripts *before* any attempt is made to execute them.
This:
- provides ways to simplify the design and coding of the interpreter
- helps to makes sure that data is being used consistently in the logic of the 
  DSL script.
- ultimately cuts out a fair proportion of errors at a very early stage

There are a set of simple types built-in to the DSL: INT, FLOAT, STRING, 
and BOOL.

There are also two built-in containers LIST and MAP. A LIST is just a sequence
of values, whereas a MAP is a set of key-value pairs - sometimes called a
*hashmap* or *dictionary* in other languages.

Here's how you you declare *foo* to be a list of INTs.

```
foo: LIST INT
```

Here's how you declare *bar* to be a MAP that holds FLOAT values.
```
bar: MAP FLOAT
```
Note you cannot specify the type for a MAP's keys. They are always STRINGs.

## User defined types

Many languages let you define your own types that represent a more complex
object with several properties. You then get the convenience of passing just one
of these beasts around to convey that aggregate information.  For example you
could have a type to represent a room (in a house) that carried values for its
area and wall colour. Here's how you would express that type in the DSL.
```
room_t:
  area: FLOAT
  colour: STRING
```

You have to put your user defined type declarations near the top of your DSL
script. (At least before the first of them is referenced). Here's the declaration
for room_t we just saw in its proper context:

```
USER-DEFINED-TYPES
  room_t:
    area: FLOAT
    colour: STRING
  another_t:
    fibble: STRING
	fabble: BOOL
	fobble: FLOAT
```

It is mandatory in the DSL that the names you give to your user-defined types
end with "_t". This avoids the problem of wanting to use the same name for
a type and for a variable.

What if we wanted a room to also include a list of the furniture items in it?
```
room_t:
  area: FLOAT
  colour: STRING
  furniture: LIST STRING
```

What if we wanted to have a user defined type that represented a house, that
included a list of the rooms in it? In other words to use the *room_t* user
defined type as part of the definition of a new *house_t* type?
```
house_t:
  rooms: LIST room_t
```

Similary if instead of including a LIST of rooms, maybe we would prefer to
use a MAP of rooms - where the key is the room's name:
```
house_t:
	rooms: MAP room_t # keyed on room name
```
In this case it's recommended to use a comment to tell a human reader
what the keys mean. (We know they are strings, because a MAP can only have
string keys).

The nesting of type definitions need not be one-deep like in this example. It
can be of arbitrary depth. In other words you can create  more complex higher
level types by *composing* lower level types.

## Is that all there is for types?

No. Here are the origins for types that the DSL uses and brings together:
-  built-in simple types - like INT etc.
-  the two built-in container types LIST and MAP
-  your user defined types like *room_t*
-  Domain Artefacts (DAs).

We mentioned DAs at the beginning. These are types that are somehow magically
known to the DSL ahead of time. We are not going to cover that topic here - but
suffice it to say that they behave pretty much the same as user defined types.

You declare something to have a DA type like this

```
foo: DA volume
```
