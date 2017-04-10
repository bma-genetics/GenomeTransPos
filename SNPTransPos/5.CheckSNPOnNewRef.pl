use warnings ;
use strict ;
use Bio::SeqIO;

my $ListFile = 'SNPCovertPos.txt';

my %SNPPosition  = ();
my %SNPRef       = ();

open(INFILE,  "$ListFile") || die "cannot open file $ListFile\n" ;
	
    while(<INFILE>)
    {
		my($line) = $_;
		chomp($line);

        next if ( $line =~ /^#/ );
        
        # SNP00000001	Tu1	183691	AC
        # SNP00000002	Tu1	183730	A
        # SNP00000003	Tu1	183759	G
        # SNP00000052	Tu1	1513552	A
        # SNP00000053	Tu1	1513554	A
        # SNP00000054	Tu1	1513627	T
        # SNP00000036	Tu1	4597096	C
        # SNP00000037	Tu1	4597114	TCGATGAAATGCCAAGGA
        # SNP00000038	Tu1	4597128	AGGACGATGATG
        
        my ( $SNPName, $Chr , $Pos , $Ref ) = split ( /\t/ , $line );

        $SNPPosition{$Chr}{$Pos} = $SNPName;
        $SNPRef{$Chr}{$Pos} = $Ref;
        
	} #while end

close(INFILE) ;

my $InputFile  = '/public/share/bma/20160202NewData/NewConnectMatePair01/GeneticMatePairLink3-2-1-Hybrid/AGP/SequenceConcat600BAC/ChrRefIndex/Tu1.fasta';
# my $OutputFile = 'wheatAGENESeq.fasta';

my $in    = Bio::SeqIO->new(-file => "$InputFile" ,    '-format' => 'Fasta');
# my $out   = Bio::SeqIO->new(-file => ">$OutputFile" ,  '-format' => 'Fasta');

my $Count = 0;

while ( my $seq = $in->next_seq() ) {

    my $Chr = $seq->id;
    
    if ( exists( $SNPRef{$Chr} ) ) {
        my %TempHash = %{ $SNPRef{$Chr} };
        foreach my $Pos ( keys %TempHash ) {
            my $Ref         = $TempHash{$Pos};
            my $PartSeq = $seq -> subseq( $Pos , $Pos + length($Ref) - 1 );
            my $SNPName = $SNPPosition{$Chr}{$Pos};
            print $SNPName."\t";
            print $Chr."\t";
            print $Pos."\t";
            print $Ref."\t";
            print $PartSeq."\n";
            $Count ++;
            # last if ( $Count > 100 );
        }
    }
    # last if ( $Count > 100 );
}
