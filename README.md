# GenomeTransPos
Transfer genes and repeats and SNPs from old assembly to new assembly 

Scripts for transfering genes and repeats and SNPs from old assembly to new assembly 

1. Get sequences from old assembly using gff/vcf file etc.
2. Use bwa to align DNA sequence ( genes , repeats and context sequence around SNPs ) to new assembly
3. Change posotions in gff/vcf file from old positions to new positions
4. Get sequences from new assembly using gff/vcf file etc.
5. Compare these sequence to assure precision.

