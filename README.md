marjo21
=======

Sexy IRC bot written (from scratch) in perl with a web interface to collect some links on a channel.

No updates since 1 year but already works (2019-11-21 =dev-lang/perl-5.28.2-r1 on gentoo)

PREREQUISITES
-------------

### For bot :

PERL >= 5.12

POE::Component::IRC (PERL Module)

Bot::BasicBot (PERL Module)

Net::SSLeay (PERL Module)

IO::Socket::SSL (PERL Module)

LWP::UserAgent (PERL Module)

LWP::Protocol::https (PERL Module)

HTTP::Request (PERL Module)

Try::Tiny (PERL Module)

DBD::mysql (PERL Module)


### For website :

Apache >= 2.2

PHP >= 5.4

PHP PDO Module


### For both :

MySQL or MariaDB


### Suggestions :

I recommend screen (Terminal multiplexer) to launch the bot and detach shell.
See "STARTUP SCRIPT FOR MAJO21" section below. 


INSTALL CPAN MODULES
--------------------

cpan -fi POE::Component::IRC

cpan -fi Bot::BasicBot

cpan -fi Net::SSLeay 

cpan -fi IO::Socket::SSL

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
Thanks
