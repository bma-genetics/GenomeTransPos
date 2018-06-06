use strict;
use warnings;
use Cwd;

my $InputFile = 'TuS-Gene.sam.simple';

my %GeneHash = ();

open(INFILE,  "$InputFile") || die "cannot open file $InputFile\n" ;

    while(<INFILE>)
    {
		my($line) = $_;
		chomp($line);
        
        # TuG1812G0100000529.01	0	Tu1	25070647	1113M	NM:i:0	AS:i:1113
        # TuG1812G0100000528.01	0	Tu1	25065744	597M	NM:i:0	AS:i:597
        # TuG1812G0100000527.01	16	Tu1	25056412	1233M	NM:i:0	AS:i:1233
        # TuG1812G0100000526.01	16	Tu1	25531857	3343M	NM:i:0	AS:i:3343
        # TuG1812G0100000530.01	0	Tu1	25038874	4336M	NM:i:0	AS:i:4336
        # TuG1812G0100000531.01	16	Tu1	25580809	1464M	NM:i:0	AS:i:1464
        # TuG1812G0100000532.01	0	Tu1	25585519	936M	NM:i:0	AS:i:936
        # TuG1812G0100000533.01	16	Tu1	25587869	2410M	NM:i:0	AS:i:2410
        
        my ( $GeneName, $Direct, $Chrom , $Position , $CIGAR ) = split ( /\t/ , $line );
        
        my $Length    = 0;
        my $Direction = '';
        
        if ( $Direct == 0 ) {
            $Direction = '+';
        }elsif ( $Direct == 16 ) {
            $Direction = '-';
        }else{
            next;
            # print STDERR $line."\n"
        }
        
        if ( $CIGAR =~ m/^(\d+)M$/) { # 完全比对上的情况
                $Length = $1;
        }else{
            # print STDERR $line."\n";
            # print STDERR $CIGAR."\n";
            # next;
        } # if end
        
        # my $OriginChr  = ( $GeneName =~ /G0(\d)/ )[0];
        my $CurrentChr = ( $Chrom    =~ /Tu(\S+)/ )[0];
        
        # if ( $OriginChr == $CurrentChr ) {
        if ( $CurrentChr eq 'Ungrouped' ) {
            $GeneHash{$GeneName} = $GeneName."\t".$Direction."\t".$Chrom."\t".$Position;
        }else{
            if ( ! exists( $GeneHash{$GeneName} ) ) {
                $GeneHash{$GeneName} = $GeneName."\t".$Direction."\t".$Chrom."\t".$Position;
            }
        }
        
        # print $GeneName."\t";
        # print $Direction."\t";
        # print $Chrom."\t";
        # print $Position."\n";
        
        # print $Position + $Length - 1 ;
        # print "\t";
        # print $Length;
        # print "\n";

        
	} #while end

close(INFILE) ;

foreach my $GeneName ( keys %GeneHash ) {
    print $GeneHash{$GeneName}."\n";
}