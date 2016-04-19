#!/bin/bash
#PBS -l mem=12GB,nodes=1:ppn=12,walltime=1:00:00
#PBS -N splitNtrim
#PBS -M ckj239@nyu.edu
#PBS -j oe
#PBS -t 1-16

module purge

source /home/ckj239/AppliedGenomics/Project/pipeline.conf

srr="$(head -$PBS_ARRAYID $droughtInfo | tail -1 | awk '{print $1}')"

alignDIR=$dataDIR/$srr\_alignment
alignFile=$srr\Aligned.out.sam

splitFile=$srr\_sms.bam
realignedFile=$srr\_smsR.bam

echo "Sample Information"
echo "========================"
echo "Array ID:" $PBS_ARRAYID
echo "Home directory:" $homeDIR
echo "Data directory:" $dataDIR
echo "Current directory:" $PWD
echo "SRR sample:" $srr
echo "reference genome:" $reference
echo "========================"

module load gatk/3.1-1

echo "gatk module loaded: gatk/3.1-1"

echo "Input bam:" $splitFile
echo "Output bam:" $realignedFile

# Identify regions to be realigned

java -Xmx2g -jar GenomeAnalysisTK.jar \
-T RealignerTargetCreator \
-R $reference \
-I $splitFile \
-o realigner.intervals

__ERR__=$?
echo "RealignerTargetCreator error:" $__ERR__

# Perform the realignment
# must use the same input files used above (-I, -R)

java -Xmx2g -jar GenomeAnalysisTK.jar \
-T IndelRealigner \
-R $reference \
-I $splitFile
-targetIntervals realigner.intervals \
-o $realignedFile

__ERR__=$?
echo "IndelRealigner error:" $__ERR__

echo "========================"
