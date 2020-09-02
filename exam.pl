use v5.26.2;
use Data::Dumper qw(Dumper);
use experimental "switch";


printHelp() if $#ARGV < 0;

for my $clia (@ARGV){
    state $i;
    given($clia){
        when("-m"){
                    
            my $path = @ARGV[$i+1];
            checkMasterfile($path);
        }
        when('-p'){}
        when('-h'){printHelp();}
    }
    $i++;
}


sub printHelp{
    say "                     __                              ";
    say "    ____  ___  _____/ /     ___  _  ______ _____ ___ ";
    say "   / __ \\/ _ \\/ ___/ /_____/ _ \\| |/_/ __ `/ __ `__ \\";
    say "  / /_/ /  __/ /  / /_____/  __/>  </ /_/ / / / / / /";
    say " / .___/\\___/_/  /_/      \\___/_/|_|\\__,_/_/ /_/ /_/ ";
    say "/_/                                                  ";
    say "";
    say "Usage:";
    say "perl exam.pl <options>";
    say "";
    say "Options";
    say "-m <path to masterfile>";
    say "-p <prefix> (if no prefix is supplied, the current date and time will be prepended to generated files)";
    say "-h print this help";
    say "";
}

sub checkMasterfile{
    my ($path) = @_;
    
    die "The file $path does not exist, and I can't go on without it." unless -e $path;
    say "received path for masterfile. Start processing it ...";
    
}

