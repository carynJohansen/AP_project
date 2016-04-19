#!/bin/bash
#PBS -l mem=12GB
#PBs -l nodes=1:ppn=12
#PBS -l walltime=1:00:00
#PBS -N splitNtrim
#PBS -M ckj239@nyu.edu
#PBS -j oe
#PBS -t 1-16

module purge

source /home/ckj239/AppliedGenomics/Project/pipeline.conf

srr="$(head -$PBS_ARRAYID $droughtInfo | tail -1 | awk '{print $1}')"

cd $srr\_dir

alignDIR=$dataDIR/$srr\_alignment
alignFile=$srr\Aligned.out.sam
sortedFile=$srr\_s.bam
dupFile=$srr\_sm.bam
splitFile=$srr\_sms.bam
realignedFile=$srr\_smsR.bam

echo "Sample Information"
echo "========================"
echo "Array ID:" $PBS_ARRAYID
echo "Home directory:" $homeDIR
echo "Data directory:" $dataDIR
echo "Reference directory:" $referenceDIR
echo "Alignment directory:" $alignDIR
echo "Current directory:" $PWD
echo "SRR sample:" $srr
echo "reference genome:" $reference
echo "GFF file:" $gff
echo "========================"

module load gatk/3.1-1

echo "gatk module loaded: gatk/3.1-1"

echo "Input bam:" $splitFile
echo "Output bam:" $realignedFile

# this finds splicing junctions, splits the reads which overlap sjs
# realigns the split read to flanking exon regions before removing any part of 
# the realigned reads which overhang into the intron regions 

java -jar GenomeAnalysisTK.jar \
-T SplitNCigarReads \
-R $reference \
-I $dupFile \
-o $splitFile \
-U ALLOW_N_CIGARS \
-rf ReassignOneMappingQuality \
-RMQF 225 \
-RMQT 60
__ERR__=$?

echo "SplitNCigarReads error:" $__ERR__
