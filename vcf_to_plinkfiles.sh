#!/bin/sh
# Conversion of VCF format to PLINK format files

#$ -cwd
# error = Merged with joblog
#$ -o joblog.$JOB_ID
#$ -j y
## Edit the line below as needed:
#$ -l h_rt=1:00:00,h_data=1G
## Modify the parallel environment
## and the number of cores as needed:
#$ -pe shared 1
# Email address to notify
#$ -M $USER@mail
# Notify when
#$ -m bea

#Directories
date='12/07/2023'
outdir=/project/data/plinkfiles
files=/project/data/integrated_variants_raw
END=22

#Software
plink2=/project/apps/plink2

#Format conversion
for i in $(seq 1 $END);do
$plink2 \
    --vcf $files/ALL.chr${i}.phase3_shapeit2_mvncall_integrated_v5b.20130502.genotypes.vcf.gz \
    --max-alleles 2 \
    --make-bed --out $outdir/1000G_Phase3_integrated_genotypes_chr${i}; done

