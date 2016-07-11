# Scalability & System Designs

## Standard web app architecture
### Basic pieces:
* Client
* Load balancer
* Application servers
* Caching layer
* CDN(s)
* Databases

### Heroku Toy Architecture
* Rails app running on a single Heroku instance, running WEBrick server
* Could probably service 100~ requests per minute
* Rails app running on one Heroku instance, running Unicorn (multi-process server) or Puma (multi-threaded server)
* Could probably service 500-2000 requests per minute

### Horizontal vs Vertical Scaling
* Vertical: increase the resources of a specific node.
* Horizontal: increase the number of nodes

## Application Servers
### Sessions/States
Sessions are state
  * Local sessions = bad
    * Stored on disk
    * Stored in memory
    * It's generally bad because you can't move users, you can't avoid hotspots
    and there is no fault tolerance
    * Custom built
      * Store last session location in cookie
      * If we hit a different server, pull our session information across
    * If your load balancer has sticky sessions, you can still get hotspots
  * Centralized sessions = good
    * Store in a central database or an in-memory cache
    * No porting around of session data
    * No need for sticky sessions
    * No hot spots
    * Need to be able to scale the data store
  * No sessions at all = great
    * Stash it all in a cookie
    * If you need more than the cookie (login status, user id, username),
    then pull their account row from the database or the account cache
    * None of the drawbacks of sessions
    * Avoids the overhead of a query per page
      * Great for high volume pages which need little personalization
      * You can stick quite a lot in the cookie too
      * Pack with base64 and it's easy to delimite fields

The bottom line is, scaling web application server can be done with the idea
of stateless and build many servers to handle requests. But, of course, don't forget
to use load balancer to direct requests. However, the rests are trickier

### Queue
__Synchronous systems__
  1. Request sent to web server
  2. Time passes
  3. Reply comes back

__Asynchronous systems__
  1. Request sent to web server
  2. Reply comes back immediately
  3. Stuff happens later

Following is the flow for __asynchronous systems__:
1. Request sent to web server
2. Reply comes back with a ticket
3. Time passes
4. Ask for ticket status
5. Reply comes back

![asyn]
[asyn]: ../img/asyn_system.png

## Load Balancer
The role of a load balancer is to distribute and direct requests evenly
to all the servers.
__Consistent Hashing__ is needed for balancing loads
when servers are constantly added and removed.

## Caching
Caching avoids the need to scale or at least make it cheaper.

The challenge of cache is when we try to write to the cache

Here are some complicated caching
* Write-through cache
  * Pro - It directs write I/O onto cache and update data in the database level. It keeps cache and backend data consistent
  * Con - even though it is slow to write to the database level, latency isn't the issue because write to and read from the cache are fast. The real problem is bandwidth. It puts a limit on how many items you can write to the persistent storage layer.
  * Write-through cache is good for applications that write and then re-read data frequently as data is stored in cache and results in low read latency but it isn't ideal for write heavy applications.

* Write-back cache
  * Pro - I/O is directed to cache and completion is immediately confirmed to the server. Modification in the cache are not copied to the database until absolutely necessary. This results in low latency and high throughput for write-intensive applications.
  * Con - Backend data and cache are not consistent and in the event of hardware failure, all newly obtained data are lost because the cache didn't have a chance to copy them to the databse

* Sideline cache


## CDNs
* Way faster than serving content straight from your server.
* Any JS and media files should live on the CDN and be served from there.
* All JS and CSS concatenated together.
* Your server should return *only* HTML markup.

## Databases
Database is the toughest part to scale. If we can, it's best to avoid the issue altogether and just buy bigger hardware. Web application typically have a read/write ratio of somewhere between 80/20 and 90/10.

If we can scale read capacity, we can solve a lot of situations. For read heavy application, master-slave is the answer.

### Master-slave Replication
Depends on implementation, various system has different approach toward replication but they all come down to the same idea. Whenever a file is written on a database, the master will duplicate this file and distribute the replicas across nodes.

When client requests a file, the master will report to client the location of the file. Client will then directly access the node that is closest to him/her.

For example, this is the Google File System
![gfs]
[gfs]: ../img/gfs.png

### Database Denormalization and NoSQL
Denormalization means adding redundant information into a database to
speed up reads. For example, a person has pets. In a RDBMS, pets have owner_id
and the person object access the pets through association and JOINs. But
in a denormalized table, the pet information is stored on the persons table.

A NoSQL database stores rows as something that's similar to a JSON object.
NoSQL database does not have tables, it has collections. It means a collection
of objects.
### Databases
* Relational
  * PostgreSQL
  * MySQL
  * SQL Server
* Non-relational/NoSQL (schema-less)
  * Document-based (XML/JSON)
    * MongoDB
  * K-V stores
    * Redis (also caching layer)
  * Distributed databases
    * Cassandra (K-V like)
    * Riak  

### Relational databases are bad at scaling
* Joins are inefficient when databases become humongous, and that's probably
why MongDB called themselves hu-__mongo__ -ous.

## Database Sharding (Partitioning)
Sharding means splitting the data across multiple machines while ensuring
you have a way of figuring out which data is on which machine.

* Vertical Partition: This is partition by features
* Key-based or Hash-based Partition: This allocates data by hashing them and put
them on different machines but adding additional servers means re-allocating
all the data - very expensive task. Use __consistent hashing__ !
* Directory-based Partition: Maintain a lookup table for where the data can
be found.



## Metrics
* Bandwidth: This is the maximum amount of data that can be transferred in
a unit of time. kB/s
* Throughput: This is the actual amount of data that is transferred
* Latency: This is how long it takes data to go from one end to the other. It
is the delay between the sender sending information and the receiver receiving it.



---
## More topics
### How to scale a relational database
* If you have high read load, then master-slave replication.
* If you have a high write load, then shard.
* Can span many data centers!
* If you have high write load across shards, you're f***ked. Stop using a relational DB.

### Caching layer
* Redis, Memcached
* Completely in-memory, extremely fast
* Key-value stores
* Common queries or static data
* Cache invalidation (using LRU)

### Application Server
* Many, many application servers running on many machines
* Usually spun up on AWS or using bare metal (for Google/Netflix, etc.)
  * Much cheaper than Heroku or managing your own
  * Heroku is PaaS, AWS just provides you an out-of-the-box server
* Checks the caching layer for most requests
* Occasionally does the work to invalidate the cache

### Services vs monolith
* SOA (service-oriented architecture)
* Also known as "microservices"
* Monoliths (what you know)

### Example of services
#### Uber
  * Routing service
  * Dispatch service
  * Payment processing service
  * Reviewing service
  * User authentication service

### Pros and cons of SOA (Server Oriented Architecture)
* Failures can be isolated to particular services without taking down to the entire system

* Easy to divide among teams, a team can keep their codebase small and understandable
    * Microservices can be written in various languages, monolith is all in one language
    * Easier to do small refactorings
    * Harder to do big refactoring across many services

* A little bit of overhead in messages

### Client vs server
* How should they talk? Use HTTP (via TCP), or use UDP?
* What info should live on the client rather than the server?
    * What needs to be persisted, and what's okay to lose?
    * Scalability tradeoffs here
    * What if client and server become inconsistent?

### Asynchronous jobs
* Does it need to be done *right this second*?
* If not, just queue it up in a background process and tell your user you'll get it done!
* Many, many things can be done asynchronously.
    * Common message queues: RabbitMQ, Resque, Sidekiq

### Load balancer
* Balances load. Duh.
* What if this goes down?
    * More load balancers! Failover!
* Round Robin DNS
* Smart load balancing is ideal, but dumb is good enough
* Put one into the database layer as well!
