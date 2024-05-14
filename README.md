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

* [redsocks](https://github.com/darkk/redsocks)
* [superuser](https://superuser.com/a/1402071)
* [crosp.net](https://crosp.net/blog/administration/install-configure-redsocks-proxy-centos-linux/)
