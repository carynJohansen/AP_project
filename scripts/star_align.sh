#!/bin/bash
#PBS -l nodes=1:ppn=12
#PBS -l mem=24GB
#PBS -l walltime=5:00:00
#PBS -N align_STAR
#PBS -M ckj239@nyu.edu
#PBS -j oe
#PBS -t 1-9

source /home/ckj239/AppliedGenomics/Project/pipeline.conf

cd $dataDIR

fastqR1="$(head -$PBS_ARRAYID $fastqFiles | tail -1 | awk '{print $1}')"
fastqR2="$(head -$PBS_ARRAYID $fastqFiles | tail -1 | awk '{print $2}')"
srr="$(head -$PBS_ARRAYID $sampleInfo | tail -1 | awk '{print $1}')"

fastqR1_base="${fastqR1%%.*}"
fastqR2_base="${fastqR2%%.*}"

starAlignDir=$srr\_alignment
mkdir $starAlignDir
cd $starAlignDir

echo "Sample Information"
echo "========================"
echo "Array ID:" $PBS_ARRAYID
echo "Home directory:" $homeDIR
echo "Data directory:" $dataDIR
echo "Current directory:" $PWD
echo "SRR sample:" $srr
echo "Fastq file, read 1:" $fastqR1
echo "Fastq file, read 2:" $fastqR2
echo "reference genome:" $reference
echo "========================"

#STAR aligner

module load star/intel/2.4

echo "STAR version:"
echo "$(STAR --version)"


STAR --genomeDir $referenceDIR --readFilesIn $dataDIR/$fastqR1 $dataDIR/$fastqR2 \
--runThreadN 12 \
--readFilesCommand zcat \
--outFileNamePrefix $srr

echo "STAR alignment error:" $__ERR__
echo "========================"
