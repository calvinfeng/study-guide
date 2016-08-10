# Scalability & System Designs

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

### Heroku Toy Architecture
* Rails app running on a single Heroku instance, running WEBrick server
* Could probably service 100~ requests per minute
* Rails app running on one Heroku instance, running Unicorn (multi-process server) or Puma (multi-threaded server)
* Could probably service 500-2000 requests per minute
* Puma spawns new worker. This is basically saying that multiple machines are hooked up.
A central machine works as a master and tells other machines what to do and those other
machines are the workers

But what if you want to go bigger?

## Standard web app architecture
### Basic pieces:
* Client
* Load balancer
* Application servers
* Caching layer
* CDN(s)
* Databases

### Horizontal vs Vertical Scaling
* Vertical: increase the resources of a specific node.
* Horizontal: increase the number of nodes


## Load Balancer
The role of a load balancer is to distribute and direct requests evenly
to all the servers.

The most obvious method of load balancing is hashing.
* Every server is a bucket
* Every request that comes in can be represented IP address
* Hash the IP address and mod the integer by the number of servers
* Direct request to the bucket

However, as you increase the number of servers over time, requests will get to
directed to different machine. This can potentially create problems for some
applications such as applications that rely on sharding to reduce write load. Thus,
use consistent hashing technique.

__Consistent Hashing__ is needed for balancing loads when servers are constantly added and removed.

* What if this goes down?
    * More load balancers! Failover!
* Round Robin DNS
* Smart load balancing is ideal, but dumb is good enough
* Put load balancer in database too if it's a distributed system


## Application Servers

### Scaling the Application
* Create many, many application servers running on many machines
* Usually spun up on AWS or using bare metal (for Google/Netflix, etc.)
  * Bare metal is referring to go out there and buy your own machine to build servers
  * Much cheaper than Heroku or managing your own
  * Heroku is Platform as a Service: it provides a platform that will automate the
  the process of launching a Rails application.
  * AWS is Infrastructure as a Service: it provides you an out-of-the-box server.
* Checks the caching layer for most requests
* Occasionally does the work to invalidate the cache

### Services vs Monolith
* SOA (Service-Oriented Architecture)
* Also known as "micro-services"
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
* Monolith system will go down even if a small part of the system breaks
* Easy to divide among teams, a team can keep their codebase small and understandable
* Micro-services can be written in various languages, monolith is all in one language
* Easier to do small re-factorings
* Harder to do big refactoring across many services
* A little bit of overhead in messages
* Communication between services will become very complicated

Any startup will start as a monolith and as it scales up, it will be broken down into micro-services

### Client vs server
* How should they talk? Use HTTP (via TCP), or use UDP?
  * TCP - connection based, three-way handshake.
    * Sender requests connection
    * Receiver responds with acknowledgement
    * Sender receives acknowledge and begins sending packages
    * Packets will be received in correct order
    * A lot of overhead, many acknowledgements
  * UDP - connectionless, relatively unreliable transfer protocol
    * UDP does not guarantee order in packet delivery
    * Data corruption is a common error on the internet. When UDP transport
    layer detects a data corruption, it will not try to recover it, instead
    it will just discard it. This is why UDP may seem as an unreliable
    transfer protocol
    * UDP is lower latency, ideal for video and voice communications
* What info should live on the client rather than the server?
  * What needs to be persisted, and what's okay to lose?
  * Scalability tradeoffs here
  * What if client and server become inconsistent?
    * in-sync or out-of-sync? a business decision

### Asynchronous jobs
* Does it need to be done *right this second*?
* If not, just queue it up in a background process and tell your user you'll get it done!
* Many, many things can be done asynchronously.
* Common message queues: RabbitMQ, Resque, Sidekiq

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

## Caching Layer
Caches are important to prevent data base from getting smashed by heavy requests.
Caching avoids the need to scale or at least make it cheaper. The challenge of cache
is when we try to write to the cache.

Cache layer is basically a big chunk of memory.

Redis and Memcached are the popular choices for caching layer
* Properties
  * Completely in-memory, extremely fast
  * Key-value store
    * All caches are essentially key-value store
    * They are giant hash maps
  * What are stored in the cache?
    * Common queries or static data
    * Any query that hits the database, will go through the cache first
  * Cache invalidation (using LRU)
    * Cache invalidation is a very rich topic in distributed systems
    * Below is a list of complicated caching technique

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
CDNs are giant data centers that are designed to send large files to requested destination.
CDNs are optimized to deliver large size content

* Way faster than serving content straight from your server.
* Any JS and media files should live on the CDN and be served from there.
  * Bootstrap is heavy
  * JQuery is also another heavy weighted library.
  * Always use CDN to deliver these heavy libraries
* All JS and CSS concatenated together.
  * This is what webpack has done for us
* Your server should return *only* HTML markup.

## Databases
### Types of Database
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

Database is the toughest part to scale. If we can, it's best to avoid the issue altogether and just buy bigger hardware. Web application typically have a read/write ratio of somewhere between 80/20 and 90/10. If we can scale read capacity, we can solve a lot of situations. For read heavy application, master-slave is the answer.

### Master-slave Replication - Data Integrity
Depends on implementation, various system has different approach toward replication but they all come down to the same idea. Whenever a file is written on a database, the master will duplicate this file and distribute the replicas across nodes.

When client requests a file, the master will report to client the location of the file. Client will then directly access the node that is closest to him/her.

For example, this is the Google File System
![gfs]
[gfs]: ../img/gfs.png

### Relational Database
Items are separated into different buckets. However, they are connected by their
keys (foreign and primary.) JOIN is the answer to how to retrieve data in relational database. Items are linked to one another by their relationships.

#### How to scale a relational database
* If you have high read load, then master-slave replication.
* If you have a high write load, then shard.
* Can span many data centers!
* If you have high write load across shards, you're fucked. Stop using a relational DB.

Since you are fucked, now comes the solution
### Database Sharding (Partitioning)
Sharding means splitting the data across multiple machines while ensuring
you have a way of figuring out which data is on which machine.

* Vertical Partition: This is partition by features
* Key-based or Hash-based Partition: This allocates data by hashing them and put
them on different machines but adding additional servers means re-allocating
all the data - very expensive task. Use __consistent hashing__ !
* Directory-based Partition: Maintain a lookup table for where the data can
be found.

### Relational databases are bad at scaling
* Joins are inefficient when databases become humongous, and that's probably
why MongDB called themselves hu-__mongo__ -ous. MongDB is non-relational so they
can get big without a problem.

### Database Denormalization and NoSQL

#### Natural Aggregation
Before one should move on to NoSQl type of database, he/she must decide on what are the typical queries that users submit. For example, a user constantly asks for his own messages. It's wise to nest users' messages underneath the user object in an document store. This way we are avoiding the painfully slow joins of relational databases.

NoSQL's are very hard to "undo" a pattern of query. In SQL, we can always switch joins and submit different queries based on our needs. NoSQL does not offer this kind of flexibility

#### Normalization
What does normalization mean? It means that you don't duplicate data, cause if you have two copies of data and you fail to update one of them. The data-base will have a discrepancy between two pieces of data and they go out of sync.

#### Denormalize
Denormalization means adding redundant information into a database to
speed up reads. For example, a person has pets. In a RDBMS, pets have owner_id
and the person object access the pets through association and JOINs. But
in a denormalized table, the pet information is stored on the persons table.

__Misconception__: NoSQL doesn't mean No SQL at all, it means Not Only SQL. Thus, NoSQL database actually can do JOINs and relational query

#### MongoDB
A NoSQL database stores rows as something that's similar to a JSON object.
NoSQL database does not have tables, it has collections. It means a collection
of objects.

In MongoDB, you have keys and values. The values are JSON. A key is associated
with a giant JSON object. You can still do JOIN in MongoDB but it's a little more
complicated than SQL databases. The key take away is that NoSQL does not follow
an explicit schema.

#### Reddis
Just a key-value store, a giant hash map

#### Cassandra
A distributed giant key-value store.

### Metrics
* Bandwidth: This is the maximum amount of data that can be transferred in
a unit of time. kB/s
* Throughput: This is the actual amount of data that is transferred
* Latency: This is how long it takes data to go from one end to the other. It
is the delay between the sender sending information and the receiver receiving it.
