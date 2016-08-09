# Architecture

## Architecture vs Design
### Example Questions
#### What does a design question sound like?
* How would you design a Scrabble game?
* Walk me through how you'd make a Tetris game. How would you model the data?
* Imagine you create a program that manages a car park. What are some architecture choices you make? (This is still a design question because a car park doesn't need to scale)

#### What does an architecture question sound like?
* How would you design Twitter?
* Say you need to create a WhatsApp clone. Imagine you have millions of users. How do you build your system? What services do you create?
* Explain to me how you'd architect an app like OpenTable.

#### Bad answer for Architecture questions:

* I'd make a Rails app. I'd use such and such models and here's my DB schema.
---
### Toy architecture
* WEBrick on Heroku
  * Rails app running on a single Heroku instance, running WEBrick server could
  probably service around 100 requests per minute
* Unicorn/Puma on Heroku
  * Rails app running on one Heroku instance, running Unicorn (multi-process server) or Puma (multi-threaded server) could probably service 500-2000 requests per minute
  * Puma spawns new worker. This is basically saying that multiple machines are hooked up.
  A central machine works as a master and tells other machines what to do and those other
  machines are the workers

But what if you want to go bigger?

## Standard Web Application Architecture
### Basic pieces:
* Load balancer
* Application servers
* Caching layer
* CDN(s)
* Databases

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

### Relational databases suck at scaling
* Joins, joins, joins

---
### But sometimes they're necessary.
* Denormalizing a relational database can usually make it faster.

---
### The most important concept in architecture:
# Failover

---
### How to scale a relational database
* If you have high read load, then master-slave replication.
* If you have a high write load, then shard.
* Can span many data centers!
* If you have high write load across shards, you're f***ked. Stop using a relational DB.


---
### Think about your data model. Is there a natural aggregation?

---
## CDNs
* Way faster than serving content straight from your server.
* Any JS and media files should live on the CDN and be served from there.
* All JS and CSS concatenated together.
* Your server should return *only* HTML markup.

---
### Caching layer
* Redis, Memcached
* Completely in-memory, extremely fast
* Key-value stores
* Common queries or static data
* Cache invalidation (using LRU)

---
### Application Server
* Many, many application servers running on many machines
* Usually spun up on AWS or using bare metal (for Google/Netflix, etc.)
  * Much cheaper than Heroku or managing your own
  * Heroku is PaaS, AWS just provides you an out-of-the-box server
* Checks the caching layer for most requests
* Occasionally does the work to invalidate the cache

---
### Services vs monolith
* SOA (service-oriented architecture)
* Also known as "microservices"
* Monoliths (what you know)

---
### Examples of services
#### (Uber)
* Routing service
* Dispatch service
* Payment processing service
* Reviewing service
* User authentication service

---
### Pros and cons of SOA
* Failures can be isolated to particular services without taking down to the entire system

* Easy to divide among teams, a team can keep their codebase small and understandable
    * Microservices can be written in various languages, monolith is all in one language
    * Easier to do small refactorings
    * Harder to do big refactoring across many services

* A little bit of overhead in messages

---
### Client vs server
* How should they talk? Use HTTP (via TCP), or use UDP?
* What info should live on the client rather than the server?
    * What needs to be persisted, and what's okay to lose?
    * Scalability tradeoffs here
    * What if client and server become inconsistent?

---
### Asynchronous jobs
* Does it need to be done *right this second*?
* If not, just queue it up in a background process and tell your user you'll get it done!
* Many, many things can be done asynchronously.
    * Common message queues: RabbitMQ, Resque, Sidekiq

---
### Load balancer
* Balances load. Duh.
* What if this goes down?
    * More load balancers! Failover!
* Round Robin DNS
* Smart load balancing is ideal, but dumb is good enough
* Put one into the database layer as well!

---
## How much do your most common operations cost?
---
## Facebook design
---
## Twitter design
---
## WhatsApp design
