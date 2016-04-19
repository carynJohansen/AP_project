#!/bin/bash
#PBS -l nodes=1:ppn=1
#PBS -l walltime=4:00:00
#PBS -l mem=8GB
#PBS -N HTseq-count
#PBS -M ckj239@nyu.edu
#PBS -j oe
#PBS -t 1-16

module purge

source /home/ckj239/AppliedGenomics/Project/pipeline.conf

cd $dataDIR

srr="$(head -$PBS_ARRAYID fd_runagain3.txt | tail -1 | awk '{print $1}')"
sra="$(ls $srr\.sra)"
fastqR1=$srr\_1.fastq.gz
fastqR2=$srr\_2.fastq.gz
alignedDIR=$srr\_alignment

alignFile=$srr\Aligned.out.sam
sortedFile=$srr\_s.bam
dupFile=$srr\_sm.bam

mkdir $srr\_dir
mv $sra $srr\_dir
mv $fastqR1 $srr\_dir
mv $fastqR2 $srr\_dir
mv $alignedDIR $srr\_dir
cd $srr\_dir

echo "Sample Information"
echo "========================"
echo "Array ID:" $PBS_ARRAYID
echo "Home directory:" $homeDIR
echo "Data directory:" $dataDIR
echo "Reference directory:" $referenceDIR
echo "Current directory:" $PWD
echo "SRR sample:" $srr
echo "Fastq file, read 1:" $fastqR1
echo "Fastq file, read 2:" $fastqR2
echo "reference genome:" $reference
echo "GFF file:" $gff
echo "========================"

module load htseq/intel/0.6.1
module load pysam/intel/0.8.2.1

echo "HTSeq Information"
echo "loaded htseq/intel/0.6.1"
echo "loaded pysam/intel/0.8.2.1"

htseq-count -f bam -i gene -t gene $alignedDIR/$dupFile $gff > $srr\_htseq_count.txt
__ERR__=$?

echo "htseq-count error:" $__ERR__ 
