# Guide to the Rules DSL YAML - INTRODUCTION

Let's start with an example and use that to begin to explore the language.  This
first example is delibarately truncated just when it gets to the interesting
bit. But the idea is to use it to explain some concepts and pre-requisites. Then
after that, we'll provide some advice on how to continue with the guide.

TODO - make the complete example

You can also see a *complete* valid DSL script here <todo>, if you want to skip
ahead and get a preliminary feel for the whole of the language up front first.

# The (truncated) Example

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

VARIABLES:
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

## Keywords
Everything you see in the example (and the documentation below) that is 
written in upper case is a KEYWORD in the DSL.

## TITLE
The title is to document the script's broad purpose for the benefit of others.

Spaces are not allowed in the title, to help with searching / ordering /
filtering these YAML files by their title.

## DOMAIN-ARTIFACTS-REFERENCED:

Domain Artifacts (DAs) are the types of things that **already** exist on the
storage estate and that are represented to SAFE by proxy objects in the
database.  The names you declare here are the database table names. The purpose
of this block is three-fold. It tells the DSL up front that these names, when
encountered, should be interpreted as DAs. It also declares the type for those
names for type checking. And the block is necessary to fully qualify **IMPACT**
statements that come later in the DSL script. 

## MODULE-INPUTS:

Your DSL script likely requires some parameters passed in from the outside 
world when it runs. This block declares their names and types, and tells the DSL
that these names, when encountered, refer to script input parameters.

The words INT and STRING used in the example are two of the DSL's built-in
*types*. 

## Types

Types (and type-checking) are a central and important feature of the DSL.
This guide has a dedicated [chapter on types](types.md). Please read that 
chapter before resuming your reading here.

## VARIABLES

Your DSL script will likely require variables just like any other language. To
hold values that can be set and then retrieved later. It is mandatory to declare
all your variables in the DSL somewhere before the RULES section. 

This excerpt from the example above shows how you declare variables with 
a name and then a type. (Did you read the chapter on types?).

```
VARIABLES:
  last-volume-name: STRING
  candidate-volumes: LIST DA volume
  candidate: DA volume
```

> Unlike modern programming languages, variables have **global** scope
in the DSL. This greatly reduces complexity for the interpreter.

## RULES

This excerpt from our example shows you just the beginning of the first RULE
in the script.


```
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


Rules are the calls-to-action in the script. They give the system instructions
to actually do stuff.

The bulk of the information about rules lives in a dedicated chapter about rules
in this guide. But there are a few more things that you need to read about as
prerequisites before reading more details about rules. These are:
*expressions*, *impacts*, *actions*, and *queries*.

## Values and Expressions

There are lots of places in *Rules* where you need to specify a value. Like 42,
or "foo", or FALSE. Often you'll want to provide the value by giving the name of
a variable instead of a *literal* like 42. It is perfectly legal to use a
variable having one of your user defined types. When we say *value* it can be of
any of the *types* we described earlier.

The other way you can provide a value is by specifying an *expression*. Like
```40 + 2```.  In the simplest case, an expression is just a calculation. But it
can also include string manipulations.  There is a dedicated [chaper about
expressions](expressions.md).  Please read that section next.


## Actions

Note the ACTION keyword in this excerpt from the truncated example we started
with.

```
RULES:
  - NAME: "Get suitable volumes"
    ACTION: FIND-DB
```

Every rule has a name and an ACTION specified; FIND-DB in this case. In other
words the *single-responsibility* for this rule is going to be to obtain some
information by querying the database. FIND-DB is just one of the ACTION keywords
recognized by the DSL. As you would now expect, there is a dedicated [chapter
about ACTIONs](actions.md). Please read that chapter next.

## IMPACTs

There is a vitally important and valuable concept in the SAFE system. It has to
do with recognizing that many of the operations that SAFE performs on the
**real** IT estate will occur  at the same time as each other. The realistic
volume of day to day STORAGE management operations that take place in HSBC mean that this
is inevitable. It's more than inevitable, it's actually necessary that SAFE
support concurrent operations rather than queuing them one at a time
(serialized). If they were serialized - SAFE simply would not provide the
operational capacity required in HSBC.

It is also inevitable that concurrent operations can sometimes clash with each
other Furthermore some operations are dependent on another operation being done
beforehand. And some proportion of operations will always go wrong and need to
be reversed or backed out.

SAFE has capabilities to overcome these problems. The capability is  based on
knowing what IMPACT each ACTION has on each type of resources on the IT estate.
This is not the proper place to explain SAFE's capabilities in this area, but
the DSL has role to play that we will cover here.  The IMPACTs mentioned just
now, are specified in the DSL. Guess what - there's a dedicated [chapter about
IMPACTs](impacts.md).




## Queries
todo

## Now You can read about Rules (here)
todo
