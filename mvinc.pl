#!/usr/bin/perl -w
sub usage{
	print "usage: mvinc <N> <files...>\n";
	print "\n";
	print "   N - increase/decrease each file number by N\n";
	print "   files - a list of files like *.txt, files\n";
	print "           without a valid counter are ignored\n";
	print "\n";
}
my $argc = @ARGV;
if($argc < 2){
	usage();
	exit;
}
if(!($ARGV[0] =~ /^[+-]?\d+$/)){
	print "First argument is no valid number\n";
	usage();
	exit;
}
my $N = $ARGV[0];
my @files;

#check if all files exist
for($i=1;$i<$argc;$i++){
	if(!(-e $ARGV[$i])){
		print "File ".$ARGV[$i]." does not exist.\n";
		usage();
		exit;
	}else{
		push(@files, $ARGV[$i]);
	}
}
		

my @arr;
foreach my $f (@files){ 
	my $re_last_num = "([0-9]+)(?!.*[0-9])";
	if($f =~ m/$re_last_num/g){  #find last occurence of a number
    my $str = $f;
    my $n=$1+$N;  #new counter
    if($n < 0){
			print "Warning: negative number (will be written as -X in new file name\n";
    }
    $f=~s/$re_last_num/$n/g; 
		#print "$str ... $f\n"; 
		#avoid overwriting an existing file -> temporary new files
    print "mvinc $str $f\n";
    system("mv $str $f.quacktmp"); 
    push(@arr, "$f.quacktmp");
  } 
}; 

foreach my $f (@arr){ 
	my $str = $f; 
	$f=~s/\.quacktmp//; 
	if( -e $f){
		print "warning: file $f already exists!\n";
	}
	system("mv $str $f"); 
}
