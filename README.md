marjo21
=======

Sexy IRC bot written (from scratch) in perl with a web interface to collect some links on a channel.


INSTALL CPAN MODULES
--------------------

cpan -fi Net::IRC

cpan -fi Net::SSLeay # (you must reinstall after openssl update)

cpan -fi LWP::UserAgent LWP::Protocol::https HTTP::Request

cpan -fi Try::Tiny


STARTUP SCRIPT FOR MARJO21
---------------------------

For Gentoo : Create `/etc/local.d/21-marjo21.start` :

```bash
rm -rf /home/marjo21/.screen/*
su - marjo21 -c 'screen -dmS bot /home/marjo21/marjo21-launcher.sh'
``` 

Set it executable : 

```bash
chmod +x /etc/local.d/21-marjo21.start
``` 

Enable local service at startup

```bash
rc-update add local default
``` 
