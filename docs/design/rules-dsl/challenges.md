Have less embedded parsing and exploit YAML structure more to reduce
demands on interpreter at expense of verbosity.

Impacts must be totally accurate and idempotent.

Create must define all the details of what it creates to support reasoning
in the planning stage - e.g. the array on which a volume is allocated.

Create granularity must be per rule, so we need identifiable rules.

The planning process needs to know idempotent names for what is created
so it can check that is ok ahead of time. For example creating something
with a name already in use would be a planning failure.

There must only be one playbook in a rule, so that that playbook's recovery
block can be used to undo a rule firing.

In our usecase alternatives is two playbooks - for the variant that creates
a volume and the variant that does not. Or a single one that takes a create
flag.

Think perhaps more in terms of *data* to describe the rules.


