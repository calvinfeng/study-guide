# Real Life Examples

## Instagram
### Core Principles
* Keep it very simple
* Don't re-invent the wheel
* Go with proven and solid technologies when you can

### Operating System
Ubuntu Linux 11.04 ("Natty Narwhal") on Amazon EC2 servers. Amazon EC2(Elastic Compute Cloud)
is a virtual server hosting service.

### Load Balancing
Instagram used to run 2 NGINX machines and DNS Round-Robin between them. The downside of this
approach is the time it takes for DNS to update in case one of the machines needs to get
decomissioned. Now (as in 2012) Instagram has moved to using Amazon Elastic Load Balancer
with 3 NGINX instances behind it that can be swapped in and out.

### Application Servers
Instagram runs Django on Amazon High-CPU Extra Large machines. The work load is very
CPU-bound rather than memory-bound, so the High-CPU Extra-Large instance type provides
the right balance of memory and CPU.

### Data Storage
Most of Instagram's data lives in PostgreSQL. Instagram chose to shard its data using
PostgreSQL as opposed to using NoSQL. The main shard cluster involves 12 Quadruple Extra-Large
memory instances (and twelve replicas in a different zone.)

All of the PostgreSQL instances run in a master-replica setup using Streaming Replication,
and they use EBS snapshotting to take frequent backups of the systems.

The photos themselves go straight to Amazon S3, which currently stores several terabytes
of photo data for Instagram. They use Amazon CloudFront as CDN, which helps with image load
times from users around the world (like in Japan, second most popular country)

They use Redis extensively, it powers their main feed, activity feed, session system,
and other related systems. All of Redis' data needs to fit in memory, so we end up
running several Quadruple Extra-Large memory instances for Reddis, too, and occasionally
shard across a few Redis instances for any given subsystem. They run Redis in a master-replica
setup and have the replicas constantly saving the DB out to disk, and finally use
EBS snapshots to back those DB dumps.

(Redis is an open source, in-memory data structure store, used as database, cache,
  and message broker.)

### Task Queue
When a user decides to share out an Instagram photo to Twitter or Facebok, or when we need
to notify one of the Real-time subscribers of a new photo posted, they push that task into
Gearman, a task queue system originally written at Danga. Doing it asynchronously through
the task queue means that media uploads can finish quickly, while the heavy lifting can
run in the background. They have about 200 workers all written in Python, consuming
the task queue at any given time.

## CinchCast
### Stats
* Over 50 million page views a month
* 50,000 hours of audio content created
* 15,000,000 media streams
* 175,000,000 ad impressions
* Peak rate of 40,000 concurrent requests per second
* Many TB/day of data stored in MSSQL, Redis, and ElasticSearch clusters
* Team of 10 engineers
* Around a 100 hardware nodes in production

### Data Centers
* Amazon EC2 instances are used mostly for QA and Staing environments
* Product website is run from the data center in Brooklyn.

### Hardware
* About 50 web servers
* 15 Microsoft SQL database servers
* 2 Redis NoSQL k-v servers
* 2 Node.js servers
* 2 servers for elastic search cluster

### Approach
* Be brief, be bright, be gone
* Don't go chaasing hot technologies
* Achieve essential then worry about excellent
* Be a "how" team
* Build security into the software development life-cycle

### Architecture
* All JavaScript, CSS, and images are cached at the CDN level. The DNS points to a CDN
which passes requests to origin servers.
* Separate cluster of web servers is used to serve requests for regular users and
requests for for ad users, differentiated by a cookie.
* Moving toward service-oriented architecture where key pieces of the system, such as
search, authentication, caching, are RESTful services implemented in various
languages. These services also provide a caching layer.
* Redis NoSQL k-v store (redis.io) is used as cache layer before database calls.
* Scaleout is used to maintain a session state across a garden of web servers.

## YouTube
### Platform
* Apache
* Python
* Linux (SuSe)
* MySQL
* Psyco, a dynamic Python to C compiler
* LightTPD for video instead of Apache

### Stats
* Supports the delivery of over 100 million videos per day
* Founded Feb, 2005
* March 2006 30 million video views/day
* July 2006 100 million video views/day
* 2 system admins, 2 scalability software architects
* 2 feature developers, 2 network engineers, 1 DBA

### Web Servers
* NetScalar is used for load balancing and caching static content
* Run Apache with mod_fast_cgi
* Requests are routed for handling Python application server
* Application server talks to various databases and other informations sources to
get all the data and formats the html page
* Can usually scale web tier by adding more machines

### Video Serving
* Each video hosted by a mini-cluster. Each video is served by more than one machine.
* using a cluster means:
  * More disks serving content which means more speed.
  * Headroom, if a machine goes down, others can take over.
  * There are online backups.
* Servers use lightTPD web server for video:
  * Apache had too much overhead
  * Uses epoll to wait on multiple fds
  * Switch from single process to multiple process configuration to handle more connections.
* Most popular content is moved to a CDN
  * CDNs replicate content in multiple places.
  * CDN machines mostly serve out of meomory because the content is so popular there's
  little thrashing of content into and out of memory.
* Less popular content (1~20 views per day) uses YouTube servers in various colo sites.
  * There's a long tail effect. A video may have a few plays but lots of videos are being
  played. Random disks blocks are being accessed.

### Databases
1. The Early Years
  * MySQL to store meta data like users, tags, and descriptions
  * Serve data off a monolithic RAID 10 Volume with 10 Disks
  * Common evolution: single server, went to a single master with multiple read slaves,
  then partitioned the database, and then settled on a sharding approach.
  * Suffered from a replica lag. The master is multi-threaded and runs on a large machine
  so it can handle a lot of work. Slaves are single threaded and usually run on lesser
  machines and replication is asynchronous, so the slaves can lag significantly behind the
  master.
  * Using a replicating architecture, you need to spend a lot of money for incremental bits
  of write performance.
  * One of their solutions was to prioritize traffic by splitting the data into two clusteres:
  a video watch pool and a general cluster. The idea is that people want to watch video
  so that function should get the most resources. The social networking features of
  YouTube are less important so they can be routed to a less capable cluster.

2. The Later Years:
  * Database partitioning
  * Split into shards with users assigned to different shards
  * Spreads writes and reads
  * Much better cache locality which means less IO
  * Resulted in a 30% hardware reduction
  * Reduced replica lag to 0
  * Can now scale database almost arbitrarily

### Lessons Learned
1. Stall for time
2. Priortize
3. Pick your battles - don't be afraid to outsource some essential services
4. Keep it simple
5. Shard - Sharding helps to isolate and constrain storage, CPU, memory, and IO. It's not
just about getting more writes performance
6. Constant iteration on bottlenecks:
  * Software: Database, Caching
  * OS: Disk I/O
  * Hardware: Memory, RAID

## Twitter






## Linkedin
### The Early Years
#### Leo
Linkedin started as a single monolithic application. That single app was called Leo.
It hosted web servlets for all the various pages, handled business logic, and connected
to a handful of Linkedin databases.

#### Member Graph - Cloud
One of the first things to do as a social network is to manage member to member connections.
Linkedin needed a system that queried connection data using graph traversals and lived
in-memory for top efficiency and performance. With this different usage profile,
it was clear that it needed to scale independently of Leo, so a separate system
for its member graph called *Cloud* was born, Linkedin's first service. To keep this
graph service separate from Leo, we used Java RPC for communication.

It was around this time, Linkedin needed a search capabilities. The member graph
service started feeding data into a new search service running Lucene.

#### Replica read DBs
As the site grew, so did Leo, increasing its role and responsibility, and naturally
increasing its complexity. Load balancing helped as multiple instances of Leo were
spun up. But the added load was taxing Linkedin's most critical system - its member profile database.

The profile database handled both read and write traffic, and so in order to scale,
replica slave DBs were introduced. The replica DBs were a copy of the member database,
staying in sync using the earliest version of databus. They were set up to handle all
read traffic and logic was built to know when it was safe (consistent) to read from
a replica versus the main master DB.

As the site began to see more and more traffic, the single monolithic app Leo was
often going down in production, it was difficult to troubleshoot and recover, and
difficult to release new code. High availability is critical to Linkedin. So Leo needs to die.
Linkedin needed to kill Leo and break it up into many small functional and stateless
services.

#### Service Oriented Architecture (SOA)
Engineering started to extract micro services to hold API's and business logic like
search, profile, communications, and groups platforms. Later, the presentation layers
were extracted for areas like recruiter product or product profile. For new products,
brand new services were created outside of Leo. Over time, the vertical stacks emerged
for each functional area.

Linkedin built frontend servers to fetch data models from different domains, handle
presentation logic, and build the HTML (via JSPs.) Linkedin built mid-tier services
to provide API access to data models and backend data services to provide consistent
access to its databases. By 2010, Linkedin already had over 150 separate services. Today
Linkedin has over 750 services.

![linkedin]
[linkedin]: https://content.linkedin.com/content/dam/engineering/en-us/blog/migrated/arch_soa_0.png

Being stateless, scaling could be achieved by spinning up new instances of any of the
services and using hardware load balancers between them. Linkedin actively started
to redline each service to know how much load it could take, and built out early
provisioning and performance monitoring capabilities.

#### Caching
Linkedin was seeing hypergrowth and needed to scale further. Many applications started
to introduce mid-tier caching layers like MemCache or CouchBase. LinkedIn also added
caches to its data layers and started to use Voldemort with precomputed results when
appropriate.

Over time, Linkedin actually removed many mid-tier caches. Mid-tier caches were storing
derived data from multiple domains. While caches appear to be a simple way to reduce
load at first, the complexity around invalidation and the call graph was getting
out of hand. Keeping the cache closest to the data store as possible keeps latencies
low, allow them to scale horizontally, and reduces the cognitive load.

#### Kafka
To collect its growing amount of data, LinkedIn developed many custom data pipelines
for streaming and queueing data. For example, they needed their data to flow into data warehouse,
they needed to send batches of data into their Hadoop workflow for analytics.

As the site grew, more of these custom pipelines emerged. As the site needed to scale,
each individual pipeline needed to scale. The result was the development of Kafka, a
distributed pub-sub messaging platform. Kafka became a universal pipeline, built around
the concept of a commit log, and was built with speed and scalability in mind. It enabled
near real time access to any data source, empowered their Hadoop jobs, allowed them to
build realtime analytics.

![kafka]
[kafka]: https://content.linkedin.com/content/dam/engineering/en-us/blog/migrated/kafka.png

### The Modern Years
#### Rest.li
When Linkedin transformed from Leo to a service oriented architecture, the APIs they
extracted assumed Java-based RPC, were inconsistent across teams, were tightly coupled
with the presentation layer, and it was only getting worse. To address this, they
built out a new API model called Rest.li. Rest.li was their move toward a data model
centric architecture, which ensured a consistent stateless RESTful API model across
the company.

By using JSON over HTTP, their new APIs finally made it easy to have non-Java-based clients.
LinkedIn today is mainly a Java shop, but also has many clients utilizing Python,
Ruby, Node.js and C++ both developed in house as well as from tech stacks of their
acquisitions. Moving away from RPC also freed them from high coupling with presentation
tiers and many backwards compatiability problems.

Today, LinkedIn has over 975 Rest.li resources and over 100 billion Rest.li calls per day
across all data centers.

#### Super Blocks
Service oriented architectures work well to decouple domains and scale services
independently. But there are downsides. Many of their applications fetch many types of different
data, in turn making hudnreds of downstream calls. This is typically referred to as a
"call graph" or "fanout" when considering all the many downstream calls.

For example, any Profile page request fetches much more beyond just profile data
including photos, connections, groups, subscription info, following info,
long form blog posts, connection degrees from graph, recommendations, and etc...

LinkedIn introduced the concept of a super block - grouping backend services with a single
access API. This allows them to have a specific team optimize the block while keeping their
call graph in check for each client.
