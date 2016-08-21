# HTTP - HyperText Transfer Protocol

## Standard Question: What happens when you enter google.com into address bar
1. Computer needs to translate hostname www.google.com into an IP address
  * IP - Internet Protocol
2. It needs to perform a domain name look up using a DNS (Domain Name System)
  * DNS servers are everywhere.
  * Google has its own DNS servers
  * College has its own DNS servers
  * Big company has its own DNS servers
3. DNS has a hierarchy: no single node knows all domain name mapping. However,
internet service provider knows some bigger fish and maybe that bigger fish knows
an even bigger fish that knows where the domain name can be found.
4. If the worst happens, no fish knows where your domain name belongs, then there
are root servers which are spread out geographically across several continents
  * root servers know which authority is responsible for keeping track of all domain name purchases
5. Once a valid IP address is found, and a connection is established. An envelop of http requests
will be sent to Google application server.
6. The server receives the packet and respond accordingly to the HTTP method in the header.

### The HTTP Envelop
```
123.123.123.123
GET / HTTP/1.0
http://www.google.com
```
`http://` is known as the schema. It indicates to a piece of software how it should
view the contents at that address

## IP Address
### Private vs Public
Anything starts with 192.168.x.y is typically a private IP address.
Outsiders can not access local host, because typical home modem prevents private
IP address from leaking out to the public because these private IP addresses are not
uniquely identifiable

### Two Protocols (TCP/IP)
IP is a set of conventions that govern how you associate numeric addresses with computers
TCP is the standard that web browsers and web servers speak in order to actually physically
move data or electronically move data from point A to point B using the higher notion
of an IP address to actually uniquely identify points A and B

The number 80 will arbitrarily but consistently identified this service. If you have a
server and you have a website, it is running so to speak on port 80. It's listening on port 80.
You might also have email service. If you want to be able to send email to gmail, you need to use
TCP but on port 25.

### Port Forwarding
If your home network has a public IP address, and you usually get one from your internet service provider.
Your individual laptop on which you've created your final project is that one of these private ip addresses.
What you can do is configure your home router AKA firewall AKA cable modem, it depends on what make
and model you have, but that device, you can configure it to say any internet traffic that comes
from the internet to my home on my public IP address destined for port 80 should be "port forwarded"
to IP address 192.168.x.y port 80. In other words you can tell this machine to take incoming on that port
and route it very specifically to this computer of yours.

Many non-standard ports are blocked for security reason. But it's a joke... all you have to do is
to change the port number to be 80 or 443. 80 is for TCP and 443 is for UDP

## Domain Name
Beside registering a domain name and mapping it to an IP address, every web server should have
at least two DNS server. One is primary and another one is secondary for fail over. This is where
web hosting companies come in. Web hosting companies will provide DNS servers and web server for individuals
who wish to push their code online.
DNS server's database is a giant excel sheet

There are different types of rows. So one of those rows can be an official record that says the name server,
NS, for this domain is whatever IP address web host gave me.

* A - row type a: domain name maps to IP address
* CNAME - alias record: domain name maps to domain name, added extra layer of abstraction
* MX - mail exchange record:

## Shared Web Host

## Virtual Private Servers (VPS)
Shared hardware but not shared software

## Secure Shell (SSH)
A way to connect to a remote server and execute commands on it

## DHCP
Dynamic Host Configuration Protocol -  dynamically distributing network configuration parameters,
such as IP addresses for interfaces and services. 
