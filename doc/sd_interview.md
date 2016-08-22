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
