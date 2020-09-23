use v5.32.0;
use experimental "switch";

use List::Util 'shuffle';

#-- Check if no Arguments are supplied
printHelp() if $#ARGV < 0;


#-- Global Scalars, Arrays, Hashes
our @questions;
my %questions;


for my $clia (@ARGV){
    state $i;
    given($clia){
        when("-m"){           
            my $path = @ARGV[$i+1];
            checkMasterfile($path);
            createOutputFile($path);
            scrambleAnswers($path);
        }
        when('-h'){printHelp();}
    }
    $i++;
}


sub printHelp{
    say q{
                         __                              
        ____  ___  _____/ /     ___  _  ______ _____ ___ 
       / __ \/ _ \/ ___/ /_____/ _ \| |/_/ __ `/ __ `__ \
      / /_/ /  __/ /  / /_____/  __/>  </ /_/ / / / / / /
     / .___/\___/_/  /_/      \___/_/|_|\__,_/_/ /_/ /_/ 
    /_/

    Usage:
    perl exam.pl <options>

    Options:
    -m <path to masterfile>
    -h print this help                                      
    }
}

sub checkMasterfile{
    my ($path) = @_;
    my $question_separator =~ /\_+/;
    
    die "The file $path does not exist, and I can't go on without it." unless -e $path;
    say "received path for masterfile. Start processing it ...";

    open( my $fh, '<', $path ) or die "could not open file";

    my $qi = 1;

    while (my $line = <$fh>){
        if($line =~ m/([0-9]+\.).*:*\.*(\?|\.{1,3}|:)/){
            chomp $line;
            $questions{$qi} = $line;
            $qi++;
        }
    }

    # print map { "$_ => $questions{$_}\n" } keys %questions;

    while ( (my $k, my $v) = each %questions ) {
    print "$k => $v\n";
}

}

sub createOutputFile(){

    my ($path) = @_;

    # Must be prepended with YYYYMMDD-HHMMSS and then followed by the original filename
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
    my $now = sprintf("%04d%02d%02d-%02d%02d%02d", $year+1900, $mon+1, $mday, $hour, $min, $sec);
    print "$now\n";

    # Get Filename from Path
    my $input_filename= substr($path, rindex($path,"/")+1, length($path)-rindex($path,"/")-1);
    print "$input_filename\n";

    my $new_filename = $now . '-' . $input_filename;
    print "$new_filename\n";

}

sub scrambleAnswers(){

    my ($fh_out) = @_;
    my @possible_answers;
    
    # First read all lines to array
    open my $temp, '<', $fh_out;
    chomp(my @lines = <$temp>);
    close $temp;

    # Iterate over all lines in the file and check for Questions and Answers. Each Question 
    # with answers is then added to a array [@possible_answers] as a hash
    for (0..$#lines){

        # first check if a new question starts. A Question usually starts with a digit 
        # followed by a point like 1.
        if( @lines[$_] =~  /^\d+\./){
            print "new Question\n";
            push @possible_answers, {indices => [] };
        }
        # check if the current line is an answer. An answer typically starts with a [.
        elsif( @lines[$_] =~  /\[\s*/x){

            #Remove th e solution marker (x,X) from the answer. and add the answer to current question.
            @lines[$_] =~ s/ \[ [x,X] /\[ /x;
            if($#possible_answers >=0 ){
                push $possible_answers[-1]->{indices}->@*, $_; #TODO CHANGE THIS ONE PLAGIARISM
            }
        }
    }

    #TODO CHANGE THIS ONE PLAGIARISM
    for(@possible_answers){
        $fh_out->@[ $_->{indices}->@* ] = $fh_out->@[ shuffle ($_->{indices}->@*) ];
    }
}