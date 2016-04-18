#!/bin/bash
#PBS -l nodes=1:ppn=12
#PBS -l mem=8GB
#PBS -l walltime=1:00:00
#PBS -N fastqc
#PBS -M ckj239@nyu.edu
#PBS -j oe
#PBS -t 1-9

module purge

homedir=/home/ckj239/AppliedGenomics/Project
datadir=/scratch/ckj239/AppliedGenomics/Project/data
fastqFiles=/scratch/ckj239/AppliedGenomics/Project/data/fastq_files.txt
sampleinfo=/scratch/ckj239/AppliedGenomics/Project/data/sample_info.txt

cd $datadir

fastqR1="$(head -$PBS_ARRAYID $fastqFiles | tail -1 | awk '{print $1}')"
fastqR2="$(head -$PBS_ARRAYID $fastqFiles | tail -1 | awk '{print $2}')"
srr="$(head -$PBS_ARRAYID $sampleinfo | tail -1 | awk '{print $1}')"

echo "Sample Information"
echo "========================"
echo "Array ID:" $PBS_ARRAYID
echo "Home directory:" $homedir
echo "Data directory:" $datadir
echo "Current directory:" $PWD
echo "SRR sample:" $srr
echo "Fastq file, read 1:" $fastqR1
echo "Fastq file, read 2:" $fastqR2
echo "========================"

module load fastqc/0.11.2

fastqc -t 12 $fastqR1
__ERR__=$?

echo "Error for fastqc for read 1 fastq:" $__ERR__

fastqc -t 12 $fastqR2
__ERR__=$?

echo "Error for fastqc for read 2 fastq:" $__ERR__
