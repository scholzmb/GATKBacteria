LOCAL INSTALL PROCEDURE:

MAKE SURE YOU HAVE SET GIT TO ONLY UPDATE CURRENT BRANCH
git config global push.default=current


in project directory:
git init
git remote add origin master git@github.com:scholzmb/GATKBacteria.git
git pull
git branch <project name>
git checkout <project name>

proceed.  

else (others) clone, or branch, and make pull requests.

This repository contains all code needed to generate a SNP analysis from bacterial samples.  It is designed to work with multiple samples at a time.  


Scripts must be edited to use:

1) GATK formatted reference (REF=)
2) Genbank formatted annotation (GBK=)
3) VCF file of known snps (Blank.vcf is provided if no dbsnp is available) (KNOWN=)


tools are hard-coded with paths to use GATK, TRAMS, and PICARDtools
vcf2trams.pl is a custom perl script used to split multi-g.vcf files (with >1 sample) from GATK into trams compatible files.  it can be found in contrib/


Samples must be trimmed and aligned to reference prior to running GATK.  standard protocol is 

trimmomatic + FastQC

bwa mem




