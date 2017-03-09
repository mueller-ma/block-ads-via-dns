#Block ads and malware via local DNS server

#Installation
##Debian, Raspbian & Ubuntu
- Install DNS Server: `sudo apt install bind9`
- Go to the bind directory: `cd /etc/bind/`
- Add this to /etc/bind/named.conf: `include "/etc/bind/named.conf.blocked";`
- Create db.blocked and add this:
````
$TTL    86400   ; one day
@       IN      SOA      (
        2017021701       ; serial number YYMMDDNN
        28800   ; refresh  8 hours
        7200    ; retry    2 hours
        864000  ; expire  10 days
        86400 ) ; min ttl  1 day
* IN      A       0.0.0.0
````
- cd to your home directory `cd ~`
- Download generate-zonefile.sh `wget https://raw.githubusercontent.com/mueller-ma/block-ads-via-dns/master/generate-zonefile.sh`
- Make it executable `chmod +x generate-zonefile.sh`
- Run generate-zonefile.sh `./generate-zonefile.sh`

##Router / DHCP Server
- Give your Debian server a static IP
- Change DNS Server in the DHCP settings to the IP of your Debian Server. If you are asked for a second DNS server enter the same IP twice.

##Optional
- Add local blacklist and whitelist
- Create cronjob
- Change the URL to StevenBlack GitHub Hosts in `generate-zonefile.sh`

#Limitations
- The db.blocked will cause some errors on bind start
