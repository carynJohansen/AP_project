#!/bin/bash

##############################
#		   Alignment		 #

# Bowtie - make the index

bowtie-build2 #reference

#tophat2 Alignment

qsub #tophat.pbs

##############################
#		   Cleaning			 #

qsub #mark duplicates

qsub #trimmotatic

qsub #GATK realign and recaligrate bases

##############################
#	 Variant Calling		 #

#error catching here for cleaning outcomes
#if any of the previous process failed, it should
#stop here and be fixed.

qsub #GATK Variant caller 

qsub #GATK VariantFiltration

qsub #snpeff

##############################
#	  Differential Genes	 #

qsub #HTSeq