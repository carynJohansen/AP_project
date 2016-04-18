#!/bin/bash
#PBS -l nodes=1:ppn=12
#PBS -l mem=48GB
#PBS -l walltime=5:00:00
#PBS -N dump_fastq
#PBS -M ckj239@nyu.edu
#PBS -j oe
#PBS -t 1-4

module purge

source /home/ckj239/AppliedGenomics/Project/pipeline.conf

cd $dataDIR

srr="$(head -$PBS_ARRAYID fd_runagain3.txt | tail -1 | awk '{print $1}')"
sra="$(ls $srr\.sra)"
fastqR1=$srr\_1.fastq.gz
fastqR2=$srr\_2.fastq.gz

echo "Sample Information"
echo "========================"
echo "Array ID:" $PBS_ARRAYID
echo "Home directory:" $homeDIR
echo "Data directory:" $dataDIR
echo "Current directory:" $PWD
echo "SRR sample:" $srr
echo "SRA file:" $sra
echo "fastq read 1:" $fastqR1
echo "fastq read 2:" $fastqR2
echo "Drought file: fd_runagain3.txt"
echo "reference genome:" $reference
echo "========================"

#If the file exists, remove it

if [ -s $fastqR1 ]; then rm $fastqR1; fi
if [ -s $fastqR2 ]; then rm $fastqR2; fi

module load sratoolkit/2.5.7

fastq-dump -I --split-files --gzip $sra

__ERR__=$?
echo "fastq-dump error:" $__ERR__
