#!/bin/bash
#PBS -l nodes=1:ppn=12
#PBS -l mem=24GB
#PBS -l walltime=5:00:00
#PBS -N SRA_test
#PBS -M ckj239@nyu.edu
#PBS -j oe

module purge

sra=SRR2931495.sra
ftp=ftp://ftp-trace.ncbi.nlm.nih.gov/sra/sra-instant/reads/ByExp/sra/SRX/SRX142/SRX1424389/SRR2931495/SRR2931495.sra

cd $SCRATCH

mkdir SRA_test
cd SRA_test

#wget the sra file

wget $ftp

#validate and unpack
module load sratoolkit/2.5.7

vdb-validate -x $sra

fastq-dump -I --split-files --gzip $sra
