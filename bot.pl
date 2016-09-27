#!/usr/bin/perl

use strict;
use warnings;
use threads;
use threads::shared;

package Marjo21;

use DBI;
use Encode;
use utf8;
use open qw(:std :utf8);

# Liste des librairies utilisées :
use Net::IRC; # old IRC module
use base qw( Bot::BasicBot ); # new IRC module
use Net::SSLeay; # A réinstaller en cas de mise à jour d'OpenSSL !!!
use LWP::UserAgent;
use LWP::Protocol::https;
use HTTP::Request;
use DBD::mysql;
use Try::Tiny;


my $times = time();
my $alive = 1;
my $heartbeat : shared;
$heartbeat = 42;
my $self : shared;


# On charge la config
my $cfg = "bot.cfg";

open (CONFIG, $cfg);
my $server;
my $ircencoding;
my $channel;
my $website;
my $username;
my $blacklists = 0;
my $db;
my $dbhost;
my $dbport;
my $dbuser;
my $dbpasswd;
my $administrator;
my $checkdup;

while (<CONFIG>) {
	chomp;
	$server = substr($_, 8) if ( $_ =~ /^\$server\=/);
	$ircencoding = substr($_, 13) if ( $_ =~ /^\$ircencoding\=/);
	$channel = substr($_, 9) if ( $_ =~ /^\$channel\=/);
	$username = substr($_, 10) if ( $_ =~ /^\$username\=/);
	$website = substr($_, 9) if ( $_ =~ /^\$website\=/);
	$blacklists = substr($_, 12) if ( $_ =~ /^\$blacklists\=/);
	$db = substr($_, 4) if ( $_ =~ /^\$db\=/);
	$dbhost = substr($_, 8) if ( $_ =~ /^\$dbhost\=/);
	$dbport = substr($_, 8) if ( $_ =~ /^\$dbport\=/);
	$dbuser = substr($_, 8) if ( $_ =~ /^\$dbuser\=/);
	$dbpasswd = substr($_, 10) if ( $_ =~ /^\$dbpasswd\=/);
	$checkdup = substr($_, 10) if ( $_ =~ /^\$checkdup\=/);
	$administrator = substr($_, 15) if ( $_ =~ /^\$administrator\=/);
}

close (CONFIG);

if ( length($server) < 2 || length($channel) < 2 || length($username) < 2)
{
	print "No server or channel or username found in $cfg file !\n";
	exit 1;
}

# On charge la base de données



# Fin de la config

# Configuration des options de connexion (serveur, login) :
my $nick = $username;

# Informations concernant le Bot :
my $ircname = 'marjo21 Web Link';
my $version = '2.0';

# On crée l'objet qui nous permet de nous connecter à IRC :
#my $irc = new Net::IRC;

# On crée l'objet de connexion à IRC :
my $conn; #A supprimer
#my $conn = $irc->newconn(
#    'Server'      => $server,
#    'Port'        => 6667, 
#    'Nick'        => $nick,
#    'Ircname'     => $ircname,
#    'Username'    => $username
#);

# On crée l'objet qui nous permet de nous connecter à IRC :
Marjo21->new(
	server => $server,
	channels => [ $channel ],
	nick => $nick,
	charset => $ircencoding,
)->run();



# On installe les fonctions de Hook :
#$conn->add_handler('376', \&on_connect);         # Fin du MOTD => on est connecté
#$conn->add_handler('public', \&on_public);       # Sur le chan
#$conn->add_handler('msg',\&on_msg);		# Via msg privé

# On lance la connexion et la boucle de gestion des événements :
#$irc->start();

# Fonction pour tester la présence du robot sur IRC
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
		
		if ( time()-$heartbeat gt 5*$check )
		{
		      exec( $^X, $0);
		}
		
	}
}


## Les fonctions de gestion des événements :

#sub on_connect
#{
#    my ($conn, $event) = @_;
    
#    $conn->join($channel);
    #$conn->privmsg($channel, 'Salutations !');
#    print "$nick started !\n";
    
#    $conn->{'connected'} = 1;
    
#    my $thrheartbeat = threads->new(\&heartbeat);
#} # Fin on_connect




#sub on_public
sub said
{
	my ($self, $event) = @_;
	my $text = $event->{body};
    	#$conn->print("<" . $event->{'nick'} . ">\t| $text");
   
    	if (substr($text, 0, 1) eq '!')
    	{
		# $text commence par un '!' => il s'agit probablement d'une commande
        	my $commande = ($text =~ m/^!([^ ]*)/)[0];
        	if ($commande ne '')
        	{
            		
			if ($commande eq 'help')
			{
				#&help($channel, $event->{'nick'});
				if ($event->{channel} ne 'msg')
				{
					$self->say(
						channel => $channel,
						body => "$event->{who}: Je t'ai envoyé un message prové mon p'tit chou ! :-)",
					);
				}
				$self->say(
					who => $event->{who},
					channel => "msg",
					body => "Aide : !help => Affiche le manuel d'utilisation -- !link http://url => Affiche le titre de la page à l'adresse url -- !last => Affiche des informations sur le dernier lien posté. Pour consulter l'historique des liens postés, c'est par ici : $website",
				);
				
			}
		
			if ($commande eq 'bonjour')
			{
				#&bonjour($channel, $event->{'nick'});
				if ( $event->{channel} eq 'msg' )
				{
					$self->say(
						who => $event->{who},
						channel => "msg",
						body => "Bonjour $event->{who}",
					);
				}
				else
				{
					$self->say(
						channel => $channel,
						body => "Bonjour $event->{who}",
					);
				}
			}

			if ($commande eq 'link' or $commande eq 'l')
			{
			if ( $event->{channel} eq 'msg' ) # Si le msg !link est passé par MP, on ne traite pas mais on averti quand même
			{
				$self->say(
					who => $event->{who},
					channel => "msg",
					body => "La commande !link ne fonctionne que sur le canal $channel ! Pas de passage de liens en douce...",
				);
			}
			else # La commande est passée sur le canal
			{ 
				my @params = grep {!/^\s*$/} split(/\s+/, substr($text, length("!$commande")));
					if (defined($params[0]) && $params[0] ne '')
			               	{
						# Un paramètre (non vide) a été passé à la commande
                	  			# => On va pouvoir l'utiliser                


						my $url = "$params[0]";
						
						my $prot = substr($url, 0, 3);
						if ( "$prot" ne "htt" && "$prot" ne "ftp" )
						{
							$url="http://".$url;
						}

						
						# On verifie si le lien a déjà été posté
						my $alreadypost = 0;
						if ( "$checkdup" eq "1" )
						{
							try {
								my $db_handle = DBI->connect("dbi:mysql:database=$db;host=$dbhost:$dbport;user=$dbuser;password=$dbpasswd");
								my $sql = "SELECT count(*) as count, user, dateandtime, title FROM links WHERE link=\"$url\"";
								my $statement = $db_handle->prepare($sql);
								$statement->execute();

								my $row_ref = $statement->fetchrow_hashref();
								if ( "$row_ref->{count}" eq "1" )
								{
									$alreadypost = 1;
									#$conn->privmsg($channel, decode_utf8($row_ref->{title})." (déjà posté par $row_ref->{user} le $row_ref->{dateandtime})");
									$self->say(
										channel => "$channel",
										body => "Tu arrives en retard ... $row_ref->{user} l'a fait avant toi le $row_ref->{dateandtime} ! Pour info : $row_ref->{title} ",
									);
								}
								$statement->finish;
								$db_handle->disconnect();
							}
							catch {
								$alreadypost = 1;
								#$conn->privmsg($channel, "Je ne peux pas vérifier si le lien a déjà été posté, je n'arrive pas à joindre la base de données...");
								$self->say(
									channel => "$channel",
									body => "Je ne peux pas joindre la base...",
								);
							}

						}


						if ( $alreadypost ne 1 )
						{
							my $ua = LWP::UserAgent->new(agent => 'Mozilla/5.0 (X11; Linux x86_64; rv:29.0) Gecko/20100101 Firefox/29.0', ssl_opts => { verify_hostname => 0 });
							my $res = $ua->request(HTTP::Request->new(GET => $url));
						
							my $blacklisted = &blacklistedurl($url);
							if ( $blacklisted eq 1)
							{
								#$conn->privmsg($channel, "Contenu censuré...");
								#$conn->print("<$nick>\t| Contenu censuré...");
								$self->say(
									channel => "$channel",
									body =>  "Contenu trop choquant...",
								);
							}
						
						
							if ($res->is_success &&  $blacklisted eq 0) {
						
								my $pseudo = $event->{'who'};
								
								my $titre = $res->title;
						
								my $type = $res->content_type;
								my $isimage = 0;
								my $ispdf = 0;
								
								if ( $type =~ /image/) {
									my @fic = split /\//, $url;
									$titre = "IMAGE : $fic[-1] - $url";
									$isimage = 1;
								}
								else
								{
									 if ( $type =~ /pdf/ )
									 {
								                 my @fic = split /\//, $url;
								                 $titre = "PDF : $fic[-1] - $url";
								                 $ispdf = 1;
								         }
									else
									{
										# Substitute some characters ...
										$titre =~ s/\’/\'/;	
									
										# Useful for encoding in utf8 in the database.
										#$titre = encode("utf8", decode("iso-8859-1", $titre));
										if (eval { decode_utf8($res->title, Encode::FB_CROAK); 1 }) {
										        print "UTF-8\n";
											try 
											{
												$titre = encode("utf8", decode("utf8", $titre));
											}
											catch
											{
												$titre = encode_utf8($titre);
											}
										}
										else
										{
										        print "Not UTF-8\n";
										        $titre = encode("utf8", decode("iso-8859-1", $titre));
										}	
									}
								}

								if ( $titre eq '' )
								{
									$titre = "Pas de titre : $url";
								}
								#$conn->privmsg($channel, $titre); 
								#$conn->print("<$nick>\t| ".$titre);
								$self->say(
									channel => "$channel",
									body =>  "$titre",
								);

								try {
									my $db_handle = DBI->connect("dbi:mysql:database=$db;host=$dbhost:$dbport;user=$dbuser;password=$dbpasswd");
									my $statement = $db_handle->prepare("SET NAMES utf8;");
									$statement->execute();
									my $sql = "INSERT INTO links(dateandtime,user,link,title) VALUES (NOW(),?,?,?)";
									$statement = $db_handle->prepare($sql);
									$statement->execute($pseudo,$url,$titre);
									$db_handle->disconnect();
								}
								catch
								{
									#$conn->privmsg($channel, "Je ne peux pas indexer ce contenu, je n'arrive pas à joindre la base de données...");
									$self->say(
										channel => "$channel",
										body =>   "Je ne peux pas indexer ce contenu, je n'arrive pas à joindre la base...",
									);
								}

							} else {
								print $res->status_line, "\n";
							} # Fin if is success
						

						} #Fin if alreadypost = 1 
        	        		}
                			else
                			{
						# Un paramètre attendu n'a pas été fourni à la commande...
                    				#$conn->print("Un paramètre attendu");
						#$conn->privmsg($channel,"$event->{'nick'} : Une url est attendue après la commande !link. Taper !help pour plus d'informations...");
						$self->say(
							channel => "$channel",
							body =>  "$event->{'who'} : Une url est attendue avec la commande !link. Taper !help pour plus d'informations...",
						);
	                		}
			} # Fin de la condition "si MP"		
			} # Fin !link
			
			if ($commande eq 'last')
			{

					my $db_handle = DBI->connect("dbi:mysql:database=$db;host=$dbhost:$dbport;user=$dbuser;password=$dbpasswd");
					my $sql = "SELECT * FROM links WHERE dateandtime=(SELECT MAX(dateandtime) FROM links)";
					my $statement = $db_handle->prepare($sql);
					$statement->execute();
				
					my $result;	
					while (my $row_ref = $statement->fetchrow_hashref())
					{
						$result = "Dernier lien par $row_ref->{user} le $row_ref->{dateandtime} : $row_ref->{title} ( $row_ref->{link} )";
					}
					#$conn->print("<$nick>\t| $result");
					#$conn->privmsg($channel,$result);
					
					if ( $event->{channel} eq 'msg')
					{
						$self->say(
							who => $event->{who},
							channel => "msg",
							body =>  "$result",
						);
					}
					else
					{
						$self->say(
							channel => "$channel",
							body =>  "$result",
						);
					}
					$db_handle->disconnect();
				
			} #Fin !last

			if ($commande eq 'search')
			{
				my @params = grep {!/^\s*$/} split(/\s+/, substr($text, length("!$commande")));
				if (defined($params[0]) && $params[0] ne '')
				{
					my $db_handle = DBI->connect("dbi:mysql:database=$db;host=$dbhost:$dbport;user=$dbuser;password=$dbpasswd");
					my $sql = "SELECT * FROM links WHERE title LIKE '%$params[0]%' ORDER BY id";
					my $statement = $db_handle->prepare($sql);
					$statement->execute();

					my $num = $statement->rows;

					my $result;
					
					if ( $num < 6 )
					{
						if ( $num == 0 )
						{
							$result = "Il n'y a pas de résultats mon p'tit chou !";
							#$conn->print("<$nick>\t| $result");
							#$conn->privmsg($channel,$result);
							if ( $event->{channel} eq 'msg' )
							{
								$self->say(
									who => $event->{who},
									channel => "msg",
									body =>  "$result",
								);
							}
							else
							{
								$self->say(
									channel => "$channel",
									body =>  "$result",
								);
							}
						}
						else
						{
							while (my $row_ref = $statement->fetchrow_hashref())
							{
								$result = "$row_ref->{title} ( $row_ref->{link} ) par $row_ref->{user} le $row_ref->{dateandtime}";
								#$conn->print("<$nick>\t| $result");
								#$conn->privmsg($channel,$result);
								if ( $event->{channel} eq 'msg' )
								{
									$self->say(
										who => $event->{who},
										channel => "msg",
										body =>  "$result",
									);
								}
								else
								{
									$self->say(
										channel => "$channel",
										body =>  "$result",
									);
								}
							}
						}
					}
					else
					{
						my $urlgen = $website."/search.php?keywords=".$params[0];
						$result = "Il y a plus de 5 résultats. Consulte ta recherche sur $urlgen";
						#$conn->print("<$nick>\t| $result");
						#$conn->privmsg($channel,$result);
						if ( $event->{channel} eq 'msg' )
						{
							$self->say(
								who => $event->{who},
								channel => "msg",
								body =>  "$result",
							);
						}
						else
						{
							$self->say(
								channel => "$channel",
								body =>  "$result",
							);
						}
					}
					$db_handle->disconnect();
				}
				else
				{
					#$conn->print("Un paramètre attendu");
					#$conn->privmsg($channel,"$event->{'nick'} : Une url est attendue après la commande !link. Taper !help pour plus d'informations...");
					$self->say(
						channel => "$channel",
						body =>  "$event->{who} : Une url est attendue après la commande !search. Taper !help pour plus d'informations...",
					);
				}
			} # Fin !search
		
			#Il faudrait utiliser switch ....
			if ( $commande ne 'last' && $commande ne 'link' && $commande ne 'l' && $commande ne 'bonjour' && $commande ne 'help' && $commande ne 'search')
			{ 
				#$conn->privmsg($channel,"$event->{'nick'} : Commande inconnue. Taper !help pour plus d'informations...");
				$self->say(
					channel => "$channel",
					body =>  "$event->{who} : Commande inconnue. Taper !help pour plus d'informations...",
				);
			}
		}		
        	else
        	{
			# On avait un ! en début de ligne, mais non suivi d'un nom de commande
            		print("Pas une commande");
       		}	
	}

return undef;
} # Fin said




#sub on_msg()
sub emoted
{

	my ($self, $event) = @_;
	my $text = $event->{body};
	#$conn->print("<" . $event->{'nick'} . ">\t| $text") if $text ne '!heartbeat';

	if (substr($text, 0, 1) eq '!')
	{
		# $text commence par un '!' => il s'agit probablement d'une commande
		my $commande = ($text =~ m/^!([^ ]*)/)[0];
		if ($commande ne '')
		{
			if ("$commande" eq 'reload')
			{
				if ("$administrator" eq "" || "$event->{who}" eq "$administrator")
				{
					&reload($event->{who},$event->{who});
				}
				else
				{
					&forbidden($event->{who},$event->{who});
				}
			}

                        if ("$commande" eq 'restart')
                        {
                                if ("$administrator" eq "" || "$event->{who}" eq "$administrator")
                                {
                                        &restart($event->{who},$event->{who});
                                }
                                else
                                {
                                        &forbidden($event->{who},$event->{who});
                                }
                        }

			
			#if ("$commande" eq 'heartbeat')
			#{
			#	if ( "$event->{'nick'}" eq "$username" )
			#	{
			#		$heartbeat = time();
			#	}
			#}
			
			if ("$commande" eq 'bonjour')
			{
				#&bonjour($event->{who},$event->{who});
				$self->say(
					who => $event->{who},
					body => "Bonjour $event->{who}",
				);
			}
			
			if ("$commande" eq 'help')
			{
				&help($event->{who},$event->{who});
			}
			
			if ("$commande" eq 'link')
			{
				#$conn->privmsg($event->{who}, "La commande !link ne fonctionne que sur le canal $channel, pas en message privé ;)");
			}

			if ("$commande" eq 'update')
			{
				if ("$event->{who}" eq "$administrator")
				{
					&update($event->{who},$event->{who});
				}
                                else
                                {
                                        &forbidden($event->{who},$event->{who});
                                }

			}

			if ("$commande" eq 'speak')
			{
                                if ("$event->{who}" eq "$administrator")
                                {
                                        &speak($channel,$text);
                                }
			}
		}
	}


} #Fin Fonction message prive (emoted)

sub forbidden {

	$conn->privmsg("$_[1]", "Hé, tu te crois où ... tu n'es pas autorisé à exécuter cette commande...");

}

sub reload {

	# Pour éviter le déni de service
	if ( $times+0 lt time() )
	{
		$conn->print("<$nick>\t| Je recharge mon programme à la demande de $_[1], je reviens...");
	
		exec( $^X, $0);
	}
}

sub restart {

        # Pour éviter le déni de service
        if ( $times+0 lt time() )
        {
                $conn->print("<$nick>\t| Je redémarre mon programme à la demande de $_[1], je reviens...");

                exit (3);
        }
}

sub update {

	$conn->privmsg($channel, "Démarrage de la mise à jour ... Je reviens dans un court instant :D");
	$conn->print("<$nick>\t| Démarrage de la mise à jour sur demande de $_[1] ");
	exec ( 'sh update-marjo21.sh' );
	exit (2);


}

sub speak {
	
	my $text = substr($_[1], 5);
	$conn->privmsg($_[0],"$text");
}

sub blacklistedurl {

# Appeler la fonction avec une URL et renvoie 0 si pas blacklisté, 1 si URL blacklisté.
my $urlcheck = $_[0];
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
