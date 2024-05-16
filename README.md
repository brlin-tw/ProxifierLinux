# proxifier-linux

proxyfier alternative for linux using redsocks. Proxify all linux applications through SOCKS4/5, HTTP proxy

## Installation

Install [redsocks](https://github.com/darkk/redsocks#packages).

```bash
git clone https://github.com/tazihad/proxifier-linux.git
cd proxifier-linux
```

## Usage

Section under rennovations.

<!--
1. Setup redsocks.conf (Example config given)  
   `/etc/redsocks.conf`
-->

## References

The following third-party materials are referenced during the development of this project:

* [darkk/redsocks: transparent TCP-to-proxy redirector](https://github.com/darkk/redsocks)  
  The proxifier software that this project is using.
* [networking - How to force all Linux apps to use SOCKS proxy - Super User](https://superuser.com/a/1402071)
* [How to install and configure Redsocks on Centos Linux | Alexander Molochko](https://crosp.net/blog/administration/install-configure-redsocks-proxy-centos-linux/)
* [!] -d, --destination address[/mask][,...] - PARAMETERS - OPTIONS - The iptables(8) manual page  
  Explains the `-d` command-line option of the `iptables` command.
* [networking - Where are addresses from the network 0.0.0.0/8 used in practice? - Super User](https://superuser.com/questions/388056/where-are-addresses-from-the-network-0-0-0-0-8-used-in-practice)  
  Explains what the addresses of the 0.0.0.0/8 subnet are used for.
* -C, --check _chain_ _rule-specification_ - COMMANDS - OPTIONS - The iptables(8) manual page  
  Explains how to check whether the specified rule exist in the firewall.
