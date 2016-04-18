#!/bin/bash
#PBS -l nodes=1:ppn=12
#PBS -l mem=8GB
#PBS -l walltime=1:00:00
#PBS -N sra_wget
#PBS -M ckj239@nyu.edu
#PBS -j oe
#PBS -t 1-9

module purge

HOMDIR=/home/ckj239/AppliedGenomics/Project
DATADIR=/scratch/ckj239/AppliedGenomics/Project/data

cd $DATADIR

ftp_start=ftp://ftp-trace.ncbi.nlm.nih.gov/sra/sra-instant/reads/ByExp/sra/SRX/

sample_ftp="$(head -$PBS_ARRAYID sample_info.txt | tail -1 | awk '{print $2}')"
SRR="$(head -$PBS_ARRAYID sample_info.txt | tail -1 | awk '{print $1}')"

echo "SAMPLE INFORMATION"
echo "Array Id number:" ${PBS_ARRAYID}
echo "ftp address:" $ftp_start$sample_ftp
echo "SRR:" $SRR
echo "Directory:" $DATADIR

wget $ftp_start$sample_ftp
__ERR__=$?
echo "wget error:" $__ERR__

#validate the sra file
module load sratoolkit/2.5.7

vdb-validate -x $SRR.sra
__ERR__=$?

echo "vdb-validate error:" $__ERR__
