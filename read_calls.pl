#!/usr/bin/perl -w
#
# read_calls.pl
# 
# Synopsis:
# Script is run as a service daemon. It connects to the Fritz!Box Fon Ata
# (port 1012) and receives the calling string (number of the party calling 
# in). This number is passed on to another program. I.e. this could be an 
# Jabber client or a "look who called list".
# 
# Requirements:
# - must be able to reach tcp port 1012 on your FB
# - activate call monitor on FB by dialing #96*5*
# - required perl package
#
# Licence: GPL2
#
# History:
# ver. 0.1 - 20060401 - Lars G. Sander, Zuerich
# First public release.
# ver. 0.2 - 20060510 - Ulrich Dangel <fritzbox@spamt.net>
# Added telefon book support
# ver. 0.3 - 20110904 - Andreas Orthey
# Added reverse lookup via das-örtliche.de, added logfile support
# and some notifier tweaks, monitoring of outcoming phone calls for ubuntu 11.X

use IO::Socket;
use LWP::UserAgent;
use POSIX qw(strftime);
use warnings;
use strict;

my $FRITZBOX="fritz.box";
my $FRITZPORT=1012;
my $EXTPRO="notify-send";
my $EXT_ARG_TIME = "-t";
my $EXT_ARG_TIMEDURATION = "5"; #ms, 0 means unlimited display
my $EXT_ARG_TITLE = "--icon=gtk-add";
my $EXT_TITLE = "Phone Call";
my $LOGFILE="$ENV{HOME}/.phonelogging";


sub reverse_lookup{
	
	my $useragent = 'Mozilla/5.0 (Windows NT 6.1; rv:6.0) Gecko/20110814 Firefox/6.0';

	my $browser = LWP::UserAgent->new;

	my $nr = $_[0];
	my $respond = $browser->get("http://www3.dasoertliche.de/Controller?form_name=search_inv&buc=&kgs=&buab=&zbuab=&page=5&context=4&action=43&js=no&ph=$nr&image=")->content;
	
	if($respond =~ m/leider nicht erfolgreich/ig)
	{

		#print "could not find number $nr\n";
	}else{

		if($respond=~ m/preview\" onclick=\"logDetail\(\)\">(.+)/ig)
		{
			my $name = $1;
			$name =~ s/&nbsp;/ /ig;
			$name =~ s/\R//g;
			print $name."\n";
			
			return $name;
		}

		
	}
	return "unknown";
}

my $sock = new IO::Socket::INET (
        PeerAddr => $FRITZBOX,
        PeerPort => $FRITZPORT,
        Proto => 'tcp'
        );
        die "Could not create socket: $!\n" unless $sock;
 

my @args = ($EXTPRO, $EXT_ARG_TIME, $EXT_ARG_TIMEDURATION, $EXT_ARG_TITLE, $EXT_TITLE , "FritzBox! application started, listening at ".$FRITZBOX." port ".$FRITZPORT);

system(@args); 


while(<$sock>) {
	print $_;
        if ($_ =~ /RING/){
                my @C = split(/;/);
                my $nr=$C[3];
		my $name = &reverse_lookup($nr);
		
                my @args = ($EXTPRO, $EXT_ARG_TIME, $EXT_ARG_TIMEDURATION, $EXT_ARG_TITLE, $EXT_TITLE , "Call from ".$nr." (".$name.")");
		#print @args."\n";                
		system(@args); 

		#write to log file

		my $now_string = strftime "%Y %b %e %a %H:%M:%S", localtime;
		my $log = $now_string." Call from ".$nr." (".$name.")";

		system("echo \"$log\" >> $LOGFILE");
        }
        if ($_ =~ /[^S]CONNECT/){
                my @C = split(/;/);
                my $nr=$C[4];
		my $name = &reverse_lookup($nr);
		
                my @args = ($EXTPRO, $EXT_ARG_TIME, $EXT_ARG_TIMEDURATION, $EXT_ARG_TITLE, $EXT_TITLE , "Call to ".$nr." (".$name.")");
                #print @args."\n";   
		system(@args); 

		#write to log file

		my $now_string = strftime "%Y %b %e %a %H:%M:%S", localtime;
		my $log = $now_string." Call to ".$nr." (".$name.")";

		system("echo \"$log\" >> $LOGFILE");
        }

}


