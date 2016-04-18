###############################
#           Env               #

import sys
from BCBio import GFF
import pandas as pd
import numpy as np
import json
import re
import ast

import config

#import vcf module
sys.path.append('/Users/caryn/Dropbox/Project_RiceGeneticVariation/database')
import vcf

#to time the program:
import time

###############################
#          Methods            #


def get_MSU_info ( gene ):
	chromNumber = parse_input(gene)
	infoFile = config.CHROM_INFO_PATH[chromNumber]
	info = open(infoFile, 'r')
	gene_info = []
	myregex = r".*\s" + re.escape(gene) + r"\s.*"
	for line in info:
		if re.match(myregex, line):
			gene_info.append(line)
	#error message for not found:
	if (len(gene_info) == 0):
		error = "Gene not found."
		return error

	#check for multiple isoform information
	#print len(gene_info)
	if (len(gene_info) > 1):
		maxlen = 0
		gene_info_keep = []
		#get the lengths of all the gene isoforms
		for line in gene_info:
			splitline = line.split('\t')
			length = int(splitline[4]) - int(splitline[3])
			if (length > maxlen):
				maxlen = length
				gene_info_keep = [line]
		gene_info_keep =  gene_info_keep[0].split('\t')
		return gene_info_keep
	
	#if there are no isoforms, return gene_info
	gene_info = gene_info[0].split('\t')
	return gene_info

def get_VCF_info( gene, msu_info ):
	chrom = msu_info[0]
	start = int(msu_info[3])
	end = int(msu_info[4])

	vcf_reader = get_vcf_reader()

	vcf_records = []
	for rec in vcf_reader.fetch(chrom, start, end):
		for sample in rec.samples:
			rw = {
				"gene" : gene,
				"chromosome" : rec.CHROM,
				"sample" : sample.sample,
				"position" : rec.POS,
				"start" : start,
				"end" : end,
				"reference" : rec.REF,
				"alternate" : str(rec.ALT[0]),
				"genotype" : sample['GT'],
				"SNPEFF_effect" : rec.INFO['SNPEFF_EFFECT'],
				"SNPEFF_FUNCTIONAL_CLASS" : rec.INFO['SNPEFF_FUNCTIONAL_CLASS']
			}

			vcf_records.append(rw)
	#print vcf_records
	return vcf_records

def parse_input( gene_str ):
	g_split = gene_str.split('g')[0]
	chrom_split = g_split.split('Os')[1]
	return chrom_split

def main( gene_list ):
	for gene in gene_list:
		msu = get_MSU_info(gene)
		print msu

###############################
#            Main             #

if __name__ == '__main__':
	#file, json = sys.argv
	gene_list = sys.argv[1]
	gene_list = gene_list.split(",")

	main(gene_list)


