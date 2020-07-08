# Guide to the Rules DSL YAML

### Keywords
Everything you see below that is in upper case is a KEYWORD in the DSL.

### Title (Mandatory)
The title is to document the file for the benefit of others.

```
TITLE: Create-File-Share-On-Unspecified-Volume
```
Spaces are not allowed in the title, to help with searching / ordering /
filtering these YAML files by title.

### Declare Domain Artifacts Referenced (Mandatory)

This block declares the Domain Artifacts (DAs) your script is going to refer to.
```
DOMAIN-ARTIFACTS-REFERENCED:
  - host-array # storage controller to create the volume or share
  - host-aggregate # where to create the volume
  - volume # volume container to be created or reused
  - file-share # file share to be created
```
DAs are by definition types of things that **already** exist on the storage IaaC
and that are represented to SAFE by proxy objects in the database. The names you
declare here are the database table names. The purpose of this block is
three-fold. It tells the DSL up front that these names, when encountered should
be interpreted as DAs. It also declares the type for those names for type
checking. And it is necessary to fully qualify **IMPACT** statements that come
later in the DSL script. 

### Script Input Parameters (OPTIONAL)
Your DSL script likely requires some parameters passed in from the outside 
world when it runs. This block declares their names and types, and tells the DSL
that these names, when encountered refer to script input parameters.

```
MODULE-INPUTS:
    required-size: INT
    name-for-share: STRING
```
The words INT and STRING used here are two of the DSL's built-in *types*.
The next section says more about types.

### TYPES - Built-In
Types (and type-checking) are an important feature of the DSL. Their aim is
to allow type checking of scripts *before* any attempt is made to execute them.
This greatly simplifies later parts of the the interpreter, and helps to makes 
sure that data is being used consistently in the logic of the DSL script.

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

### User defined types

Many languages let you define your own types that represent a more complex
object with several properties. You then get the convenience of passing just one
of these beasts around to convey that aggregate information.  For example you
could have a type to represent a room that carried values for its area and wall
colour. Here's how you would express that type in the DSL.
```
room_t:
  area: FLOAT
  colour: STRING
```

You have to put your user defined type declarations near the top of your DSL
script. (At least before the first of them is referenced). Heres the declaration
for room_t we just saw in its proper context:

```
USER-DEFINED-TYPES
  room_t:
    area: FLOAT
    colour: STRING
  another_t:
  	fibble: STRING
	fabble: bool
	fobble: FLOAT
```

It is mandatory in the DSL that the names you give to your user-defined types
end with "_t". This helps to avoid accidental clashes with names you've used
for other things, like variables (below).

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
can be of arbitrary depth.

### Is that all there is for types?

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

### Variables
Your DSL script will likely require variables just like any other language to
hold values that can be set and then retrieved later. It is mandatory to declare
all your variables in the DSL somewhere before the RULES section. 

```
VARS:
  candidate-volume-id: STRING
  my-house: house_t
```
> Beware variables have global scope.

We say more about how you set the value of a variable and then consume it later
on.

### Let's Talk About Rules

Rules are the crux of a DSL script - it is the rules that are the meat of the
instructions. All the previous discussion about variables and types etc were
prerequisites.

Actually there is another pre-requisite (expressions), but lets wait until we
stumble over some an example to introduce them.


### First example fragment

Here's an extract of a valid DSL script. It's truncated to show all the
necessary preamble and just the start of the first rule.

```
TITLE: Create-File-Share-On-Unspecified-Volume

DOMAIN-ARTIFACTS-REFERENCED:
  - host-array # storage controller to create the volume or share
  - host-aggregate # where to create the volume
  - volume # volume container to be created or reused
  - file-share # file share to be created

USER-DEFINED-TYPES:

MODULE-INPUTS:
  required-size: FLOAT
  name-for-share: STRING

VARS:
  candidate-volumes: LIST DA volume
  candidate: DA volume
  last-volume-name: STRING
  vol-id: STRING
  vol-to-use: DA volume
  new-share: DA file-share

RULES:
  - RULE-NAME: Get suitable volumes
    ACTION: FIND-DB
    ACTION_PARAMS:
      - INPUTS:
          - size FLOAT
      - OUTPUT:
          - TYPE: DA volume
          - ASSIGN: candidate-volumes
	  - QUERY: tbd
```

The first thing to notice is that the rules block is a YAML list. The rules are
executed strictly in the order they appear in this list. Until that is, the 
script reaches a **termination** condition. Then the rules that follow will not
be run. This is a delibarate design choice for the DSL. It can be exploited by
the person that is designing the DSL script to engineer in triggers to stop and
quite delibarately not carry on with the other rules.

You'll see termination conditions in later sections.

### One Rule - One *ACTION*

Every rule has two mandatory blocks: RULE-NAME and ACTION. 
Each rule has exactly one (top level) ACTION. That choice of action then 
governs what subsequent blocks are mandatory for that rule. In our example the
action is FIND-DB, which means do a search on the database.

### Rule inputs and outputs

Rules take zero or more input parameters to parameterise what they do. You
specify these in the ACTION-PARAMS' INPUT block, using the same syntax as for
variables.

A Rule's output are a bit different. A rule always returns exactly one (typed)
thing (by definition). Hence there is no need to specify a name for it. However
you do have to specify the type, so that type-checking can be done. The most
usual thing you want to do with a rule output is to capture it by assigning it
to a variable. That is the case that the snippet illustrates. You say that your
want to do a variable assignment by using the ASSIGN keyword, and then cite the
variable's name.

The FIND-DB action requires a QUERY block to tell it what to go and look for.
We haven't settled on how we are going to express that.

### The next rules snippet

This shows how one rule follows another in the list. It means that once
"Get suitable volumes" has been executed, then "Check if a candidate volume is
found".

```
RULES:
  - RULE-NAME: Get suitable volumes
      ...
  - RULE-NAME: Check if a candidate volume is found
  	  ...
```

### The second rule

This one is much more complicated because the rule calls sub-rules. We said 
earlier that a rule must have exactly one top-level action. A sub-rule is a new
rule in its own right, and therefore **IT** too must have exactly one action.

Let's go through it piece by piece.

```
- RULE-NAME: "Check if a candidate volume is found"
    ACTION: CONDITION-IF
    ACTION_PARAMS:
      - CONDITION: "candidate-volumes.FOUND == true"
        ACTIONS_WHEN_TRUE:
          - RULE-NAME: "Sort suitable volume"
            ACTION: ITERATE-LIST
            ACTION_PARAMS:
              - INPUT:
                  - NAME: candidate-volumes
                    TYPE: LIST:volume
              - ITERATION_TYPE: LIST
              - ITERATION_VARIABLE_NAME: "suitable_volume"
              - INDEX_VARIABLE_NAME: "volume_index1"
              - ACTIONS:
                  - RULE-NAME: "Swap by most available space"
                    ACTION: CONDITION-IF
                    ACTION_PARAMS:
                      - CONDITION: "not (candidate) || candidate.size_available > suitable_volume.size_available"
                        ACTION_WHEN_TRUE:
                            - RULE-NAME: "assign or update candidate"
                              ACTION: UPDATE-VARIABLE
                              ACTION_PARAMS:
                                - VARIABLE: candidate
                                - VALUE:
                                  - size: "suitable_volume.size"
                                  - name: "suitable_volume.name"
                                  - size_available: "suitable_volume.size_available"
```

say that action if is like conv if statement in other lang
sneak prev going to show equiv of 

if
else if
else if
else if
else

or if you like a switch statement with no case drop through
