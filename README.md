marjo21
=======

Sexy IRC bot written (from scratch) in perl with a web interface to collect some links on a channel.


INSTALL CPAN MODULES
--------------------

# cpan -fi Net::IRC (Obsolete)
cpan -fi POE::Component::IRC

cpan -fi Net::SSLeay 

cpan -fi LWP::UserAgent
cpan -fi LWP::Protocol::https
cpan -fi HTTP::Request

cpan -fi Try::Tiny

cpan -fi DBD::mysql


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

NOTES
-----
Sorry for French comments, I will translate later all comments in english.
