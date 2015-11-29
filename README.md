marjo21
=======

Sexy IRC bot written (from scratch) in perl with a web interface to collect some links on a channel.


INSTALL CPAN MODULES
--------------------

cpan -fi Net::IRC

cpan -fi Net::SSLeay # (you must reinstall after openssl update)

cpan -fi LWP::UserAgent LWP::Protocol::https HTTP::Request

cpan -fi Try::Tiny
