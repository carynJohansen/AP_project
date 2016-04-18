#!/bin/bash
#PBS -l mem=12GB,nodes=1:ppn=12,walltime=1:00:00
#PBS -N splitNtrim
#PBS -M 

module purge
module load gatk

# this finds splicing junctions, splits the reads which overlap sjs
# realigns the split read to flanking exon regions before removing any part of 
# the realigned reads which overhang into the intron regions 

java -jar GenomeAnalysisTK.jar \
-T SplitNCigarReads \
-R reference.fasta \
-I input.bam \
-o output.bam \
-U ALLOW_N_CIGARS \
-rf ReassignOneMappingQuality \
-RMQF 225 \
-RMQT 60



