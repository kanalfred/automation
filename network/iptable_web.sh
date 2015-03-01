#!/bin/bash

/sbin/iptables -F
/sbin/iptables -P INPUT DROP
/sbin/iptables -P OUTPUT ACCEPT
#Any network interfaces
# state
# New:          The packet is not part of any known flow or socket and the TCP flags have the SYN bit on.
# Established:  The packet matches a flow or socket tracked by CONNTRACK and has any TCP flags. After the initial TCP handshake is completed the SYN bit must be off for a packet to be in state established.
# Related:      The packet does not match any known flow or socket, but the packet is expected because there is an existing socket that predicates it (examples of this are data on port 20 when there is an existing FTP session on port 21, or UDP data for an existing SIP connection on TCP port 5060). This requires an associated ALG, or 
# Invalid:      If none of the previous states apply the packet is in state INVALID. This could be caused by various types of stealth network probes, or it could mean that you're running out of CONNTRACK entries (which you should also see stated in your logs). Or it may simply be entirely benign.
/sbin/iptables -A INPUT -m state --state NEW -p tcp --dport 22 -j ACCEPT
/sbin/iptables -A INPUT -m state --state NEW -p tcp --dport 80 -j ACCEPT
/sbin/iptables -A INPUT -m state --state NEW -p tcp --dport 443 -j ACCEPT
/sbin/iptables -A INPUT -m state --state NEW -p tcp --dport 3306 -j ACCEPT
#ALLOW DNS resolution
/sbin/iptables -A OUTPUT -p udp -o eth0 --dport 53 -j ACCEPT
/sbin/iptables -A INPUT -p udp -i eth0 --sport 53 -j ACCEPT
#Sendmail
/sbin/iptables -A INPUT -p tcp -m tcp --dport 25 -j ACCEPT
/sbin/iptables -A INPUT -p tcp -m tcp --dport 465 -j ACCEPT
/sbin/iptables -A INPUT -p tcp -m tcp --dport 110 -j ACCEPT
/sbin/iptables -A INPUT -p tcp -m tcp --dport 995 -j ACCEPT
/sbin/iptables -A INPUT -p tcp -m tcp --dport 143 -j ACCEPT
/sbin/iptables -A INPUT -p tcp -m tcp --dport 993 -j ACCEPT
#ShellInAbox
/sbin/iptables -A INPUT -p tcp -m tcp --dport 4200 -j ACCEPT
#Related
/sbin/iptables -A INPUT -p icmp -j ACCEPT
/sbin/iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
/sbin/service iptables save
/sbin/iptables -L -v
