# Pros and Cons of YAML vs PYTHON as the host language for our DSL

## Narrative

When I say "host language" I mean are we going to write our rules in
syntactically valid YAML or syntactically valid Python?

The syntax of what is written and conveyed is seriously important, but the
absolutely crucial thing to observe is this. Both choices provide a language
syntax and grammar specification, AND readily available, open-source, and high
quality *parsers*. But YAML was **never intended** to be good for expressing
**program**-like concepts (which is what we need here). Instead it is intended
to express **data** (which it does very brilliantly).  Conversely the Python
syntax and grammar is designed **exactly** to express **program**-like
concepts. (Which it does brilliantly). It follows that no matter what we come
up with with reserved keywords for YAML; ultimately we are coercing a program
into the very unnatural home of YAML - and that just creates obstacles for the
user, for developers, and for the system. On the other hand, Python, being
designed from the ground up for expressing programs - not only provides a
highly expressive, friendly, and convenient world for the author to express
their intent, but it also gives us completely for free, (and instantly) an
interpreter. If we use YAML, we have to design, build, validate and maintain
our own custom interpreter. Which is a huge, expensive, time-consuming,
constraining and fragile undertaking.

- YAML
  - More familiar to SMEs
  - Easier (when hand-written) to avoid syntax errors
  - Verbose (in comparison)
  - Limited and primitive expressiveness
  - Much easier to auto-generate from a UI
  - VERY complex and time-consuming to build and validate the 
    (completely custom) interpreter
  - Capabilities for expressing future needs are closed-off - without we 
    develop new features.

- Python
  - Unfamiliar to SMEs, (but famously beginner-friendly)
  - Harder (when hand-written) to avoid syntax errors
  - Elegantly brief
  - Unlimited expressiveness (all of Python)
  - But amenable to being used very simply too
  - VERY much harder (impossible?) to auto-generate from a UI
  - We don't have to build a parser or runtime interpreter at all
  - The available, open-source, official, parser and runtime interpreter 
    are battle-hardened, and of diamond, industrial quality
  - We get syntax for: variables, flow control, block scoping, lists,
    maps, expressions, operators, for free - and infinitely richer than we can 
	invent.
  - Extensive library functions for string manipulation
  - We get the runtime interpreter for those things for free

Pete's Conclusions and Summary Judgements

- The time to market for using YAML is infeasible
	-  We're talking months, not weeks for the server-side aspects.
- The fitness-for purpose for using YAML is dubious.
- My intuition tells me that trying to coerce the features of a programming 
  language into YAML is a serious and fundamental error of judgement that 
  will:
  	- limit the expressiveness available - placing more burden in turn on
	  our SME users in having to use a 'tool' that does not have the right 
	  paradigm for the job.
    - hold us back and limit us damagingly in the future - thus limiting the
	  life of the product
	- create an enourmous bug and maintenance "surface" and vulnerability in
	  our system.
- My intuition tells me that non-programmers learning to create simple
  scripts when provided with examples, and the abundant and very good 
  learning resources that are available for Python is a reasonable ask that
  does not seriously undermine the project proposition. Note that Python is
  increasingly the in-app scripting language of choice for many high-end
  COTS apps. (I saw it adopted very easily by mechanical engineers at 
  Rolls-Royce and Airbus as the scripting language introduced to their 
  CAD systems.)
- Unfortunately, selecting Python may rule out permanently - the
  auto-generation of the code from a UI. The technical difficulty of doing that
  likely means the justification will never add up. (Unless we can find a
  project that's already tackled this challenge that we can adopt). The best we
  could hope for is a very smart code editor UI that shows the Python, and
  provides intellisense-like features, supported (heavily) by cooperation with
  the backend.

# In a nutshell

I suspect the time-to-market, cost and feature-paucity implications are the
killer arguments in favour of Python. But we must face up to the decision
being, in a sense irreversible.

### Supporting evidence

My personal perception about the ease of learning Python for newcomers is not
useful because of the inevitable skew from being expert in it and being a
professional developer.

However, the first hit when I Googled "which programming languages are good for 
beginners". Was this:

https://nhlearningsolutions.com/blog/7-programming-languages-for-beginner-developers

It says:

> Python is one of the most commonly used programming languages today and is an
> easy language for beginners to learn because...

