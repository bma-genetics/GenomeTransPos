use warnings ;
use strict ;
use Bio::SeqIO;

my $ListFile = 'SNPIndel.pos';
my %GenePosition  = ();
my %GeneDirection = ();
my $CutLength = 500;

my $SNPNumber = 1;

open(INFILE,  "$ListFile") || die "cannot open file $ListFile\n" ;
	
    while(<INFILE>)
    {
		my($line) = $_;
		chomp($line);

        # Chr1	183692	AC
        # Chr1	183731	A
        # Chr1	2698936	G
        # Chr1	2698944	G
        # Chr1	3228808	C
        # Chr1	3228826	TCGATGAAATGCCAAGGA
        # Chr1	3228840	AGGACGATGATG

        my ( $Chrom, $Pos, $Base ) = split ( /\t/ , $line );
        
        my $SNPName = sprintf( "SNP%08d", $SNPNumber );
        
        # print $SNPName."\t";
        # print $Chrom."\t";
        # print $Pos."\t";
        # print $Base."\n";
        
        $GenePosition{$Chrom}{$Pos} = $SNPName."\t".$Base;
        
        $SNPNumber ++;
        
	} #while end

close(INFILE) ;

my $InputFile  = '02-WheatTuChromosome.fasta';
# my $OutputFile = 'wheatAGENESeq.fasta';

my $in    = Bio::SeqIO->new(-file => "$InputFile" ,    '-format' => 'Fasta');
# my $out   = Bio::SeqIO->new(-file => ">$OutputFile" ,  '-format' => 'Fasta');
my $Count = 0;

while ( my $seq = $in->next_seq() ) {

    my $Chrom = $seq->id;
    
    if ( exists( $GenePosition{$Chrom} ) ) {
        
        my %TempHash = %{ $GenePosition{$Chrom} };
        
        foreach my $Pos ( sort { $a <=> $b} keys %TempHash ) {

            my ( $SNPName , $Base ) = split( /\s+/ , $TempHash{$Pos} );
            
            my $PartSeq = $seq -> subseq( $Pos - $CutLength  , $Pos + $CutLength - 2 );
            
            $PartSeq =~ s/^[nN]{1,}//;
            $PartSeq =~ s/[nN]{1,}$//;
            
            print ">".$SNPName."\n";
            # print $Chrom."\t";
            # print $Pos."\t";
            # print $Base."\t";
            print $PartSeq."\n";
            $Count ++;
            # last if ( $Count > 1000 );

        }
        
    }
    
    # last if ( $Count > 1000 );
}
