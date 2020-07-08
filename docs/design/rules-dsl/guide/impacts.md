
and the IMPACT keyword
is how 

Specifically it
requires that DSL scripts are run through a *planning* phase before they can be
run for real. This planning phase is able to understand the potential for
operations to clash with each other and their sequence interdependencies. It can
then enforce a sort of claim and registration scheme where for a short window of
time it claims the sole right to to fiddle with some resource on the estate, and
thus block concurrent operations that would clash.

However SAFE's design brief means that it *does not know* in of itself that its
dealing with storage resources. It is supposed to be similarly useful for other
IaaC resource. So it cannot have hard coded into it any knowledge of what
*IMPACT* each operation might have on the resources it is managing. Instead the
SME that is using the system (in design mode) not only takes responsibility for
specifying what resources they want to work with (e.g. file shares), but they
also take the responsibility for 
