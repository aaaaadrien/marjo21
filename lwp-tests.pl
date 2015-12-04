#! /usr/bin/perl

use Net::SSLeay; # A réinstaller en cas de mise à jour d'OpenSSL !!!
use LWP::UserAgent;
use LWP::Protocol::https;
use HTTP::Request;
use DBD::mysql;
use Encode;
use Try::Tiny;
use utf8;
use open qw(:std :utf8);

use warnings;

#my $url = "https://pbs.twimg.com/media/CU9-e0mUwAAF8RM.jpg:large";
my $url = "http://www.agiliste.fr/wp-content/partage/Les-8-leviers-de-reussite.pdf";
#my $url = "http://www.linuxtricks.fr";

my $ua = LWP::UserAgent->new(agent => 'Mozilla/5.0 (X11; Linux x86_64; rv:29.0) Gecko/20100101 Firefox/29.0', ssl_opts => { verify_hostname => 0 });
my $res = $ua->request(HTTP::Request->new(GET => $url));

# use URI::Title qw( title );
# my $title = title('http://linuxtricks.fr');
# print "Title is $title\n";

my $titre = $res->title;

# Substitute some characters ...
#$titre =~ s/\’/\'/;

my $type = $res->content_type;
my $isimage = 0;
my $ispdf = 0;

if ( $type =~ /image/) {
	$titre = $url;
	$isimage = 1;
	print "coucou";
}
else
{
	if ( $type =~ /pdf/ ) {
		my @fic = split /\//, $url;
		$titre = "PDF : $fic[-1] - $url";
		$ispdf = 1;
	}
}

print "$titre";
print "\n";
print $res->content_type;
print "\n";

#print $res->content_encoding;
print "\n";

