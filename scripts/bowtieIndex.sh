#!/bin/bash
#PBS -l nodes=1:ppn=12
#PBS -l mem=8GB
#PBS -l walltime=5:00:00
#PBS -N index_reference_genome
#PBS -M ckj239@nyu.edu
#PBS -j oe

module purge

homedir=/home/ckj239/AppliedGenomics/Project
datadir=/scratch/ckj239/AppliedGenomics/Project/data
referencedir=/scratch/ckj239/AppliedGenomics/Project/genome

referenceZip=/scratch/ckj239/AppliedGenomics/Project/genome/IRGSP-1.0_genome.fasta.gz
reference=/scratch/ckj239/AppliedGenomics/Project/genome/IRGSP-1.0_genome.fasta

cd $referencedir

module load bowtie2/2.2.7

echo "Sample Information"
echo "========================"
echo "Array ID:" $PBS_ARRAYID
echo "Home directory:" $homedir
echo "Data directory:" $datadir
echo "Reference directory:" $referencedir
echo "Current directory:" $PWD
echo "reference genome:" $reference
echo "========================"

echo "bowtie2 version:"
echo "$(bowtie2 --version)"
echo "========================"

#unzip reference
gunzip -c $referenceZip > $reference

bowtie2-build -f $reference IRGSP-1.0_genome
__ERR__=$?

echo "bowtie2-build exit error:" $__ERR__
