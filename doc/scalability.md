

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

## Database Sharding(Partitioning)
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
