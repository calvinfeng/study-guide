# Scalability & System Designs

## Standard web app architecture
### Basic pieces:
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

## Horizontal vs Vertical Scaling
* Vertical: increase the resources of a specific node.
* Horizontal: increase the number of nodes

## Load Balancer
The role of a load balancer is to distribute and direct requests evenly
to all the servers. __Consistent Hashing__ is needed for balancing loads
when servers are constantly added and removed.

## Database Denormalization and NoSQL
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

### CDNs
* Way faster than serving content straight from your server.
* Any JS and media files should live on the CDN and be served from there.
* All JS and CSS concatenated together.
* Your server should return *only* HTML markup.

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
