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
* Horizontal: increase the number of nodes or servers


## Load Balancer
The role of a load balancer is to distribute and direct requests evenly
to all the servers.

When request comes in, the DNS will map domain name to IP address of the black box
load balancer. The servers within the cluster don't have public IP address assigned
to themselves. Rest of the world won't be able to interact with the servers inside
the cluster directly. The load balancer is responsible for distributing the HTTP
requests to one of the nodes in its cluster.

The most obvious method of load balancing is hashing.
* Every server is a bucket
* Every request that comes in can be represented IP address
* Hash the IP address and mod the integer by the number of servers
* Direct request to the bucket

However, as you increase the number of servers over time, requests will get to
directed to different machine. This can potentially create problems for some
applications such as applications that rely on sharding to reduce write load.
Thus, use consistent hashing technique.

__Consistent Hashing__ is needed for balancing loads when servers are constantly added and removed.

What if a load balancer goes down?
  * We need fail over, thus more load balancers. Load balancers are generally very expensive.
  We will only need a couple of them as back ups.

Essentially load balancer is a fancy DNS server with built-in logic that distributes load.
The most direct and naive solution to load balancing is *round robin*. However, smarter solution
does exist and we do need them.

Example of LB Software & Hardware:
* Software
  * ELB
  * HAProxy
  * LVS

* Hardware
  * Barracuda
  * Cisco
  * Citrix
  * F5

### Potential Problem
There is a potential problem with load balancing using round robin DNS technique.
Remember that browser will typically cache the http response from servers and record
the IP address in cookies, so when user tries to re-visit the same website, the broswer
does not need to submit a DNS lookup to DNS server. Just by bad luck, server A gets
a power user, who consumers considerable amount of computational resources. Using round robin DNS,
other users may still get distributed to server A and eventually create a heavy load on server A.

Thus, in this case, caching is contributing to a disproportionate amount of load
across servers. We need a smart solution. We need to re-configure our load balancer so
that all traffic will be directed to a single IP address, which is the address of the
master load balancer. The load balancer will then use other heuristics to decide
which server/node it should send the request to, perhaps based on usage and server load.

### Sticky Session
Before we consider a distributed database management system, we should take a look at a simple
architecture.

![load]
[load]: ../img/load.png

Not all applications are truly stateless. Some of them do store states locally in memory
in the application server layer. So despite HTTP being "stateless" protocol, many applications
that store state locally don't perform well in a load-balanced environment. Also, some application
servers have databases integrated. Databases don't communicate with each other. Thus, data become
desynchronized when user gets distributed to a new place every time he/she makes a request to
visit the website.

Then now sticky session comes into play. Sticky session makes load balancer distributes users
back to the servers where they had sessions opened. But... ultimately we should stick to
stateless services. DON'T STORE SESSION STATES ON APPLICATION SERVERS!

If session state is very painful to lose (e.g. shopping carts), store it in a central database and
clear out old sessions periodically. If session state is not critical (e.g. username/avatar URL),
then stick it in a cookie-- just make sure you're not shoving too much data into the cookie.



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
* Resque
  * Resque (pronounced like "rescue") is a Redis-backed library for creating background jobs, placing those jobs on multiple queues, and processing them later.
* Sidekiq
  * Simple, efficient background processing for Ruby.

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

Redis and MemcacheD are the popular choices for caching layer
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

Here are some complicated caching

* Write-through cache
  * Pro - It directs write I/O onto cache and update data in the database level. It keeps cache and backend data consistent
  * Con - even though it is slow to write to the database level, latency isn't the issue because write to and read from the cache are fast. The real problem is bandwidth. It puts a limit on how many items you can write to the persistent storage layer.
  * Write-through cache is good for applications that write and then re-read data frequently as data is stored in cache and results in low read latency but it isn't ideal for write heavy applications.


* Write-back cache
  * Pro - I/O is directed to cache and completion is immediately confirmed to the server. Modification in the cache are not copied to the database until absolutely necessary. This results in low latency and high throughput for write-intensive applications.
  * Con - Backend data and cache are not consistent and in the event of hardware failure, all newly obtained data are lost because the cache didn't have a chance to copy them to the databse

* Sideline cache

There are two patterns of caching your data, an old one and a new one:

1. Cached Database Queries
  That's still the most commonly used caching pattern. Whenever you do a query to your
  database, you store the result dataset in cache. A hashed version of your query is the
  cache key. The next time you run the query, you first check if it is already in the cache.
  This pattern has several issues. The main issue is the expiration. It is hard to
  delete a cached result when you cache a complex query.

2. Cached Objects
  In general, see your data as an object like you already do in your code. Let your
  class assemble a dataset from your database and then store the complete instance
  of the class or the assembled dataset in the cache. You have, for example, a class
  called "Product" which has a property called "data". It is an array containing prices,
  texts, pictures, and customer reviews of your product. The property "data" is filled
  by several methods in the class doing several database requests which are hard to cache, since
  many things relate to each other. Now do the following: when your class has finished the
  "assembling" of the data array, directly store the data array, or better yet, the
  complete instance of the class, in the cache! This allows you to easily get rid of
  the object whenever something did change and makes the overall operation of your code
  faster and more logical.

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

### Relational Database
Items are separated into different buckets. However, they are connected by their
keys (foreign and primary.) JOIN is the answer to how to retrieve data in relational database.
Items are linked to one another by their relationships.

If you want your application to handle a lot of complicated querying, database transactions, and routine analysis of data, you want to stick with a relational database. If your application is going to focus on doing many database transactions, it's important that those transactions are processed reliably. This is where ACID really matters.

#### How to scale a relational database
* If you have high read load, then master-slave replication.
  * Use more slaves if read is monstrously heavy.
* If you have a high write load, then shard.
  * Distribute write across many servers
* Buy more data centers!
  * Lastly, just throw money at it

### Master-Slave (READ)
Depends on implementation, various system has different approach toward replication but they all come down to the same idea. Whenever a file is written on a database, the master will duplicate this file and distribute the replicas across nodes.

When client requests a file, the master will report to client the location of the file. Client will then directly access the node that is closest to him/her.

For example, this is the Google File System
![gfs]
[gfs]: ../img/gfs.png

This is a typical topology for read heavy architecture

![archi]
[archi]: ../img/archi.png

If three slaves are not enough to handle the amount of read requests, then we can opt for more
slaves and distribute load evenly across them. However, there's a cost.
The replication part will be expensive. If we have n slaves, then the write will be
multiplied by the factor of n.

### Database Sharding and Partitioning (WRITE)
Sharding means splitting the data across multiple machines while ensuring
you have a way of figuring out which data is on which machine. This is a method of
distributing write across many servers. For example, let's say we have 1 million users.
Each person is writing 1 Mb per second. Then we will have 1,000,000 Mb/s to our databases.
The only way to speed is up divide this 1,000,000 into many small shards. Perhaps, 1,000
databases each handles 1000 Mb/s. By the way, 1,000,000 Mb/s is ridiculously big.

* Vertical Partition: This is partition by features
* Key-based or Hash-based Partition: This allocates data by hashing them and put
them on different machines but adding additional servers means re-allocating
all the data - very expensive task. Use __consistent hashing__ !
* Directory-based Partition: Maintain a lookup table for where the data can
be found.

![partition]
[partition]: ../img/partition.png

### Relational databases are bad at scaling write
Traditional ACID-compliant databases like RDBSM can scale reads using master-slave approach, but due to constraints imposed by the ACID principle, scaling write is very difficult.

* Atomicity means that transactions must complete or fail as a whole, so a lot of bookkeeping must be done behind the scenes to guarantee this. For example, suppose you run an online book store and you proudly display how many of each book you have in your inventory. Every time someone is in the process of buying a book, you lock part of the database until they finish so that all visitors around the world will see accurate inventory numbers.

* Consistency constraints mean that all nodes
in the cluster must be identical. If you write to one node, this write must be copied to all other nodes before returning a response to the client. This makes a traditional RDBMS cluster hard to scale.

* Durability constraints mean that in order to never lose a write you must ensure that before a response is returned to the client, the write has been flushed to disk.

To scale up write operations or the number of nodes in a cluster beyond a certain point you have to be able to relax some of the ACID requirements:

* Dropping atomicity lets you shorten the time tables (sets of data) are locked. Example: MongoDB, CouchDB
* Dropping consistency lets you scale up writes across cluster nodes. Example: Riak, Cassandra
* Dropping durability lets you respond to write commands without flushing to disk. Examples: MemCacheD, Redis.

There is a computer science theorem that quantifies the inevitable trade-offs. Eric Brewer's CAP theorem states that if you want consistency, availability, and partition tolerance, you have to settle for two out of three. For a distributed system, partition tolerance means the system will continue to work unless there is a total network failure.

BASE:
  * Basic Availability
  * Soft-state
  * Eventual consistency

Few notes: JOINs are not inherently slow if done correctly. However, as table size gets really big. De-normalization is probably the way to go. However, it's a deep rabbit hole. Relational databases are designed to do complex queries really well. If one opts to de-normalization, he/she will lose the flexibility to do complex queries in the future.

### Database Denormalization
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

| Pros of Denormalization                     | Cons of Denormalization                       |
| ------------------------------------------- | --------------------------------------------- |
| Fast data retrieval since we do fewer joins | Updates and inserts are more expensive        |
| Simpler queries, fewer tables               | Update and insert code are difficult to write |
|                                             | Data may become inconsistent                  |
|                                             | Redudancy leads to more space usage           |

__Misconception__: NoSQL doesn't mean No SQL at all, it means Not Only SQL. Thus, NoSQL database actually can do JOINs and relational query

### NoSQL
If you're dealing with phenomenally huge amount of data, it can be too tedious and the probability of error increases. In that situation, you may need to consider going with a non-relational database. A non-relational database just stores data without explicit and structured mechanisms to link data from different tables to one another.

#### MongoDB
A NoSQL database stores rows as something that's similar to a JSON object.
NoSQL database does not have tables, it has collections. It means a collection
of objects.

In MongoDB, you have keys and values. The values are JSON. A key is associated
with a giant JSON object. You can still do JOIN in MongoDB but it's a little more
complicated than SQL databases. The key take away is that NoSQL does not follow
an explicit schema.

##### Advantage
One of the biggest advantage in going with non-relational database is that your database
is not at risk for SQL injection attacks, because non-relational database don't use SQL
and are for the most part schema-less. Another major advantage, at least with Mongo, is that
you can theoretically shard it forever. Sharding distributes the data across partitions
to overcome hardware limitations.

#### Disadvantage
In non-relational databases like Mongo, there are no joins like there would be in relational databases. This means you need to perform multiple queries and join the data manually within your code -- and that can get very ugly, very fast.

Since Mongo doesn’t automatically treat operations as transactions the way a relational database does, you must manually choose to create a transaction and then manually verify it, manually commit it or roll it back.


#### More Examples
* Reddis - k-v store, a giant hash map
* Cassandra - a distributed giant k-v store

## Metrics
* Bandwidth: This is the maximum amount of data that can be transferred in
a unit of time. kB/s
* Throughput: This is the actual amount of data that is transferred
* Latency: This is how long it takes data to go from one end to the other. It
is the delay between the sender sending information and the receiver receiving it.

## Facebook Design
* Each user has a friend array
* News Feed triggers a read for every single one of your friend
* Facebook has a 5,000 friend limit because this method cannot scale
* Reading is expensive, writing is cheap.

## Twitter Design
[Twitter System Design]
* Each user has a list of feed
  * the feed contains an array of tweet id
* Every time a user sends out a feed, the feed will be written to every single follower of
that user. This is a massive write-operation
* Writing is expensive, reading is cheap

[Twitter System Design]:https://highscalability.com/blog/2013/7/8/the-architecture-twitter-uses-to-deal-with-150m-active-users.html
