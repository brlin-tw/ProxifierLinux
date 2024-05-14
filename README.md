# proxifier-linux

proxyfier alternative for linux using redsocks. Proxify all linux applications through SOCKS4/5, HTTP proxy

## Installation

Install [redsocks](https://github.com/darkk/redsocks#packages).

```bash
git clone https://github.com/tazihad/proxifier-linux.git
cd proxifier-linux
```

## Usage

1. Setup redsocks.conf (Example config given)  
   `/etc/redsocks.conf`
1. Open Terminal and run  
   `sudo ./start-proxifier.sh`

   Done. [Check IP](https://ifconfig.me/)

1. CTRL+Z to exit first script and flush iptables  
   `sudo ./stop-proxifier.sh`

## References

The following third-party materials are referenced during the development of this project:

* [darkk/redsocks: transparent TCP-to-proxy redirector](https://github.com/darkk/redsocks)  
  The proxifier software that this project is using.
* [networking - How to force all Linux apps to use SOCKS proxy - Super User](https://superuser.com/a/1402071)
* [How to install and configure Redsocks on Centos Linux | Alexander Molochko](https://crosp.net/blog/administration/install-configure-redsocks-proxy-centos-linux/)
* [!] -d, --destination address[/mask][,...] - PARAMETERS - OPTIONS - The iptables(8) manual page  
  Explains the `-d` command-line option of the `iptables` command.
