use warnings ;
use strict ;
use Bio::SeqIO;

my $ListFile = 'SNPIndel.pos';
my %GenePosition  = ();
my %GeneDirection = ();

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
        
        $GenePosition{$Chrom}{$Pos} = $Base;
        
	} #while end

close(INFILE) ;

my $InputFile  = '02-WheatTuChromosome.fasta';
# my $OutputFile = 'wheatAGENESeq.fasta';

my $in    = Bio::SeqIO->new(-file => "$InputFile" ,    '-format' => 'Fasta');
# my $out   = Bio::SeqIO->new(-file => ">$OutputFile" ,  '-format' => 'Fasta');
my $Count = 0;

while ( my $seq = $in->next_seq() ) {

    my $Contig = $seq->id;
    
    if ( exists( $GenePosition{$Contig} ) ) {
        my %TempHash = %{ $GenePosition{$Contig} };
        foreach my $Pos ( sort { $a <=> $b} keys %TempHash ) {

            my $Base             = $TempHash{$Pos};
            
            my $PartSeq = $seq -> subseq( $Pos - 1  , $Pos + length($Base) - 2 );
            
            print $Contig."\t";
            print $Pos."\t";
            print $Base."\t";
            print $PartSeq."\n";
            $Count ++;
            # last if ( $Count > 100 );
        }
    }
    # last if ( $Count > 100 );
}
