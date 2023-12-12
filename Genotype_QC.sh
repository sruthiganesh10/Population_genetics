#!/bin/sh
# Standard QC of Genotype data

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
files=/project/data/plinkfiles
qc_outdir=/project/data/integrated_QC_plink
qc_metrics=/project/data/QC_Summary_stats
END=22

#Software
plink2=/u/project/apps/plink2

#Generate general summary statistics
for i in $(seq 1 $END);do
$plink2 \
    --bfile $files/1000G_Phase3_integrated_genotypes_chr${i} \
    --missing \
    --hardy --nonfounders \
    --het \
    --out $qc_metrics/1000GP_Phase3_QC_chr${i};done

#Perform filtering
for i in $(seq 1 $END);do
$plink2 \
    --bfile $files/1000G_Phase3_integrated_genotypes_chr${i} \
    --geno 0.05 --mind 0.1 --maf 0.01 \
    --genotyping-rate \
    --hwe 1e-6 --nonfounders \
    --make-bed --out $qc_outdir/1000GP_Phase3_QC_chr${i};done
