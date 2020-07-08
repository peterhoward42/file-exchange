# Design Principles for the DSL


## DATA not Code

The job of the RULES DSL is to express a runtime programming intent.  Much like
source code. But we wish for the form of expression to look like data, and not
to look like programming language source code. The motives for this are:


- Our system users are not programmers, and we have a hard requirement that
  our system must not expect them to think of, or engage with, programmng 
  in the conventional sense.
- To make it possible for UI tools to guide the user through the process of
  saying what they want it to do.
- To make it easier for UI tools to compose and output a DSL script than it
  would be if they had to generate conventional source code. Composing and
  outputting *data* is routine in a front end. Composing and outputting
  source code is very specialist and very difficult.
- To make it easy to serialize the programming intent, for transport between
  systems and components.
- To make the challenge of designing and implementing the system that executes
  the programming intent as simple and small as possible. This is a big factor,
  in terms of cost/benefit/risk for the project.
- To provide an abstraction layer for the programming intent - to keep open
  choices about how the execution runtime could work. For example we could
  write an interpreter, or alternatively a transpiler into a real programming
  language that can then be executed natively.

## Explicit not Implicit

The DSL should spell out every last detail of what is required explicitly for
the following reasons:

- To reduce the interpretation burden for the runtime implementation to a
  minimum.
- To maximise the usefulness and insight of static validation
- Ultimately so that the system can help users to get things right, and make
  it as difficult as possibile to get things wrong.

# Verbosity and Elegance and DRY

These matter immensely for source code that has to be written by humans. But
they are completely irrelevant here - because the DSL will be written by
a machine. It is analagous to the compiled byte code used under the hood by
Python, Java and .Net. We gain far more holistically by making the DSL
uncommonly explicit and thus verbose.
