## VPS
Virual Private Server - shared hardware but individual copy of softwares
* DreamHost
* Go Daddy
* Host Gator
* Linode
* pair Networks
* Slicehost
* VPSLAND

## Amazon Web Service EC2
Automate spawning new web servers

# Scalability
## Vertical
* CPU
  * More cores
* Disk
  * More space
  * PATA, SATA, SAS, more bandwidth, more RPM - 15,000
* RAM
  * Process more at once

## Horizontal
Bunch of more cheaper machines, but the problem is, where should client requests
go?
### Distribute Requests
#### Load Balancing
When request comes in, the DNS will map domain name to IP address of the
black box load balancer. In this case, the application servers themselves don't
need public IP address. Rest of the world won't be able to see the actual
IP location of the application nodes.

We can either send the request to least busy server. We can use round robin to
distribute the load evenly. This load balancer is just a fancy DNS server with
built-in logic that distributes load.

Example:
* Software
  * ELB
  * HAProxy
  * LVS

* Hardware
  * Barracuda
  * Cisco
  * Citrix
  * F5

$100,000 for a load balancer or generally for a pair...

#### What's the catch?
Just by bad luck, one of the servers gets a computationally heavy task. There
is no point of querying the DNS server every single time we make a request. In
fact, typically the browser will cache the response and record the IP address
of the website I typically visit. If you are one of the power users that consumes
large amount of resources on server A, you will stay on server A while the next
guy will get send to server B, C, D or whatever. But it doesn't solve the real
problem.

More sophisticated approach, would be making decision by server load.

Also as we scale, data will become desynchronized and if every user gets directed
to a new place every time he gets distributed to a new IP address, to a new server.
Big pain in the butt

#### RAID
Redundant Array of Inexpensive Disk - multiple hard drives
RAID-0 - two identical hard drives, spin A a bit write some info to it, then spin B a bit write some info on it and this is known as striping
RAID-1 - two mirror hard drives

#### Make many copies
The application server does not store the session token, pass it onto a distributed filesystem.
Using the idea of replication to make multiple storage of the data.

### Sticky Sessions
Many complex web applications store state locally and can fail or underperform if a load balancer distributes requests in a user’s session across different servers instead of directing all requests to the server that responded to the initial request.

When session persistence is configured, the NGINX Plus load balancer identifies user sessions and pins all requests in a session to the same upstream server. This avoids fatal errors for applications that only store state locally, and it significantly improves performance for applications that share state across a cluster.

Despite HTTP being a ‘stateless’ protocol, many applications store state locally and don’t perform well in a load-balanced environment. Once a user commences a complex transaction with an upstream server (for example, putting the first item in his shopping basket, or starting a paginated search), it is often optimal to direct all of the user’s requests to that same server, because sharing state between servers is slow or even impossible.

NGINX Plus tracks user sessions and pins them to the correct upstream server. It provides three methods for identifying user sessions: Inserting its own tracking cookie into the traffic, Learning when servers create a session and detecting requests in that session, and tracking specific data in a request (such as the jvmRoute).

But if you must use server-local session state, sticky sessions are definitely the way to go-- and even if you don't use server-local session state, stickiness has benefits when it comes to cache utilization (see above). Your load balancer should be able to look at HTTP cookies (not only IP address) to determine stickiness, since IP addresses can change during a single session (e.g. docking a laptop between a wired and wireless network).

Even better, don't use session state on the web server at all! If session state is very painful to lose (e.g. shopping carts), store it in a central database and clear out old sessions periodically. If session state is not critical (e.g. username/avatar URL), then stick it in a cookie-- just make sure you're not shoving too much data into the cookie.

Modern versions of Rails, by default, store session variables in a cookie for the reasons above. Other web frameworks may have a "store in cookie" and/or "store in DB" option.

The implementation detail of sticky session is implemented in the load balancer. The load balancer
remembers a number mapping scheme that maps a particular request to the same physical server.


## Authentications
In *Session-based Authentication* the Server does all the heavy lifting server-side. Broadly speaking a client authenticates with its credentials and receives a session_id (which can be stored in a cookie) and attaches this to every subsequent outgoing request. So this could be considered a "token" as it is the equivalent of a set of credentials. There is however nothing fancy about this session_id-String. It is just an identifier and the server does everything else. It is stateful. It associates the identifier with a user account (e.g. in memory or in a database). It can restrict or limit this session to certain operations or a certain time period and can invalidate it if there are security concern and more importantly it can do and change all of this on the fly. Furthermore it can log the users every move on the website(s). Possible disadvantages are bad scale-ability (especially over more than one server farm) and extensive memory usage.

In *Token-based Authentication* no session is persisted server-side (stateless). The initial steps are the same. Credentials are exchanged against a token which is then attached to every subsequent request (It can also be stored in a cookie). However for the purpose of decreasing memory usage, easy scale-ability and total flexibility (tokens can be exchanged with another client) a string with all the necessary information is issued (the token) which is checked after each request made by the client to the server. There are a number of ways to use/ create tokens:

## MemCached
Why is Craiglist delivering HTML file directly
They are storing html file directly !!! So that they don't have to regenerate HTML file
everytime we re-visit it. This is a way of caching.

Why is Craiglist stuck in the 90s? If you want to change the appearance of the file,
since HTML pages were directly stored in the data bases, there is no trivial engineering way to
modify these HTML files.

Connect to MemCached through its server
Disk is slow
MySQL provides a layer of cache
Memory Cache Daemon -> MemCacheD
If the item is null in our MemCacheD, then we hit the SQL database and make a query on the
item. Then we store a key and the item in the cache.
MemCache is this key-value pair storage.

### Facebook
These days, Facebook is still read heavy. Facebook uses MemCacheD quite a bit.

## Database
Replication is all about making automatic copies of something. A master database
which is where you read data from and write data to but just for good measure that
master has one or more slave databases attached to it. This will solve the
read heavy issue because we can distribute load. Load balancing for database!
Slaves are either for redundancy or for balancing read quests.

What is the fault in this layout?
What if the master dies? We need multiple masters. We propagate queries across
masters. This will help us with writing.

## Partitoning
Still have redundancy, balance load based on high level user information
## High Availability
high availability refers to some kind of relationship between a pair or more of servers that are checking each
other's heart beat and if someone in the network dies, the other will take over the full control.

DNS at Geography level
