#!/usr/bin/perl

use strict;
use warnings;
#use threads;
#use threads::shared;

package Marjo21;
my $version = '2.0.5';

use DBI;
use Encode;
use Switch;
use utf8;
use open qw(:std :utf8);

# Liste des modules utilisés :
#use Net::IRC; # old IRC module
use base qw( Bot::BasicBot ); # new IRC module
use Net::SSLeay; # A réinstaller en cas de mise à jour d'OpenSSL !!!
use IO::Socket::SSL;
use LWP::UserAgent;
use LWP::Protocol::https;
use HTTP::Request;
use DBD::mysql;
use Try::Tiny;


#my $times = time();
#my $alive = 1;
#my $heartbeat : shared;
#$heartbeat = 42;
my $lastheart : shared;
$lastheart = time();
my $curheart : shared;
$curheart = time();
my $self : shared;


# On charge la config
my $cfg = "bot.cfg";

open (CONFIG, $cfg);
my $server;
my $password;
my $ircencoding = "iso-8859-1";
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
my $useragent = 'Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:49.0) Gecko/20100101 Firefox/49.0';

while (<CONFIG>) {
	chomp;
	$server = substr($_, 8) if ( $_ =~ /^\$server\=/);
	$password = substr($_, 10) if ( $_ =~ /^\$password\=/);
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

# On crée l'objet de connexion à IRC :
#my $conn; #A supprimer

my $datestring = localtime();
print "Start marjo21 : $datestring\n";

# On crée l'objet qui nous permet de nous connecter à IRC :
Marjo21->new(
	server => $server,
	password => $password,
	channels => [ $channel ],
	nick => $nick,
	charset => $ircencoding,
)->run();

#sub connected {
#	my $self = shift;
#	my $thrheartbeat = threads->new(\&heartbeat);
#}

# Fonction appelée régulièrement
sub tick {
	my $self = shift;
	my $check = 10;
	$self->say(
		who => "$nick",
		channel => "msg",
		body => "?heartbeat",
	);
	
	$curheart = time();
	my $delta = $curheart-$lastheart;
	my $maxdelta = 4*$check;

	#print STDERR "L: $lastheart \nC: $curheart \nDelta : $delta \nMaxDelta : $maxdelta \n";

	if ( $delta > $maxdelta )
	{
		print STDERR "Timeout !!\n";
		exit(42);
	}

	# Timer between each call
	return $check;
}

# Fonction pour tester la présence du robot sur IRC
#sub heartbeat
#{
	
#	my $check = 2;
	
#	print STDERR "debut heartbeat\n";

#	sleep 10;
	#$conn->privmsg($username, '!heartbeat');
#	$self->say(
#		who => $username,
#		channel => "who",
#		body => "?heartbeat",
#	);

#	while ( $alive eq 1 )
#	{
#		sleep $check;
		#$conn->privmsg($username, '!heartbeat');	
		#$self->say(
		#	who => $username,
		#	channel => "who",
		#	body => "?heartbeat",
		#);
		
#		print STDERR "heartbeat\n";
		
#		sleep 1;
		
#		if ( time()-$heartbeat gt 3*$check )
#		{
		      #exec( $^X, $0);
#		      exit(42);
#		}
		
#	}
#}

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
            		
			if ($commande eq 'help' or $commande eq 'h')
			{
				#&help($channel, $event->{'nick'});
				if ($event->{channel} ne 'msg')
				{
					my $body = "";
					my $rand = int(rand(3));
					$body = "$event->{who}: Je t'ai envoyé un message privé mon p'tit chou ! :-)" if ( $rand == 0 );
					$body = "$event->{who}: Regarde tes MP et tu sauras comment m'utiliser ;)" if ( $rand == 1 );
					$body = "$event->{who}: Viens, on va flirter en privé :P" if ( $rand == 2 );

					$self->say(
						channel => $channel,
						body => "$body",
					);
				}
				my @help;
				push(@help,"Voici la liste des commandes disponibles :");
				push(@help,"!help : Affiche ce manuel d'utilisation");
				push(@help,"!link http://url (ou !l ou !!) : Affiche le titre dde la page à l'adresse URL et l'indexe.");
				push(@help,"!last : Affiche le dernier lien posté.");
				push(@help,"!search motclé : Cherche dans la base de marjo21 en fonction du mot clé.");
				push(@help,"!bug new description : Envoie un bogue de fonctionnement à l'administrateur.");
				push(@help,"Pour consulter l'historique des liens postés, c'est par ici : $website");

				foreach (@help)
				{
					$self->say(
						who => $event->{who},
						channel => "msg",
						body => "$_",
					);
				}
				
			}

			if ($commande eq 'about')
			{
				if ($event->{channel} ne 'msg')
				{
					my $body = "";
					my $rand = int(rand(3));
					$body = "$event->{who}: Je t'ai envoyé un message privé mon p'tit chou ! :-)" if ( $rand == 0 );
					$body = "$event->{who}: Regarde tes MP et tu sauras comment m'utiliser ;)" if ( $rand == 1 );
					$body = "$event->{who}: Viens, on va flirter en privé :P" if ( $rand == 2 );
					
					$self->say(
						channel => $channel,
						body => "$body",
					);
				}
				my @about;
				push(@about,"Salut toi ! Je m'appelle $username, je suis en version $version. Je collecte les liens sur canal IRC $channel. Je suis codée en PERL par Adrien_D pour interagir avec toi, mon p'tit $event->{who} !");
				push(@about, "Si tu as envie de regarder mon site web, il se trouve à l'adresse $website et tu retrouveras tous les liens qui ont été postés sur $channel depuis le début. Il est codé en PHP.");
				push(@about, "Tu peux retrouver toutes les sources du projet (sous licence MIT) sur le GitHub d'Adrien_D, à l'adresse suivante : https://github.com/aaaaadrien/marjo21");
				push(@about,"Voilà, tu sais maintenant tout sur moi, ou presque, car je ne te filerai pas mon 06 ! Bises ! $username");

				foreach (@about)
				{
					$self->say(
						who => $event->{who},
						channel => "msg",
						body => "$_",
					);
				}	
				
			} # Fin !about
		
			if ($commande eq 'bonjour')
			{

				my $body = "";
				my $rand = int(rand(3));
				$body = "Bonjour $event->{who}" if ( $rand == 0 );
				$body = "Wesh $event->{who}" if ( $rand == 1 );
				$body = "Salut $event->{who}" if ( $rand == 2 );

				#&bonjour($channel, $event->{'nick'});
				if ( $event->{channel} eq 'msg' )
				{
					$self->say(
						who => $event->{who},
						channel => "msg",
						body => "$body",
					);
				}
				else
				{
					$self->say(
						channel => $channel,
						body => "$body",
					);
				}
			}

			if ($commande eq 'link' or $commande eq 'l' or $commande eq '!' )
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
									if ( "$event->{who}" eq "$row_ref->{user}" )
									{
										my $body = "";
										my $rand = int(rand(3));
										$body = "Je crois que $row_ref->{user} est atteint d'Alzeimer... Pour info : $row_ref->{title} (le $row_ref->{dateandtime})" if ( $rand == 0 );
										$body = "$row_ref->{user} est un poisson rougeuh, na-na-na-na-nèreuh ! Pour info : $row_ref->{title} (le $row_ref->{dateandtime})" if ( $rand == 1 );
										$body = "T'as besoin d'une barrette de RAM en plus dans la cervelle $row_ref->{user} ? Pour info : $row_ref->{title} (le $row_ref->{dateandtime})" if ( $rand == 2 );

										$self->say(
											channel => "$channel",
											body => "$body",
										);
									}
									else
									{
										my $body = "";
										my $rand = int(rand(3));
										$body = "Tu arrives en retard ... $row_ref->{user} l'a fait avant toi ! Pour info : $row_ref->{title} (le $row_ref->{dateandtime}) " if ( $rand == 0 );
										$body = "LOL ! $row_ref->{user} a été plus rapide que toi ! Pour info : $row_ref->{title} (le $row_ref->{dateandtime})" if ( $rand == 1 );
										$body = "Looser ! Paye un café à $row_ref->{user} qui vu le lien avant toi ! Pour info : $row_ref->{title} (le $row_ref->{dateandtime})" if ( $rand == 2 );
										$self->say(
											channel => "$channel",
											body => "$body",
										);
									
									}
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
							my $ua = LWP::UserAgent->new(agent => $useragent, ssl_opts => { verify_hostname => 0 });
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
								if ( $blacklisted ne 1)
								{
									#print $res->status_line, "\n";
									my $error = $res->status_line;
									$self->say(
										channel => "$channel",
										body => "Je ne peux pas indexer ce contenu, car le site me renvoie l'erreur suivante : $error",
									);
								} #Fin if( $blacklisted ne 1)
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

			if ($commande eq 'search' or $commande eq 's')
			{
				my @params = grep {!/^\s*$/} split(/\s+/, substr($text, length("!$commande")));
				if (defined($params[0]) && $params[0] ne '')
				{
					#print STDERR $params[0];
					#print STDERR $params[1];
					
					
					my $db_handle = DBI->connect("dbi:mysql:database=$db;host=$dbhost:$dbport;user=$dbuser;password=$dbpasswd");
					#my $sql = "SELECT * FROM links WHERE title LIKE '%$params[0]%' ORDER BY id";
					my $sql = "SELECT * FROM links WHERE ";
					my $nbkeywords = $#params;
					my $i=0;

					if ( $nbkeywords > 0)
					{
						for ( $i; $i < $nbkeywords ; $i++ )
						{
							#print STDERR $i;
							$sql = $sql."title LIKE \"%".$params[$i]."%\" AND ";
						}
						$sql = $sql."title LIKE \"%".$params[$i]."%\" ";
					}
					else
					{
						$sql = $sql."title LIKE \"%".$params[$i]."%\" ";
					}
					$sql = $sql."ORDER BY dateandtime DESC LIMIT 100";

					#print STDERR $sql;

					my $statement = $db_handle->prepare($sql);
					$statement->execute();

					my $num = $statement->rows;

					my $result;
					
					if ( $num < 6 )
					{
						if ( $num == 0 )
						{
							my $rand = int(rand(3));
							$result = "Il n'y a pas de résultats mon p'tit chou !" if ( $rand == 0 );
							$result = "J'ai rien pour toi ! Désolé !" if ( $rand == 1 );
							$result = "Je suis blonde, j'ai rien trouvé !" if ( $rand == 2 );


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
							if ( $event->{channel} ne 'msg' )
							{
								my $body = "";
								my $rand = int(rand(3));
								$body = "$event->{who} : Je t'ai envoyé les résultats de ta recherche mon p'tit chou !" if ( $rand == 0 );
								$body = "$event->{who} : Regarde tes MP, t'as un p'tit message coquin avec ta recherche !" if ( $rand == 1 );
								$body = "$event->{who} : Tous tes désirs sont réalité ! Regarde en privé ;) (et ça rime)" if ( $rand == 2 );

								$self->say(
									channel => "$channel",
									body =>  "$body",
								);
							}
							while (my $row_ref = $statement->fetchrow_hashref())
							{
								$result = "$row_ref->{title} ( $row_ref->{link} ) par $row_ref->{user} le $row_ref->{dateandtime}";
								#$conn->print("<$nick>\t| $result");
								#$conn->privmsg($channel,$result);
								$self->say(
									who => $event->{who},
									channel => "msg",
									body =>  "$result",
								);
							}
						}
					}
					else
					{
						my $urlgen = $website."/search.php?keywords=".$params[0];
						my $rand = int(rand(3));
						$result = "Il y a plus de 5 résultats. Je ne veut pas innonder IRC => $urlgen" if ( $rand == 0 );
						$result = "Oulà y en a trop pour moi ! Jette un oeil sur mon site $urlgen (et y a des photos de moi :P)" if ( $rand == 1 );
						$result = "On dit qu'une fille parle beaucoup c'est vrai, mais bon, là il y a trop à dire...Les résultats sont ici : $urlgen" if ( $rand == 2 );
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

			if ($commande eq 'reload')
			{
				# Pour éviter le déni de service
				#if ( $times+0 lt time() )
				#{
					if ( $event->{channel} eq 'msg' && ("$administrator" eq "" || "$event->{'who'}" eq "$administrator" ) )
					{
						$self->say(
							who => $event->{who},
							channel => "msg",
							body => "Je recharge mon programme...",
						);
						exec( $^X, $0);
					}
				#}

			} # Fin !reload

			if ($commande eq 'restart')
			{
				# Pour éviter le déni de service
				#if ( $times+0 lt time() )
				#{
					 if ( $event->{channel} eq 'msg' && ("$administrator" eq "" || "$event->{'who'}" eq "$administrator" ) )
					 {
					 	$self->say(
							who => $event->{who},
							channel => "msg",
							body => "Je redémarre mon programme...",
						);
						exit (3);
					}
				#}
			} # Fin !restart
			
			if ($commande eq 'update')
			{
				# Pour éviter le déni de service
				#if ( $times+0 lt time() )
				#{
					if ( $event->{channel} eq 'msg' && ("$administrator" eq "" || "$event->{'who'}" eq "$administrator" ) )
					{
						$self->say(
							who => $event->{who},
							channel => "msg",
							body => "Je mets à jour mon programme et je reviens...",
						);
						exec ( 'sh update-marjo21.sh' );		
						exit(2);
					}
				#}
			} # Fin !update

			if ($commande eq 'talk')
			{
				 if ( $event->{channel} eq 'msg' && ("$administrator" eq "" || "$event->{'who'}" eq "$administrator" ) )
				 {
					$text = substr($text, 6);
					$self->say(
						channel => $channel,
						body => $text,
					);
				 }
			} # Fin !talk

			if ($commande eq 'ip')
			{
				my $ua = LWP::UserAgent->new(agent => $useragent, ssl_opts => { verify_hostname => 0 });
				my $response = $ua->get('https://api.ipify.org/');
				my $ip = $response->decoded_content;
					$self->say(
						who => $event->{who},
						channel => "msg",
						body => "$ip",
					);
			}

			if ($commande eq 'bug')
			{
				my $subcommand = substr($text, 5, 3);
				my $pseudo = $event->{who};
				my $fullcommand = substr($text, 0, 9);
				
				if ( $subcommand eq 'new' or $subcommand eq 'add' )
				{

					if ( $fullcommand eq '!bug new ' or $fullcommand eq '!bug add ')
					{
						my $message = substr ($text, 9);
					
						my $db_handle = DBI->connect("dbi:mysql:database=$db;host=$dbhost:$dbport;user=$dbuser;password=$dbpasswd");
						my $statement = $db_handle->prepare("SET NAMES utf8;");
						$statement->execute();
						my $sql = "INSERT INTO bugs(dateandtime,user,message,solved) VALUES (NOW(),?,?,0)";
						$statement = $db_handle->prepare($sql);
						$statement->execute($pseudo,$message,);
						$db_handle->disconnect();
				
						if ( $event->{channel} eq 'msg' )
						{
							$self->say(
								who => $pseudo,
								channel => 'msg',
								body => "Bug enregistré",
							);
						}
						else
						{
							$self->say(
								channel => $channel,
								body => "Bug enregistré !",
							);
						}
					}
					else
					{
						if ( $event->{channel} eq 'msg' )
						{
							$self->say(
								who => $event->{who},
								channel => "msg",
								body =>  "La commande !bug $subcommand n'est oas complète...",
							);
						}
						else
						{
	
							$self->say(
								who => $event->{who},
								channel => "$channel",
								body =>  "La commande !bug $subcommand n'est oas complète...",
							);
						}
					}
				} # Fin if $subcommand eq new or $subcommand eq add

				if ($subcommand eq 'see')
				{
					if ( $event->{channel} eq 'msg' && ("$administrator" eq "" || "$event->{'who'}" eq "$administrator" ) )
					{
						
						my $db_handle = DBI->connect("dbi:mysql:database=$db;host=$dbhost:$dbport;user=$dbuser;password=$dbpasswd");
						my $sql = "SELECT * FROM bugs WHERE solved=0";
						
						my $statement = $db_handle->prepare($sql);
						$statement->execute();

						my $num = $statement->rows;
						my $result;

						if ( $num ne 0 )
						{
							while (my $row_ref = $statement->fetchrow_hashref())
							{
								$result = "$row_ref->{id} : $row_ref->{message} (par $row_ref->{user} le $row_ref->{dateandtime})";
								
								$self->say(
									who => $event->{who},
									channel => 'msg',
									body => $result,
								);
							}
						}
						else
						{
							$self->say(
								who => $pseudo,
								channel => 'msg',
								body => "Il n'y a pas de bug...",
							);
						}

					}
				} # Fin if $subcommand eq see
				
				if ($subcommand eq 'del')
				{
					if ( $event->{channel} eq 'msg' && ("$administrator" eq "" || "$event->{'who'}" eq "$administrator" ) )
					{
						my $id = substr ($text, 9);
						if ( $id =~ /^[0-9]+$/ ) # Check if number
						{					
							my $db_handle = DBI->connect("dbi:mysql:database=$db;host=$dbhost:$dbport;user=$dbuser;password=$dbpasswd");
							my $sql = "UPDATE bugs SET solved=1 WHERE id=$id";
							my $statement = $db_handle->prepare($sql);
							$statement->execute();

							$self->say(
								who => $pseudo,
								channel => 'msg',
								body => "Bug #$id supprimé!",
							);
						} #End if check number
					}
				} # Fin if $subcommand eq del

				if ($subcommand ne 'new' and $subcommand ne 'add' and $subcommand ne 'see' and $subcommand ne 'del')
				{
					if ( $event->{channel} eq 'msg' )
					{
						$self->say(
							who => $event->{who},
							channel => "msg",
							body =>  "La sous-commande n'a pas été reconnue ou est absente...",
						);
					}
					else
					{

						$self->say(
							who => $event->{who},
							channel => "$channel",
							body =>  "La sous-commande n'a pas été reconnue ou est absente...",
						);
					}
				}

			} # Fin !bug

			my @commands = ('last','link','l','!','bonjour','help','search','talk','bug', 'about', 's', 'h', 'ip');
			unless ( $commande ~~ @commands ) # unless : execute if condition is false
			#if ( $commande ne 'last' && $commande ne 'link' && $commande ne 'l' && $commande ne '!' && $commande ne 'bonjour' && $commande ne 'help' && $commande ne 'search' && $commande ne 'talk' && $commande ne 'bug' )
			{ 
				#$conn->privmsg($channel,"$event->{'nick'} : Commande inconnue. Taper !help pour plus d'informations...");

				if ( $event->{channel} eq 'msg' )
				{
					$self->say(
						who => $event->{who},
						channel => "msg",
						body =>  "$event->{who} : Commande inconnue. Taper !help pour plus d'informations...",
					);
				}
				else
				{
					$self->say(
						who => $event->{who},
						channel => "$channel",
						body =>  "$event->{who} : Commande inconnue. Taper !help pour plus d'informations...",
					);
				}
			}
		}		
        	else
        	{
			# On avait un ! en début de ligne, mais non suivi d'un nom de commande
			print "pas une commande \n";
       		} # if ($commande ne '')
			
	} # if (substr($text, 0, 1) eq '!')

	if ( $text eq "?heartbeat" )
	{
		if ( "$event->{'who'}" eq "$username" )
		{
			$lastheart = time();
			#print STDERR "heartbeat !!!\n";
		}
	}  # Fin ?heartbeat

return undef;
} # Fin said




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
