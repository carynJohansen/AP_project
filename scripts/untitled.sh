#!/bin/bash
#PBS -l nodes=1:ppn=1
#PBS -l mem=5GB
#PBS -l walltime=0:30:00
#PBS -N wget_sra
#PBS -M ckj239@nyu.edu
#PBS -j oe
#PBS -t 1-9

module purge

HOMDIR=/home/ckj239/AppliedGenomics/Project
DATADIR=/scratch/ckj239/AppliedGenomics/Project/data
infofile=sra_files.txt

cd $DATADIR

SRR="$(head -$PBS_ARRAYID $infofile | tail -1)"

module load sratoolkit/2.5.7

fastq-dump $SRR
