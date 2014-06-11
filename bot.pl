#!/usr/bin/perl

use strict;
use warnings;
use threads;
use DBI;


# LIBS
# perl-Net-IRC-0.79-8.fc20.noarch
# perl-Net-SSLeay-1.55-4.fc20.x86_64
# perl-LWP-UserAgent-Determined-1.06-1.fc20.noarch
# perl-LWP-Protocol-https-6.04-4.fc20.noarch

# It's possible to install modules with "cpan" : cpan -fi LWP::UserAgent
# To test the resuquest it's possible to use the command : lwp-request -des http://url.com

# Liste des librairies utilisées :
use Net::IRC;
use Net::SSLeay; # A réinstaller en cas de mise à jour d'OpenSSL !!!
use LWP::UserAgent;
use LWP::Protocol::https;
use HTTP::Request;
use DBD::mysql;



my $times = time();
my $alive = 1;

# On charge la config
my $cfg = "bot.cfg";

open (CONFIG, $cfg);
my $server;
my $channel;
my $website;
my $username;
my $blacklists = 0;

while (<CONFIG>) {
	chomp;
	$server = substr($_, 8) if ( $_ =~ /^\$server\=/);
	$channel = substr($_, 9) if ( $_ =~ /^\$channel\=/);
	$username = substr($_, 10) if ( $_ =~ /^\$username\=/);
	$website = substr($_, 9) if ( $_ =~ /^\$website\=/);
	$blacklists = substr($_, 12) if ( $_ =~ /^\$blacklists\=/);
}

close (CONFIG);

if ( length($server) < 2 || length($channel) < 2 || length($username) < 2)
{
	print "No server or channel or username found in $cfg file !\n";
	exit 1;
}

# On charge la base de données

my $db_handle = DBI->connect("dbi:mysql:database=marjo21;host=127.0.0.1:3306;user=root;password=root");


# Fin de la config

# Configuration des options de connexion (serveur, login) :
my $nick = $username;

# Informations concernant le Bot :
my $ircname = 'marjo21 Web Link';
my $version = '1.0';

# On crée l'objet qui nous permet de nous connecter à IRC :
my $irc = new Net::IRC;

# On crée l'objet de connexion à IRC :
my $conn = $irc->newconn(
    'Server'      => $server,
    'Port'        => 6667, 
    'Nick'        => $nick,
    'Ircname'     => $ircname,
    'Username'    => $username
);


# On installe les fonctions de Hook :
$conn->add_handler('376', \&on_connect);         # Fin du MOTD => on est connecté
$conn->add_handler('public', \&on_public);       # Sur le chan
$conn->add_handler('msg',\&on_msg);		# Via msg privé

# On lance la connexion et la boucle de gestion des événements :
$irc->start();



## Les fonctions de gestion des événements :

sub on_connect
{
    my ($conn, $event) = @_;
    
    $conn->join($channel);
    #$conn->privmsg($channel, 'Salutations !');
    #print "<$nick>\t| Salutations !\n";
    
    $conn->{'connected'} = 1;
    
    my $thrheartbeat = threads->new(\&heartbeat);
} # Fin on_connect



sub heartbeat
{
	my $check = 10;
	
	sleep 10;
	$conn->privmsg($username, '!heartbeat');
	
	while ( $alive eq 1 )
	{
		sleep $check;
		$conn->privmsg($username, '!heartbeat');	
		sleep 1;
		open (HEART, "heartbeat");
		my $heartbeat;
		while(<HEART>) {
			chomp;
			$heartbeat = $_;
		}
		close (HEART);

		if ( time()-$heartbeat gt 3*$check )
		{
		      exec( $^X, $0);
		}
		
	}
}


sub on_public
{
	my ($conn, $event) = @_;
	my $text = $event->{'args'}[0];
    	$conn->print("<" . $event->{'nick'} . ">\t| $text");
   
    	if (substr($text, 0, 1) eq '!')
    	{
		# $text commence par un '!' => il s'agit probablement d'une commande
        	my $commande = ($text =~ m/^!([^ ]*)/)[0];
        	if ($commande ne '')
        	{
            		
			if ($commande eq 'help')
			{
				&help($channel, $event->{'nick'});
			} 
		
			if ($commande eq 'ping')
			{
				&ping($channel, $event->{'nick'});
			}

			if ($commande eq 'reload')
			{
				&reload($channel, $event->{'nick'});
			}
			if ($commande eq 'link')
			{
				my @params = grep {!/^\s*$/} split(/\s+/, substr($text, length("!$commande")));
					if (defined($params[0]) && $params[0] ne '')
			               	{
						# Un paramètre (non vide) a été passé à la commande
                	  			# => On va pouvoir l'utiliser                


						my $url = "$params[0]";
						my $ua = LWP::UserAgent->new(agent => 'Mozilla/5.0 (X11; Linux x86_64; rv:29.0) Gecko/20100101 Firefox/29.0', ssl_opts => { verify_hostname => 0 });
						my $res = $ua->request(HTTP::Request->new(GET => $url));
						
						my $blacklisted = &blacklistedurl($url);
						if ( $blacklisted eq 1)
						{
							$conn->privmsg($channel, "Contenu censuré...");
							$conn->print("<$nick>\t| Contenu censuré...");
						}
						
						
						if ($res->is_success && $blacklisted eq 0) {
							$conn->privmsg($channel, $res->title); 
							$conn->print("<$nick>\t| ".$res->title);
						
							#Generation de la date
							#(my $sec,my $min, my $hour,my $mday,my $mon,my $year,my $wday,my $yday,my $isdst) = localtime();
							#my @months = qw( Decembre Janvier Fevrier Mars Avril Mai Juin Juillet Aout Septembre Octobre Novembre Decembre );
							#my @days = qw( Dim Lun Mar Mer Jeu Ven Sam Dim );
							#$year+=1900;
							#$mon+=1;
							
							# Rectification des heures et minutes
							#if (length($min) eq 1)
							#{
							#	$min = "0".$min;
							#}
							#if (length($mon) eq 1)
							#{
							#	$mon = "0".$mon;
							#}

							# Creation du nom du fichier
							#my $fic = "public_html/logs/$year-$mon--$months[$mon]-$year";
							
							my $pseudo = $event->{'nick'};
							my $titre = $res->title;

							# Création ou ouverture du fichier
							#open (FICHIER, ">>$fic") || die ();
							# On écrit dans le fichier...
							#print FICHIER "$days[$wday] $mday;$hour:$min;$pseudo;$url;$titre \n";
							#close (FICHIER);
							
							my $sql = "INSERT INTO links(dateandtime,user,link,title) VALUES (NOW(),?,?,?)";
							my $statement = $db_handle->prepare($sql);
							$statement->execute($pseudo,$url,$titre);



						} else {
							print $res->status_line, "\n";
						}
						


                			}
                			else
                			{
				 		# Un paramètre attendu n'a pas été fourni à la commande...
                    				$conn->print("Un paramètre attendu");
						$conn->privmsg($channel,"$event->{'nick'} : Une url est attendue après la commande !link. Taper !help pour plus d'informations...");
                			}
			}#Fin !link
			
			if ($commande eq 'last')
			{
				#my $dossier = "public_html/logs/";
				#opendir(DOSSIER, $dossier );
				#my @entrees = readdir(DOSSIER);
				#closedir(DOSSIER);
				#my $e;
				#my $modtime;
				#my $lastfic = "";
				
				#if ( $#entrees gt 2 )
				#{
				#	foreach $e (@entrees)
				#	{
				#		if ( $e ne "." && $e ne ".." )
				#		{
				#			if ($lastfic eq "")
				#			{
				#				$modtime = (stat($dossier.$e))[9];
				#				$lastfic = $e;
				#			}
				#			else
				#			{
				#				my $curfiletime = (stat($dossier.$e))[9];
				#				if ( $curfiletime gt $modtime )
				#				{
				#					$lastfic = $e;
				#				}
				#			}
				#			
				#		}
				#		
				#	}
				#	
					# Création ou ouverture du fichier
				#	open (FICHIER, "$dossier$lastfic") || die ();
				#	
				#	my $lastline;
				#		while(<FICHIER>) {
				#		chomp;
				#		$lastline = $_ if eof;
				#	}
				#	close (FICHIER);
					
				#	my @splitlink = split(/;/,$lastline);
					
				#	$conn->print("Le dernier lien posté : Par $splitlink[2] le $splitlink[0] à $splitlink[1] : $splitlink[4] ( $splitlink[3] )");
				#	$conn->privmsg($channel,"Le dernier lien posté : Par $splitlink[2] le $splitlink[0] à $splitlink[1] : $splitlink[4] ( $splitlink[3] ) ");
				

					my $sql = "SELECT * FROM links WHERE dateandtime=(SELECT MAX(dateandtime) FROM links)";
					my $statement = $db_handle->prepare($sql);
					$statement->execute();
				
					my $result;	
					while (my $row_ref = $statement->fetchrow_hashref())
					{
						$result = "Dernier lien posté par $row_ref->{user} le $row_ref->{dateandtime} : $row_ref->{title} ( $row_ref->{link} )";
					}
					$conn->print("<$nick>\t| $result");
					$conn->privmsg($channel,$result);
				
			} #Fin !last
		}		
        	else
        	{
			# On avait un ! en début de ligne, mais non suivi d'un nom de commande
            		$conn->print("Pas une commande");
			$conn->privmsg($channel,"$event->{'nick'} : Commande inconnue. Taper !help pour plus d'informations...");
       		}	
	}

} # Fin on_public 




sub on_msg()
{

	my ($conn, $event) = @_;
	my $text = $event->{'args'}[0];
	$conn->print("<" . $event->{'nick'} . ">\t| $text") if $text ne '!heartbeat';

	if (substr($text, 0, 1) eq '!')
	{
		# $text commence par un '!' => il s'agit probablement d'une commande
		my $commande = ($text =~ m/^!([^ ]*)/)[0];
		if ($commande ne '')
		{
			if ($commande eq 'reload')
			{
				&reload($event->{'nick'},$event->{'nick'});
			}
			
			if ($commande eq 'heartbeat')
			{
				if ( $event->{'nick'} eq $username )
				{
					open (HEART, ">heartbeat");
					print HEART time();
					close (HEART);
				}
			}
			
			if ($commande eq 'ping')
			{
				&ping($event->{'nick'},$event->{'nick'});
			}
			
			if ($commande eq 'help')
			{
				&help($event->{'nick'},$event->{'nick'});
			}
			
			if ($commande eq 'link')
			{
				$conn->privmsg($event->{'nick'}, "La commande !help ne fonctionne que sur le canal $channel, pas en message privé ;)");
			}
		}
	}


} #Fin Fonction message prive

# Appeler les fonction de cette maniere :
# &fonction($channel,$event->{'nick'}); pour les messages sur le canal
# &fonction($event->{'nick'},$event->{'nick'}); pour les messages privés
# On recupere ainsi avec @_[0] le canal ou le pseudo d'où écrire. et avec @_[1] le pseudo de l'émetteur de la commande

sub ping {
	$conn->privmsg(@_[0],"Je suis toujours là @_[1] ...");
}

sub help {

	if (@_[0] eq $channel)
	{
		$conn->privmsg($channel,"@_[1] : Je t'ai envoyé un message privé mon petit chou !");
	}
	$conn->privmsg(@_[1], "!help : Affiche le manuel d'utilisation");
	$conn->privmsg(@_[1], "!link url : Affiche le titre de la page à l'adresse url ");
	$conn->privmsg(@_[1], "!last : Affiche des informations sur le dernier lien posté ");

	$conn->privmsg(@_[1], "Pour consulter l'historique des liens postés, c'est par ici : $website");


}

sub reload {

	# Pour éviter le déni de service
	if ( $times+60 lt time() )
	{
		$conn->privmsg($channel, "Je recharge mon programme à la demande de @_[1], je reviens...");
		$conn->print("<$nick>\t| Je recharge mon programme à la demande de @_[1], je reviens...");
	
		exec( $^X, $0);
	}
}

sub blacklistedurl {

# Appeler la fonction avec une URL et renvoie 0 si pas blacklisté, 1 si URL blacklisté.
my $urlcheck = @_[0];
my $return = 0;

if ( $blacklists eq 1 )
{

	my $domain;

	my @spliturl = split(/\//,$urlcheck);
	@spliturl = split(/\./,$spliturl[2]);
	
	$domain=$spliturl[$#spliturl-1].'.'.$spliturl[$#spliturl];

	open (BLACKLIST, 'blacklists/adult/domains');


	while (<BLACKLIST>) {
		chomp;
		$return = 1 if ( $domain eq $_ );
	}

	close (BLACKLIST);
}
chomp $return;

return $return;

}
