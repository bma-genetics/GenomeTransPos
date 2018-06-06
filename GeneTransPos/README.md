
# GeneTransPos

Transfer genes from old assembly to new assembly 
Scripts for transfering genes from old assembly to new assembly 

## 1. Get sequences from old assembly using gff/vcf file etc.
eg. WheatTu.gene.fasta
eg. WheatTuGeneElements.gff

## 2. Use bwa to align DNA sequence ( genes , repeats and context sequence around SNPs ) to new assembly
```
time bwa mem -t 1 Tu1.fasta WheatTu.gene.fasta > Tu1-Gene.sam
time bwa mem -t 1 Tu2.fasta WheatTu.gene.fasta > Tu2-Gene.sam
time bwa mem -t 1 Tu3.fasta WheatTu.gene.fasta > Tu3-Gene.sam
time bwa mem -t 1 Tu4.fasta WheatTu.gene.fasta > Tu4-Gene.sam
time bwa mem -t 1 Tu5.fasta WheatTu.gene.fasta > Tu5-Gene.sam
time bwa mem -t 1 Tu6.fasta WheatTu.gene.fasta > Tu6-Gene.sam
time bwa mem -t 1 Tu7.fasta WheatTu.gene.fasta > Tu7-Gene.sam

cat \*.sam | awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$6"\t"$12"\t"$14}' | grep "NM:i:0" | awk '{if($5~/^[0-9]+M$/)print}' > TuAll-Gene.sam.simple
```

## 3. Change posotions in gff/vcf file from old positions to new positions
```
time perl 1.simpleFindBestPick.pl TuAll-Gene.sam.simple > TuAll-Gene.sam.simple.dupli.filter
time perl 2.GeneElementTransPos.pl WheatTuGeneElements.gff TuAll-Gene.sam.simple.dupli.filter > WheatTu.gene.gff
```
