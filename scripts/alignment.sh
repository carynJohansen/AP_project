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

#tophat
module load tophat/intel/2.0.11

echo "========================"
echo "tophat version:" "$(tophat --version)"

tophat2 -p 12 \
-o $srr\_alignment \
$reference \
$fastqR1_base.t.fastq, $fastqR2_base.t.fastq

__ERR__=$?
echo "tophat2 error:" $__ERR__
echo "========================"
