# Port-Scanner:

</br>

```ruby
Compiler    : Delphi10 Seattle, 10.1 Berlin, 10.2 Tokyo, 10.3 Rio, 10.4 Sydney, 11 Alexandria, 12 Athens
Components  : None
Discription : Port Scanner
Last Update : 09/2025
License     : Freeware
```

</br>

A port scanner is an application designed to probe a server or host for open ports. Such an application may be used by administrators to verify security policies of their networks and by attackers to identify [network services](https://en.wikipedia.org/wiki/Network_service) running on a [host](https://en.wikipedia.org/wiki/Host_(network)) and exploit vulnerabilities.

A port scan or portscan is a process that sends client requests to a range of server port addresses on a host, with the goal of finding an active port; this is not a nefarious process in and of itself. The majority of uses of a port scan are not attacks, but rather simple probes to determine services available on a remote machine.

To portsweep is to scan multiple hosts for a specific listening port. The latter is typically used to search for a specific service, for example, an [SQL-based](https://en.wikipedia.org/wiki/SQL) [computer worm](https://en.wikipedia.org/wiki/Computer_worm) may portsweep looking for hosts listening on TCP port [1433](https://de.wikipedia.org/wiki/Microsoft_SQL_Server).

</br>

![Port Scanner](https://github.com/user-attachments/assets/f414d3db-699b-4227-b457-29b634a1ba47)

</br>

### TCP/IP basics:
The design and operation of the Internet is based on the [Internet Protocol Suite](https://en.wikipedia.org/wiki/Internet_protocol_suite), commonly also called TCP/IP. In this system, network services are referenced using two components: a host address and a port number. There are 65535 distinct and usable port numbers, numbered 1 … 65535. (Port zero is not a usable port number.) Most services use one, or at most a limited range of, port numbers.

Some port scanners scan only the most common port numbers, or ports most commonly associated with vulnerable services, on a given host.

The result of a scan on a port is usually generalized into one of three categories:

* Open or Accepted: The host sent a reply indicating that a service is listening on the port.
* Closed or Denied or Not Listening: The host sent a reply indicating that connections will be denied to the port.
* Filtered, Dropped or Blocked: There was no reply from the host.

Open ports present two vulnerabilities of which [super administrators](https://en.wikipedia.org/wiki/System_administrator) must be wary:

* Security and stability concerns associated with the program responsible for delivering the service - Open ports.
* Security and stability concerns associated with the operating system that is running on the host - Open or Closed ports.
* Filtered ports do not tend to present vulnerabilities.

</br>

### Notable well-known Port Numbers:

| Port | Assignment | 
| :----: | :--------: | 
| 20     | [File Transfer Protocol](https://en.wikipedia.org/wiki/File_Transfer_Protocol) (FTP) Data Transfer |
| 21     | File Transfer Protocol (FTP) Command Control |
| 22     | [Secure Shell](https://en.wikipedia.org/wiki/Secure_Shell) (SSH) Secure Login |
| 23     | [Telnet remote login service](https://en.wikipedia.org/wiki/Telnet), unencrypted text messages |
| 25     | [Simple Mail Transfer Protocol](https://en.wikipedia.org/wiki/Simple_Mail_Transfer_Protocol) (SMTP) email delivery |
| 53     | [Domain Name System](https://en.wikipedia.org/wiki/Domain_Name_System) (DNS) service |
| 67, 68 | [Dynamic Host Configuration Protocol](https://en.wikipedia.org/wiki/Dynamic_Host_Configuration_Protocol) (DHCP) |
| 80     | [Hypertext Transfer Protocol](https://en.wikipedia.org/wiki/HTTP) (HTTP) used in the World Wide Web |
| 110    | [Post Office Protocol](https://en.wikipedia.org/wiki/Post_Office_Protocol) (POP3) |
| 119    | [Network News Transfer Protocol](https://en.wikipedia.org/wiki/Network_News_Transfer_Protocol) (NNTP) |
| 123    | [Network Time Protocol](https://en.wikipedia.org/wiki/Network_Time_Protocol) (NTP) |
| 142    | [Internet Message Access Protocol](https://en.wikipedia.org/wiki/Internet_Message_Access_Protocol) (IMAP) Management of Digital Mail |
| 161    | [Simple Network Management Protocol](https://en.wikipedia.org/wiki/Simple_Network_Management_Protocol) (SNMP) |
| 194    | [Internet Relay Chat](https://en.wikipedia.org/wiki/IRC) (IRC) |
| 443    | [HTTP Secure](https://en.wikipedia.org/wiki/HTTP_Secure) (HTTPS) HTTP over TLS/SSL |
| 445    | Microsoft-DS [SMB](https://de.wikipedia.org/wiki/Server_Message_Block) shares (also known as the free implementation [Samba](https://de.wikipedia.org/wiki/Samba_(Software))) |
| 546, 547 | [DHCPv6](https://en.wikipedia.org/wiki/DHCPv6) IPv6 version of DHCP |

</br>

### TCP Scanning:
The simplest port scanners use the operating system's network functions and are generally the next option to go to when SYN is not a feasible option (described next). [Nmap](https://en.wikipedia.org/wiki/Nmap) calls this mode connect scan, named after the Unix connect() system call. If a port is open, the operating system completes the TCP three-way handshake, and the port scanner immediately closes the connection to avoid performing a [Denial-of-service](https://en.wikipedia.org/wiki/Denial-of-service_attack) attack. Otherwise an error code is returned. This scan mode has the advantage that the user does not require special privileges. However, using the OS network functions prevents low-level control, so this scan type is less common. This method is "noisy", particularly if it is a "portsweep": the services can log the sender IP address and [Intrusion detection systems](https://en.wikipedia.org/wiki/Intrusion_detection_system) can raise an alarm.

### SYN Scanning:
[SYN](https://en.wikipedia.org/wiki/Transmission_Control_Protocol#Connection_establishment) scan is another form of TCP scanning. Rather than using the operating system's network functions, the port scanner generates raw IP packets itself, and monitors for responses. This scan type is also known as "half-open scanning", because it never actually opens a full TCP connection. The port scanner generates a SYN packet. If the target port is open, it will respond with a SYN-ACK packet. The scanner host responds with an RST packet, closing the connection before the handshake is completed.[3] If the port is closed but unfiltered, the target will instantly respond with an RST packet.

### UDP Scanning:
UDP scanning is also possible, although there are technical challenges. [UDP](https://en.wikipedia.org/wiki/User_Datagram_Protocol) is a [connectionless protocol](https://en.wikipedia.org/wiki/Connectionless_communication) so there is no equivalent to a TCP SYN packet. However, if a UDP packet is sent to a port that is not open, the system will respond with an [ICMP](https://en.wikipedia.org/wiki/Internet_Control_Message_Protocol) port unreachable message. Most UDP port scanners use this scanning method, and use the absence of a response to infer that a port is open. However, if a port is blocked by a [firewall](https://en.wikipedia.org/wiki/Firewall_(computing)), this method will falsely report that the port is open. If the port unreachable message is blocked, all ports will appear open. This method is also affected by ICMP [rate limiting](https://en.wikipedia.org/wiki/Rate_limiting).

### ACK Scanning:
ACK scanning is one of the more unusual scan types, as it does not exactly determine whether the port is open or closed, but whether the port is filtered or unfiltered. This is especially good when attempting to probe for the existence of a firewall and its rulesets. Simple packet filtering will allow established connections (packets with the ACK bit set), whereas a more sophisticated [stateful firewall](https://en.wikipedia.org/wiki/Stateful_firewall) might not.

### Window Scanning:
Rarely used because of its outdated nature, window scanning is fairly untrustworthy in determining whether a port is opened or closed. It generates the same packet as an ACK scan, but checks whether the window field of the packet has been modified. When the packet reaches its destination, a design flaw attempts to create a window size for the packet if the port is open, flagging the window field of the packet with 1's before it returns to the sender. Using this scanning technique with systems that no longer support this implementation returns 0's for the window field, labeling open ports as closed.

### FIN Scanning:
Since SYN scans are not surreptitious enough, firewalls are, in general, scanning for and blocking packets in the form of SYN packets.[3] FIN packets can bypass firewalls without modification. Closed ports reply to a [FIN packet](https://en.wikipedia.org/wiki/Transmission_Control_Protocol#Connection_termination) with the appropriate RST packet, whereas open ports ignore the packet on hand. This is typical behavior due to the nature of TCP, and is in some ways an inescapable downfall.
