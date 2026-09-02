# Networking fundamentals

These commands were executed on the submission host on 2 September 2026. Addresses and routes change between networks, so the output is evidence from one run rather than values to copy.

The homework refers to a separately shared `devops-hero` repository without giving its URL. This exercise covers the standard Linux/networking command set independently and records both commands and observed results.

## `hostname` — identify the machine

```bash
$ hostname
Dibyos-MacBook-Air.local
```

The hostname is the device's human-readable name on a network.

## `ip addr` / `ifconfig` — inspect interfaces and addresses

Linux command: `ip -brief address`. Equivalent command used on macOS: `ifconfig`.

```text
lo0: 127.0.0.1
en0: 172.20.10.13
```

`lo0` is loopback. `en0` held the private IPv4 address used on the local network.

## `ip route` / `route` — inspect routing

Linux command: `ip route`. Equivalent command used on macOS: `route -n get default`.

```text
gateway: 172.20.10.1
interface: en0
```

The default gateway receives packets whose destination is not covered by a more-specific route.

## `nslookup` and `dig` — query DNS

```bash
$ nslookup github.com
Server:  fe80::a078:2dff:fe06:3964%11
Non-authoritative answer:
Name: github.com
Address: 20.207.73.82

$ dig +short github.com
20.207.73.82
```

DNS translates the domain name into an address. `dig` exposes more DNS detail; `nslookup` is convenient for a quick lookup.

## `ping` — test IP reachability and latency

```text
$ ping -c 3 1.1.1.1
3 packets transmitted, 3 packets received, 0.0% packet loss
round-trip min/avg/max/stddev = 26.002/39.740/52.956/11.010 ms
```

ICMP echo replies prove that the target was reachable during the test and provide round-trip timing. A failed ping does not always mean a host is down because firewalls can block ICMP.

## `traceroute` — view the path toward a destination

```text
$ traceroute -m 4 -w 1 github.com
traceroute to github.com (20.207.73.82), 4 hops max
1  172.20.10.1  5.415 ms  3.477 ms  3.061 ms
2  * * *
3  192.168.116.18  62.729 ms  37.024 ms  20.629 ms
4  * * *
```

Each hop is a router along the route. Asterisks mean no probe response arrived before timeout; they do not necessarily mean traffic stopped.

## `curl` — test an application endpoint

```text
$ curl -I https://github.com
HTTP/2 200
content-type: text/html; charset=utf-8
strict-transport-security: max-age=31536000; includeSubdomains; preload
```

The `200` status confirms that DNS, TCP, TLS, and HTTP all completed successfully.

## `ss` / `netstat` / `lsof` — inspect sockets

Linux command: `ss -lntup`. Equivalent command used on macOS: `lsof -nP -iTCP -sTCP:LISTEN`.

```text
COMMAND    USER                NAME
rapportd   dibyochakraborty    TCP *:59077 (LISTEN)
ControlCe  dibyochakraborty    TCP *:7000 (LISTEN)
ControlCe  dibyochakraborty    TCP *:5000 (LISTEN)
```

Listening sockets show which local processes are ready to accept connections and on which ports.

## `arp` / `ip neigh` — inspect local neighbor resolution

Linux command: `ip neigh`. Equivalent command used on macOS: `arp -a`.

```text
? (172.20.10.1) at a2:78:2d:6:39:64 on en0
? (172.20.10.13) at 16:55:0:f6:73:2b on en0 permanent
```

The neighbor cache maps local-network IP addresses to link-layer MAC addresses.

## Additional Linux practice commands

```bash
ip -brief link                  # link state
ip -brief address               # assigned addresses
ip route                        # routing table
ss -lntup                       # listening TCP/UDP sockets and owners
curl -v https://example.com     # verbose DNS/TCP/TLS/HTTP transaction
dig github.com A                # IPv4 DNS records
dig github.com AAAA             # IPv6 DNS records
nc -vz github.com 443           # test one TCP port
```

