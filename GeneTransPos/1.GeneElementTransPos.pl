use strict;
use warnings;
use Cwd;

my $GENEFile      = shift; # 'WheatTuGeneElements.gff';
my $GenePosFile   = shift; # 'TuAll-Gene.sam.simple.dupli.filter';

my %GeneContigHash = ();
my %OldOffsetHash  = ();
my %OldLengthHash  = ();

open(INFILE,  "$GenePosFile") || die "cannot open file $GenePosFile\n" ;

    while(<INFILE>)
    {
		my($line) = $_;
		chomp($line);
        
        # TuG1812G0100000529.01	+	Tu1	25070647
        # TuG1812G0100000528.01	+	Tu1	25065744
        # TuG1812G0100000527.01	-	Tu1	25056412
        # TuG1812G0100000526.01	-	Tu1	25531857
        # TuG1812G0100000530.01	+	Tu1	25038874
        # TuG1812G0100000531.01	-	Tu1	25580809
        # TuG1812G0100000532.01	+	Tu1	25585519
        # TuG1812G0100000533.01	-	Tu1	25587869
        # TuG1812G0100000534.01	-	Tu1	25599233
        # TuG1812G0100000535.01	+	Tu1	25604594
        # TuG1812G0100001321.01	+	Tu1	120079288
        # TuG1812G0100001320.01	+	Tu1	120197258
        # TuG1812G0100001319.01	-	Tu1	120290607
        # TuG1812G0100001318.01	-	Tu1	120435965
        
        my ( $GeneName, $Direction , $ChromName, $NewOffset ) = split ( /\t/ , $line );
        $GeneName =~ s/\.\d+//;
        
        $GeneContigHash{$GeneName} = $line;

	} #while end

close(INFILE) ;

my $GeneCount    = 0;

open(INFILE,  "$GENEFile") || die "cannot open file $GENEFile\n" ;

    while(<INFILE>)
    {
		my($line) = $_;
		chomp($line);
        
        # Tu1	IGDB_Final	gene	51108	54347	.	+	.	ID=TuG1812G0100000001.01;Name=TuG1812G0100000001.01;
        # Tu1	IGDB_Final	mRNA	51108	54347	.	+	.	ID=TuG1812G0100000001.01.T01;Name=TuG1812G0100000001.01.T01;Parent=TuG1812G0100000001.01;
        # Tu1	IGDB_Final	exon	51108	52476	.	+	-1	ID=exon464434;Name=exon464434;Parent=TuG1812G0100000001.01.T01
        # Tu1	IGDB_Final	exon	53069	53719	.	+	1	ID=exon464435;Name=exon464435;Parent=TuG1812G0100000001.01.T01
        # Tu1	IGDB_Final	exon	53808	54347	.	+	-1	ID=exon464436;Name=exon464436;Parent=TuG1812G0100000001.01.T01
        # Tu1	IGDB_Final	start_codon	51303	51305	.	+	.	Parent=TuG1812G0100000001.01.T01
        # Tu1	IGDB_Final	CDS	51303	52476	.	+	-1	ID=cds464434;Name=cds464434;Parent=TuG1812G0100000001.01.T01
        # Tu1	IGDB_Final	CDS	53069	53373	.	+	1	ID=cds464435;Name=cds464435;Parent=TuG1812G0100000001.01.T01
        # Tu1	IGDB_Final	stop_codon	53371	53373	.	+	.	Parent=TuG1812G0100000001.01.T01
        # Tu1	IGDB_Final	five_prime_utr	51108	51302	.	+	.	ID=5utr119977;Parent=TuG1812G0100000001.01.T01
        # Tu1	IGDB_Final	three_prime_utr	53374	53719	.	+	.	ID=3utr119977;Parent=TuG1812G0100000001.01.T01
        # Tu1	IGDB_Final	three_prime_utr	53808	54347	.	+	.	ID=3utr119977;Parent=TuG1812G0100000001.01.T01

        my ( $ContigName, $Info1, $Info2 , $Start , $End, $Info3, $Direct, $Info4, $InfoID ) = split ( /\t/ , $line, 9 );
        
        if ( $Info1 eq 'chromosome' ) {
            print $line."\n";
            next;
        }
        
        my $GeneName = '';

        if ( $InfoID =~ /Parent=(.*?)\.01/ ) {
            $GeneName = ( $InfoID =~ /Parent=(.*?)\.01/ )[0];
        }else {
            $GeneName = ( $InfoID =~ /ID=(.*?)\.01/ )[0];
        }

        if ( $Info2 eq 'gene' ) {
            $OldOffsetHash{$GeneName} = $Start;
            $OldLengthHash{$GeneName} = $End - $Start + 1;
        }
        
        # if ( ! defined( $GeneName ) ) {
            # print STDERR $line."\n";
        # }
        
        if ( exists( $GeneContigHash{$GeneName} ) ) {
        
            my ( $GeneNameALT, $Direction , $ChromName, $NewOffset ) = split ( /\t/ , $GeneContigHash{$GeneName} );
            
            if ( $Direct eq $Direction ) {
                print $ChromName."\t";
                print $Info1."\t";
                print $Info2."\t";
                print ( $Start - $OldOffsetHash{$GeneName} + $NewOffset );
                print "\t";
                print ( $End - $OldOffsetHash{$GeneName} + $NewOffset );
                print "\t";
                print $Info3."\t";
                print $Direct."\t";
                print $Info4."\t";
                print $InfoID;
                print "\n";
            }else {
                print $ChromName."\t";
                print $Info1."\t";
                print $Info2."\t";
                print ( $OldLengthHash{$GeneName} - ( $End - $OldOffsetHash{$GeneName} )    + $NewOffset - 1 );
                print "\t";
                print ( $OldLengthHash{$GeneName} - ( $Start - $OldOffsetHash{$GeneName} )  + $NewOffset - 1 );
                print "\t";
                print $Info3."\t";
                print $Direction."\t";
                print $Info4."\t";
                print $InfoID;
                print "\n";

            }

        }

	} #while end

close(INFILE) ;

# foreach my $GeneName ( sort { $GeneNameHash{$a} <=> $GeneNameHash{$b} } keys %GeneNameHash ) {
    # print $GeneName."\t";
    # print $GeneNameHash{$GeneName}."\n";
# }