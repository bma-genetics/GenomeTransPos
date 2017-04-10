use warnings ;
use strict ;

my $OldPosFile  = 'SNPContextPos.txt';
my $NewPostFile = 'Tu1-SNP.sam.simple.filter';
my %SNPPosition  = ();
my %SNPBase      = ();
my %SNPOffset    = ();

open(INFILE,  "$OldPosFile") || die "cannot open file $OldPosFile\n" ;
	
    while(<INFILE>)
    {
		my($line) = $_;
		chomp($line);

        # SNP00000001	Tu1	183692	AC	500	500	ATATGTG
        # SNP00000002	Tu1	183731	A	500	500	AACAAAA
        # SNP00000003	Tu1	183760	G	500	500	TGAATGA
        # SNP00000004	Tu1	1410574	C	500	500	TATGTAC
        # SNP00000083	Tu1	5303851	C	403	500	NNNNNNNNNN
        # SNP00000084	Tu1	5303854	C	406	500	NNNNNNNNNN
        # SNP00000085	Tu1	5303934	A	486	500	NNNNNNNNNN
        
        my ( $SNPName , $Chrom, $Pos, $RefBase , $SNPLeftOffset , $SNPRightOffset, $Other ) = split ( /\s+/ , $line );
        
        $SNPPosition{$SNPName} = $Chrom."\t".$Pos,;
        $SNPBase{$SNPName}     = $RefBase;
        $SNPOffset{$SNPName}   = $SNPLeftOffset."\t".$SNPRightOffset;
        
	} #while end

close(INFILE) ;

open(INFILE,  "$NewPostFile") || die "cannot open file $NewPostFile\n" ;
	
    while(<INFILE>)
    {
		my($line) = $_;
		chomp($line);

        # SNP00000001	+	Tu1	183192
        # SNP00000002	+	Tu1	183231
        # SNP00000003	+	Tu1	183260
        # SNP00000007	+	Tu1	993636
        # SNP00000008	+	Tu1	993640
        
        my ( $SNPName , $Direction, $NewChr, $NewOffset ) = split ( /\s+/ , $line );
        
        my ( $Chrom , $Pos ) = split( /\s+/ , $SNPPosition{$SNPName} );
        my ( $RefBase ) = $SNPBase{$SNPName};
        my ( $SNPLeftOffset , $SNPRightOffset ) = split( /\s+/ , $SNPOffset{$SNPName} );
        
        if ( $Direction eq '+' ) {
        
            print $SNPName."\t";
            print $NewChr."\t";
            print ( $SNPLeftOffset + $NewOffset - 1 );
            print "\t";
            print $RefBase;
            print "\n";
        
        }else {
        
            print $SNPName."\t";
            print $NewChr."\t";
            print $SNPRightOffset + $NewOffset - 1 - length( $RefBase ) + 1 ;
            print "\t";
            
            $RefBase = reverse $RefBase;
            $RefBase =~ tr/ACGTacgt/TGCAtgca/;
            print $RefBase;
            print "\n";
        
        }
        
	} #while end

close(INFILE) ;