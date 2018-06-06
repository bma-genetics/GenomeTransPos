
# GeneTransPos
Transfer genes from old assembly to new assembly 

Scripts for transfering genes from old assembly to new assembly 

1. Get sequences from old assembly using gff/vcf file etc.
WheatTu.gene.3.fasta

2. Use bwa to align DNA sequence ( genes , repeats and context sequence around SNPs ) to new assembly
```
cat \*.sam | awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$6"\t"$12"\t"$14}' | grep "NM:i:0" | awk '{if($5~/^[0-9]+M$/)print}' > TuAll-lnc.sam.simple
```

3. Change posotions in gff/vcf file from old positions to new positions

4. Get sequences from new assembly using gff/vcf file etc.

5. Compare these sequence to assure precision.

