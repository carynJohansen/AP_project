#!/bin/bash
#PBS -l nodes=1:ppn=12
#PBS -l mem=8GB
#PBS -l walltime=5:00:00
#PBS -N index_reference_genome
#PBS -M ckj239@nyu.edu
#PBS -j oe

module purge

source /home/ckj239/AppliedGenomics/Project/pipeline.conf

module load star/intel/2.4

echo "Sample Information"
echo "========================"
echo "Array ID:" $PBS_ARRAYID
echo "Home directory:" $homedir
echo "Data directory:" $datadir
echo "Reference directory:" $referenceDIR
echo "Current directory:" $PWD
echo "reference genome:" $reference
echo "========================"

echo "STAR version:"
echo "$(STAR --version)"

STAR --runMode genomeGenerate --genomeDir $referenceDIR --genomeFastaFiles $reference --runThreadN 12
__ERR__=$?

echo "STAR genomeGenerate error:" $__ERR__
echo "========================"
