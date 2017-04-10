use warnings ;
use strict ;
use Bio::SeqIO;

my $VCFFile  = 'OldSNP.vcf';
my $ContextPosFile  = 'SNPContextPos.txt';
my $ConvertPosFile  = 'SNPCovertPos.txt';

my %SNPContextPosition  = ();
my %SNPContextRef       = ();

open(INFILE,  "$ContextPosFile") || die "cannot open file $ContextPosFile\n" ;
	
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
        
        $SNPContextPosition{$Chrom."\t".$Pos."\t".$RefBase} = $SNPName;
        $SNPContextRef{$SNPName}     = $RefBase;
        
	} #while end

close(INFILE) ;

my %SNPConvertPosition  = ();
my %SNPConvertRef       = ();

open(INFILE,  "$ConvertPosFile") || die "cannot open file $ConvertPosFile\n" ;
	
    while(<INFILE>)
    {
		my($line) = $_;
		chomp($line);

        next if ( $line =~ /^#/ );
        
        # SNP00000001	Tu1	183691	AC
        # SNP00000002	Tu1	183730	A
        # SNP00000003	Tu1	183759	G
        # SNP00000007	Tu1	994135	A
        # SNP00000008	Tu1	994139	C
        # SNP00000009	Tu1	994178	T
        # SNP00000010	Tu1	994463	G
        # SNP00000011	Tu1	994516	G
        # SNP00000012	Tu1	998656	A
        # SNP00000013	Tu1	998677	C
        
        my ( $SNPName, $Chr , $Pos , $Ref ) = split ( /\t/ , $line );

        $SNPConvertPosition{$SNPName} = $Chr."\t".$Pos;
        $SNPConvertRef{$SNPName} = $Ref;
        
	} #while end

close(INFILE) ;

open(INFILE,  "$VCFFile") || die "cannot open file $VCFFile\n" ;
	
    while(<INFILE>)
    {
		my($line) = $_;
		chomp($line);

        next if ( $line =~ /^#/ );
        
        # Tu1	183692	.	AC	A	7943.12	PASS	.	GT:AD:DP:GQ:PL	1/1:0,3:7:10:83,10,0	./.:.:.:.:.	0/1:0
        # Tu1	183731	.	A	G	33049.7	PASS	.	GT:AD:DP:GQ:PL	0/1:1,6:7:22:179,0,22	./.:.:.:.:.	1/1:0
        # Tu1	183760	.	G	A	32815.9	PASS	.	GT:AD:DP:GQ:PL	0/1:2,6:8:56:163,0,56	./.:.:.:.:.	1/1:0
        # Tu1	1410574	.	C	T	2744.33	PASS	.	GT:AD:DP:GQ:PL	0/0:4,0:4:12:0,12,160	0/0:10,0:10:30:0,
        # Tu1	1410576	.	C	A	2572.63	PASS	.	GT:AD:DP:GQ:PL	0/0:4,0:4:12:0,12,160	0/0:10,0:10:27:0,
        # Tu1	1410620	.	C	A	2678.58	PASS	.	GT:AD:DP:GQ:PL	0/0:4,0:4:12:0,12,157	0/0:10,0:10:21:0,
        # Tu1	1484515	.	A	G	9015.44	PASS	.	GT:AD:DP:GQ:PL	0/0:2,0:2:6:0,6,80	0/0:2,0:2:6:0,6,80	0

        
        my ( $Chrom, $Pos, $Info, $RefBase , $AltBase, $OtherInfo ) = split ( /\t/ , $line , 6 );
        
        if ( exists( $SNPContextPosition{$Chrom."\t".$Pos."\t".$RefBase} ) ) {
            
            my $SNPName = $SNPContextPosition{$Chrom."\t".$Pos."\t".$RefBase} ;

            if ( exists( $SNPConvertPosition{$SNPName} ) ) {
                
                # print $Chrom."\t".$Pos."\t".$RefBase."\t";
                # print $SNPName."\t";
                # print $SNPConvertPosition{$SNPName}."\t";
                # print $SNPConvertRef{$SNPName}."\t";
                # print "\n";
                
                my ( $NewChr , $NewPos ) = split ( /\s+/ , $SNPConvertPosition{$SNPName} );
                my ( $NewReference     ) = split ( /\s+/ , $SNPConvertRef{$SNPName} );
                
                if ( $NewReference eq $RefBase ) {
                    print $NewChr."\t";
                    print $NewPos."\t";
                    print $Info."\t";
                    print $RefBase."\t";
                    print $AltBase."\t";
                    print $OtherInfo."\n";
                }else{
                    print $NewChr."\t";
                    print $NewPos."\t";
                    print $Info."\t";
                    print $NewReference."\t";
                    $AltBase = reverse $AltBase;
                    $AltBase =~ tr/ACGTacgt/TGCAtgca/;
                    print $AltBase."\t";
                    print $OtherInfo."\n";
                }
                
            }

        }
	} #while end

close(INFILE) ;