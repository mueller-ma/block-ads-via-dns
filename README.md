# Block ads and malware via local DNS server
# About this fork
This fork as being created in order to add the bash script to my DNS docker running on Debian.
Here are the following change to the initial forked :
- I use StevenBlack list of "adware + malware + fakenews + gambling" : https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling/hosts
- As it's runing inside a contaiser which use System V, I use "service bind9 start"

# Installation
## Debian, Raspbian & Ubuntu
- Install DNS Server: `sudo apt install bind9`
- Go to the bind directory: `cd /etc/bind/`
- Add this to /etc/bind/named.conf: `include "/etc/bind/named.conf.blocked";`
- Create "/etc/bind/db.blocked" and add this (taken from [here](http://www.deer-run.com/~hal/sysadmin/dns-advert.html)):
````
$TTL 24h

@       IN SOA server.yourdomain.com. hostmaster.yourdomain.com. (
               2003052800  86400  300  604800  3600 )

@       IN      NS   server.yourdomain.com.
@       IN      A    0.0.0.0
*       IN      A    0.0.0.0
````
- Your /etc/bind/named.conf.options should look like this:
````
options {
    directory "/var/cache/bind";

    // If there is a firewall between you and nameservers you want
    // to talk to, you may need to fix the firewall to allow multiple
    // ports to talk.  See http://www.kb.cert.org/vuls/id/800113

    // If your ISP provided one or more IP addresses for stable
    // nameservers, you probably want to use them as forwarders.
    // Uncomment the following block, and insert the addresses replacing
    // the all-0's placeholder.

    forwarders {
        8.8.8.8;
        8.8.4.4;
    };

    //========================================================================
    // If BIND logs error messages about the root key being expired,
    // you will need to update your keys.  See https://www.isc.org/bind-keys
    //========================================================================
    dnssec-validation auto;

    auth-nxdomain no;    # conform to RFC1035
    listen-on-v6 { any; };
    check-names master ignore;
    check-names slave ignore;
    check-names response ignore;
};
````
- Replace the forwarders entries with other dns server if you do not want to use Google DNS
- cd to your home directory `cd ~`
- Download generate-zonefile.sh `wget https://raw.githubusercontent.com/mueller-ma/block-ads-via-dns/master/generate-zonefile.sh`
- Make it executable `chmod +x generate-zonefile.sh`
- Run generate-zonefile.sh `./generate-zonefile.sh`

## Router / DHCP Server
- Give your Debian server a static IP
- Change DNS Server in the DHCP settings to the IP of your Debian Server. If you are asked for a second DNS server enter the same IP twice.

## Optional
- Add local blacklist and whitelist
- Create cronjob
- Change the URL to StevenBlack GitHub Hosts in `generate-zonefile.sh`

# Limitations
- The db.blocked will cause some errors on bind start
