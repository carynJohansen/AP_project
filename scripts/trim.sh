#!/bin/bash
#PBS -l nodes=1:ppn=12
#PBS -l mem=24GB
#PBS -l walltime=5:00:00
#PBS -N alignment
#PBS -M ckj239@nyu.edu
#PBS -j oe
#PBS -t 1-9

module purge

source /home/ckj239/AppliedGenomics/Project/pipeline.conf

cd $datadir

fastqR1="$(head -$PBS_ARRAYID $fastqFiles | tail -1 | awk '{print $1}')"
fastqR2="$(head -$PBS_ARRAYID $fastqFiles | tail -1 | awk '{print $2}')"
srr="$(head -$PBS_ARRAYID $sampleInfo | tail -1 | awk '{print $1}')"

fastqR1_base="${fastqR1%%.*}"
fastqR2_base="${fastqR2%%.*}"

echo "Sample Information"
echo "========================"
echo "Array ID:" $PBS_ARRAYID
echo "Home directory:" $homedir
echo "Data directory:" $datadir
echo "Current directory:" $PWD
echo "SRR sample:" $srr
echo "Fastq file, read 1:" $fastqR1
echo "Fastq file, read 2:" $fastqR2
echo "reference genome:" $reference
echo "========================"

#trim reads on each fastq file
module load trimmomatic/0.32

echo "Trimmomatic"

java -jar /share/apps/trimmomatic/0.32/trimmomatic-0.32.jar \
PE -threads 12 -phred33 \
$datadir/$fastqR1 \
$datadir/$fastqR2 \
$datadir/$fastqR1_base.t.fastq \
$datadir/$fastqR1_base.ut.fastq \
$datadir/$fastqR2_base.t.fastq \
$datadir/$fastqR2_base.ut.fastq \
LEADING:10 SLIDINGWINDOW:4:15 MINLEN:40

__ERR__=$?

echo "trimmomatic error:" $__ERR__

echo "========================"
