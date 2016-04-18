#!/bin/bash
#PBS -l mem=12GB,nodes=1:ppn=12,walltime=1:00:00
#PBS -N splitNtrim
#PBS -M 

module purge

module load gatk/3.1-1

source /home/ckj239/AppliedGenomics/Project/pipeline.conf

# Identify regions to be realigned

java -jar GenomeAnalysisTK.jar \
-T RealignerTargetCreator \
-R reference.fasta \
-I input.bam \
-o realigner.intervals

# Perform the realignment
# must use the same input files used above (-I, -R)

java -jar GenomeAnalysisTK.jar \
-T IndelRealigner \
-R reference.fasta \
-I input.bam
-targetIntervals realigner.intervals \
-o realigned.bam



