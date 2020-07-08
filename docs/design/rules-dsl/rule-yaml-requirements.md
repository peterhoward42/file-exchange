# A way for an SME to define rules evaluation - requirements

We are trying to classify the requirements for the information that must be
provided to specify rules evaluation. And we hope this will help us to design in turn
a DSL.

KEYWORDS
    - are baked in to the language
    - for underlying types (int, float...)
    - and for everything in this document that is written in upper-case

## Types in the DSL (Requirements)

DOMAIN-ARTIFACT

Examples (from the storage domain might be fileshare, LUN, volume etc.)
Examples (from another domain) might be switch, firewall, ...
Another example is an Ansible Playbook.

A DOMAIN-ARTIFACTs defines a named *type*. E.g. "volume".


What is significant about DOMAIN-ARTIFACTs?
-  They are real things that live on an (IaC) IT infrastructure - for example disk
   arrays, or perhaps a configuration or playbook.
-  Our system will keep track of **instances** of these in a database and will treat the
   database records as a proxy for the real artifacts.
-  They must already exist by the time the rules being described here refer to them.
-  BUT our system will not know (in of itself) what artifact types (and hence
   database records) are needed. Other parts of the system (outside the scope
   of this document) enable the SME to create them. 
-  Domain artifacts are strongly typed by their *data model* - which is expressed using
   ENTITIES (see below). Every operation performed by the system will rigidly polic this
   strong typing.

PROPERTY definition
    These are single (scalar) values (int, float, string, bool) and they have a name by which they
    can be referred.

LIST
    - Just an ordered series of things.
    - A list's member can only be either properties, or entities. (homegeneous)

MAPPING
    - Let's wait and see if we need it?

ENTITY definitions
    - An entity is equivalent to a struct in traditinal programming languages.
    - They are ephemeral by definition when used in the DSL.
    - Let's say for the moment it can mean the type or an instance depending on context.
    - ENTITIES can have language-defined fields such as PROPERTY, LIST, MAPPING
    - ENTITIES can also use other ENTITIES as fields.
    - I.e. we have a recursive definition and make nested definitions.
    - Nb. we are on the fence, when it comes to if this means a reference or embedding.

## SOME KEYWORDS

PARAMS
    -  These aren't a thing or a type.
    -  It's just a keyword in our language that we'll require people to use in their YAML
       when they want to talk about parameters for any reason. It provides a heading for a block
       of YAML.
    -  The system doesn't do anything with this keyword. It just expects to find it in some
       places so it can find other stuff.

ACTIONS
    -  There is a built-in set of action keywords known to the system that you can use.
       And if you want to make the system to do something (significant), the only way that's
       going to happen is for you to invoke an action.
    -  Actions are not there as part of the language operation - they are significant system
       operations that the YAML can mandate the system to go off and do.
    -  Example actions are RUN-RULE, GET, RUN-PLAYBOOK
    -  See later for the full list of actions
    -  TODO: this has a smell of lacking coherence

IMPACTS
    -  The system needs to be able to reason over the implications of ACTIONS when
       they refer to DOMAIN-ARTIFACTS. Particularly during *planning* and
       *running* operations.
    -  For example, does a given action **create** a domain artifact? Or does it
       **modify** one? If the system can assess things like this, then
       it can make the necessary decisions about inter dependencies and scheduling requirements.
    -  The list of these IMPACTS is: CREATE MODIFY DELETE USE
    -  When an ACTION operates on a *domain artifact* it **must** declare which
       of these IMPACT behaviours it exhibits.
    -  If follows that ACTIONS must be able to declare their IMPACT

RULES
    -  Rules is the keyword in the DSL that separates definitions from evaluation.
    -  I.e. you define ENTITIES etc. first, then inside your RULES block, you
       will define ACTIONS.

## State

VARIABLE
    -  Variable are just like the variables in any other language.
    -  There's not much more to say is there?
    -  The type of a variable can be any of PROPERTY, LIST, ENTITY, DOMAIN-ARTIFACT

## Evaluation

Expressions

    -  We want to be able to express simple calculations to create values
       at runtime that might get used in VARIABLES, PARAMS, or PROPERTIES.
    -  For numeric values and for strings - the usual suite of operations is
       pretty well known (arithmetic, split, concatenation etc) - so we won't write
       them all down here.
    -  It may be that we don't have a keyword for this. It may be instead that
       anywhere the DSL expects a value, then (by definition) you can write an
       expression.
    -  It would be valuable to have type safety and type
        inference/auto-coercion/promotion/casting?
        -  E.g. "lun-42" + 1 produces "lun-43"
    -  Regular expressions:
        - matching will be needed for conditional logic.
        - regex separators will be needed for splitting strings
        - regex expressions will be needed for isolating prefix  or postfix segments.
        - however capturing regex groups may be a level of complexity too far.

Flow Control
    -  if / elsif / else
    -  repeat(6) // gives you automatically a loop count variable
    -  iterate over a list of things with capture variable (plus index)
    -  flow control nesting must be supported - e.g. an **if** inside a **repeat**.

RULES
    -  RULES are the building blocks with which you tell the system how to
       evaluate and execute the stuff you want to do.
    -  It is a construct that puts together inputs, outputs, evaluations,
       conditional logic, iteration and ulitimately: ACTIONS.
    -  Perhaps think of them as function calls.
    -  They have a name by which you can refer to them.
    -  Conceptually one rule might invoke (call) another.
    -  Rules are executed in a sequence, and conditionally according the
       flow-control previously discussed.
    -  Rules take parameters, and can return data - like function calls.
    -  In our case, these arguments might be VARIABLE, ENTITIES, PROPERTIES,
       EXPRESSIONS, DOMAIN-ARTIFACTS.
    -  The "meat" in a rule is to fire ACTIONs!