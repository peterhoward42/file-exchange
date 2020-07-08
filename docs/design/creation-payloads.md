# Thinking about Designer-Mode Modeling and Communications with the API

## Introduction

Consider this use-case:

An SME designer POSTs to /endpoints/new to create a new endpoint with the URL
specified as say /fileshares/create - that a storage engineer operator can
then use subsequently to trigger the creation of file shares.

What data will be required in the /endpoints/new POST?

- I.e. what information is needed (conceptually) to stand up the new
	   /fileshares/create endpoint?
- The URL it should exist at. In this case /fileshares/create.
- That it receives POST requests only.
- The payload expected by /fileshares/create at runtime (what data 
	   will it need).
- The payload validation that /fileshares/create should perform.
- What actions the handler for /fileshares/create should actually perform
- What information should /fileshares/create have in its response when it
  runs.

### Design Caution

Our use-case example creates a file share - i.e. it is a use-case in the
storage domain. But our solution evolution must keep in mind that the system
we are creating must not be tied to a singular domain. It should be equally
useful for other IaaS domains. Ideally our new system will contain no such
concept as a domain. One way of looking at this is to say that you shouldn't
be able to find the words "share" or "volume" anywhere in the system's source
code.

Let's Explore the Shape and Essence of the /endpoints/new payload - i.e. what
information must be carried by the POST request to make it possible to create the
new /fileshares/create endpoint.

Specifying the required URL and that it receives POST requests are trivial considerations.

## Input Schema for the newly created endpoint

There will be a part of the payload that specifies the input schema for the newly created
endpoint. For a file share this will be something like (illustrative):

-  Size required
-  Human friendly name for the share
-  Whether it must be encrypted
-  Geographical Region and Zone
-  etc.

How might this be conveyed as part of a POST payload.

-  Remembering that it must cope with any IaaS domain.
-  Well it looks a bit like a JSON a schema right?
-  It would be very advantageous to leverage a widely adopted standard if 
   we could.
-  So how about we assume for the time being that this part of the payload 
   IS a JSON schema.

## Input validation the new endpoint should perform

There will be a part of the payload that specifies the validation that the newly created
endpoint must perform on the input values it receives.

We can provide the /fileshares/create endpoint with some payload validation right
from the start, because the call to /endpoints/new that created it - specified
its payload expecations with a JSON Schema.  The JSON schema standard includes
validation rules, and freely available software libraries makes it possible to
validate payloads against the validation in the schema automatically.

However that is not enough validation. Because the JSON schema validation can
only validate one payload, in isolation at a syntactical level. Consider the
human-friendly name being asked for the share being already in use?  More
generally, this a problem about validating the share creation request in the
context of those that have been created earlier. The key point being that the
validation must access historic data (assumed to be in a database).

So it looks like we should build it so that there is schema-level validation
performed as soon as the POST to /fileshares/create comes in, but also assume
that additional (contextual) validation is needed later when the endpoint
actually starts going about its business. This topic is covered in the later
section about what actions the handler for /fileshares/create should actually
perform.

## The Action (or Handler) part of the payload

There will be a part of the payload that specifies what the handler
for /fileshares/create should actually do when it receives a POST request.

Let us remind ourselves of the fileshare specification we are going to receive:

- Size required
- Human friendly name for the share
- Whether it must be encrypted
- Geographical Region and Zone
- etc.

Note that these are high level meta requirements. They do not specify for
example whether an existing NAS volume should be used to create the share on,
or if a new one should be created.

It could be that there is not sufficient space on an existing one, and so the
only choice is to create a new volume first before creating the share.

What this example tells us is that some logic rules must be executed by the
handler for /fileshares/create. These rules are partly validation, and partly
decision making - with conditional logic in order to decide what to do.
Reminding ourselves again that the system does not even know it's dealing with
storage - it follows that all the logical rules that must be executed, must
be specifed as the part of the payload to /endpoints/new.  We'll explore next the
question of how can the payload express these logical rules and how
(logically) they can be persisted in a database, so that the
/fileshares/create handler can retrieve and use them at runtime.

## Expressing handler business logic in a payload

Consider the phrase written earlier: 

	It could be that there is not sufficient space on an existing
	one, and so the only choice is to create a new volume first before
	creating the share.

What this example tells us is that some logic rules must be executed by
the handler for /fileshares/create. These rules are partly validation,
and partly decision making - with conditional logic in order to decide
what to do.

The quote above is a *statement* about business logic.

The vocabulary leads us to some of the modeling constructs required. Let's 
start with a brainstorm for some of these things and see where it lead us...

- there is a concept of **properties** - for example the **space** property
- a **property** is something you can measure on something
- properties have an **underlying-type** (int, string, float)
- the concept of **exists** is an example of a **logical operator**. The set 
  of allowed **operators** are likely hard-coded as keywords known in advance to the system.
- **greater-than** is another example of an **operator**. (space > threshold)
- there is an **entity-type** called "volume"
- in the case of "volume" it has the **space** property
- other example **entity-types** taken from the storage domain might be
  {file-share, LUN, RAID5-ARRAY, ISCSI-SAN etc.}
- we use **action-verbs** in our rules like "creation" or "create". We suspect we can
  predict the set of action verbs we need in advance. Likely the same as the HTTP
  verbs: {GET/POST/PUT/PATCH/DELETE}. If that transpires to be the case
  we could make these action verbs also keywords built in to the system.

## Experiment in Writing A File Share Creation Rule

Let's try to write the logic in the quote above in YAML using the newly introduced 
constructs and see what happens. (Brainstorming mode at present	)

I've put this into ./example.yaml, so that it can be a proper YAML file and I can get some
help from the IDEA with syntax checking.



### Todo
- consider some sections of the yaml being POSTed in advance to dedicated end points.
  Like /properties/new for example, or /entities/new. And the the POSTs that define rules
  referring to those properties by name.
- validation for rules

### Feedback
- Iteration?
- Name queries
		
