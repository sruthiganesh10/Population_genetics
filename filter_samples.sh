#!/bin/sh
# Filtering Samples of Non-European ancestry 

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
files=/project/data/integrated_QC_plink
outdir=/project/data/1000GP_Phase3/1000G_Phase3_Non_Eur
END=22

#Software
plink2=/project/apps/plink2

# Separate out Non-European samples
for i in $(seq 1 $END);do
$plink2 \
    --bfile $files/1000GP_Phase3_QC_chr${i} \
    --remove /u/project/lhernand/sganesh/data/non_eur/exclude_eur_ids.txt \
    --make-bed --out $outdir/1000G_Phase3_QC_Non_Eur_chr${i};done
