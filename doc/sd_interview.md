# System Design Interview
## Examples
* Design a URL shortening service like bit.ly
* Implement Google Search
* Design a client-server application which allows people to play chess with one another
* How would you store relations in a social network like Facebook and implement a feature
where one user receives notifications when their friends like the same thing as they do?

## System Design Process
### Step 1 Constraints and use cases
The very first thing to do with any system design question is to clarify the system's
constraints and to identify what use cases the system needs to satisfy. Spend a few
minutes questioning your interviewer and agreeing on the scope of the system.

For example, the URL shortening service could be meant to be serve just a few
thousand users, but each could be sharing millions of URLs. It could be meant to
handle millions of clicks on the shortened URLs or dozens. The service may have
to provide extensive statistics about each shrotened URL.

```
Use cases:
1. Shortening: take a url => return a much shorter url
2. Redirection: take a short url => re-direct to the original url
3. Custom url
4. High availability of the system

Out of scope:
4. Analytics
5. Automatic link expiration
6. Manual link removal
7. UI vs API

Constraints:
Large percentage of URL shortening usage is driven by tweets
1.5 billion new tweets per month
All shortened URLs per month: 1.5 billion
Sites below the top 3: shorten 300 million per month

1. 100 million new urls per month
2. 1 billion requests per month
3. 10% from shortening and 90% from redirection
4. Requests per second: 400+ (40 shortens, 360 redirects approximately)
5. 6 billion URLS in 5 years
6. 500 bytes per URL
7. 6 bytes per hash

So we will have 3000 billion bytes for URL, 3TB for all urls and 36 GB for all hashes (over 5 years)
New data written per second: 40*(500 + 6): 20 KB/s
Read data per second: 360*506 bytes: 180KB/s
```

### Step 2 Abstract design
Once you've scoped the system you're about to design, you should continue by outlining
a high-level abstract design. The goal is to outline all the important components that the
architecture will need.

1. Application service layer: (serves the requests)
  * Shortening service
  * Redirection service
2. Data storage layer (keeps track of the hash => url mappings)
  * Acts like a big hash table
  * Stores new mapping and retrieves a value given a key

### Step 3 Understanding bottlenecks
Most likely your high level design will have one or more bottlenecks given the
constraints of the problem. You are not expected to design a system from ground up,
which immediately handles all the load in the world. It just needs to be scalable.

Now that you have your high level design, start thinking about what bottlenecks it has.
Perhaps your system needs a load balancer and many machines behind it to handle the user
requests. Or maybe the data is so huge that you need to distribute your database
on multiple machines.

```
Bottlenecks:
Traffic is not going to be hard
Data is the only concern, we need to index directly into the url we need.
```

### Step 4 Scaling your abstract design
Time to make it scale!

#### Everything is a trade off
This is the one of the most fundamental concepts in system design.

There rarely is one perfect way to do things. Each company ends up with
a different architecture. Designing a scalable system is an optimization task;
there are tons of constraints (time, budget, knowledge, complexity, technologies currently
available, etc...) Every technology, every pattern is great for somethings, and not
so great for others. Understanding these props and cons, the advtanges
and disadvantages, is the key.

Being able to understand and discuss these trade-offs is what system design
is all about.

Going back to the URL shortening example:

Scalable Design:
1. Application Service Layer
  * Start with one machine
  * Add a load balancer and a cluster of machines over time
    * Usually there's spike in traffic. We can activate the cluster when
    we experience a spike in traffic but then we turn it off when the spike
    is gone
  * We need to add redundancy because we expect high availability

2. Data Storage Layer
  * We have the following requirements:
    * Billion of objects
    * Each object is fairly small
    * There are no relationships between the objects
    * Reads are 9x more frequent than writes
    * 3TB of urls, 36GB of hashes
  * MySQL:
    * Widely used
    * Mature technology
    * Clear scaling paradigms (sharding, master/slve replication, master/master replication)
    * Used by Facebook, Twitter, Google, and etc...
    * Index lookups are very fast
  * Approach and Design:
    * Mapping
      * hash: varchar(6) - we only need 6 characters for the shortened URL
      * original_url: varchar(512)
    * Create an unique index on the hash (36GB+) and we want to call it in memory
      * We have two options
        1. Vertical scaling: increase the memory on the data server.
        2. Horizontal scaling: partition the data into multiple disk spaces. It's good to have a
        good partition strategy early on. As the site gets more popular, it will be easy
        to add more machines to scale horizontally.
      * In case this skyrockets so hard, we need to do master-slave replications. We will
      direct read to slaves and direct writes to master
    * Strategy:
      * Start off with vertical scaling, just buy more hardware and stack it on
      * Eventually, we will hit the ceiling, we then partition the data by taking
      the first character of the shortened url and converted it to ascii code, mod it
      by the number of partitions, put it there. (Perhaps we will need consistent hashing technique soon)
      * Then we will need to seek a master-slave setup at the very end. 
