nibbler
=======

In-progress zmap-like port scanner targeted towards distributed infrastructures.

Theory
======

A couple of key points are:
- The idea that you can "scan the entire internet in 5 minutes" and not hammer and given network because you randomized
  the destination IPs is absurd-- you're still sending a bunch of SYNs to the entire target network in (ideally) under 
  5 minutes, right?
- Specialized/high-end hardware or high-end networks is not a realistic use-case for the average person wanting to scan
  the entire internet. Moreover there are all sorts of considerations that exist outside of your immediate control-- the
  source and destination networks, all of the IPS/IDS/DDoS mitigation/firewalls in between the two points, the bandwidth
  between them, et cetera. "in {5 minutes, 1 hour, X}" is a sales claim not based in reality for basically everyone that
  doesn't have the resources of the NSA; to the people making them, I question how much analytics they've done on the 
  resulting data, specifically if they notice a lot of flux between scans of the same large networks (indicative of 
  data loss).
- Presently, nothing tries to tackle the fact that large tracks of the world have already switched to IPv6.
- Instead of trying to do everything unreasonably fast, lets instead focus on accomplishing the task within a 
  "reasonable period of time"; where reasonable is a variable definition.
- Using a distributed node-based architecture allows for some alternative use-cases of higher interest
- Instead of having a single collection point which is also trying to spew 2M+ packets/second (and thus leading to more 
  packet loss), how about we just use a database, or even if we wanted, a series of databases.

As such, the basic model here is a GUI front end that just takes input from the user and distributes it out to N configurable
nodes and then reads the information from one or more database servers that the nodes report to. This removes the "user must 
be a linux nerd with higher end hardware and a fat pipe" and turns it into a "point click and pray" user-model that operates 
in a fire-and-forget fashion and intends to complete in a "reasonable" period of time that scales primarily to the resources
available to the user in question; actually and realistically resolving the problem to something more easily understood by
MBA types: money instead of "well we scanned everything but for some reason we have to scan everything multiple times and 
every time we do we get drastically different results, and im not sure why. Also, we need more IPs because half of the 
world has now black-listed us". Which is to say, the problem is reduced to "if its not fast enough, we buy more boxes and
install more nodes" AKA the Google approach instead of the SGI approach.

Current Status
==============

Pretty GUI, mostly non-functional.
Linux node code entirely non-functional.
Database code, entirely absent.
Summary? approaching functional, but presently just X thousand lines of code that does nothing. )

(Multiple; Baltimore, allowed out of the box for DOD requests to parallel construct industrial espionage. Eventually sabotaged)
