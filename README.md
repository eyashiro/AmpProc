# README

Last modified: 29 September 2023

Author: Erika Yashiro, Ph.D.

Script name: AmpProc

Version: 5.2.0


########################################

### Contents
   - What is AmpProc
   - How to cite the tools used in the workflow
   - Information on reference databases used for taxonomic classification
   - How to install AmpProc
   - How to run AmpProc
   - General output file formats
   - Version history


########################################

# What is AmpProc

AmpProc is a custom and automated workflow that processes raw amplicon reads. It cleans the data, builds ZOTU (aka ASV) and OTU frequency tables, aligns the reads, builds a phylogenetic tree that can be used to calculate UniFrac beta dissimilarity databases, and generate diagnostic alpha and beta diversity analysis results. It acts as both a wrapper for other published software as well as a script that processes and reformats data for downstream applications. The bulk of the amplicon data processing is handled by USEARCH, while the settings used for phylogenetic tree building are based on QIIME1+2 parameters; therefore, users of AmpProc can feel reassured that the data is flowing through a well-recognized set of software. If you use AmpProc, you will also need to acknowledge the use of the other dependent software in the pipeline. If you are a bit lazy, then you can mention in your Methods section that the relevant references are listed here on this page.

AmpProc is currently geared toward amplicon data that are sequenced on the Illumina sequencing platforms. However, with a little tweaking of the raw fastq files, I admit that I have also successfully used it on 454 / Ion Torrent data.

AmpProc handles mostly ribosomal operon amplicons as well as certain other genomic regions. I'm also gradually adapting AmpProc to run the full pipeline with custom reference databases.

The Standard workflow in AmpProc is geared toward the common amplicon sequencing data.

The MiDAS workflow in AmpProc is for the prokaryotic V1-V3 ~250bp R1 region from wastewater sludge and AD. If you have other types of amplicons from wastewater ecosystems, please use the Standard workflow (not the Midas workflow) when asked by AmpProc and select the MiDAS reference database. You can see an example of how the MiDAS workflow was used in Peces et al., 2022 (https://doi.org/10.1038/s43705-022-00098-4)


Author: Erika Yashiro, Ph.D.\
https://github.com/eyashiro/AmpProc



# How to cite the tools used in the workflow:

## USEARCH 11

USEARCH and UCLUST algorithms  
Edgar, R.C. (2010) Search and clustering orders of magnitude faster than BLAST, Bioinformatics 26(19), 2460-2461. \
doi: https://doi.org/10.1093/bioinformatics/btq461

SINTAX algorithm = Taxonomy assignment \
Edgar, R.C. (2016), SINTAX, a simple non-Bayesian taxonomy classifier for 16S and ITS sequences. \
doi: http://dx.doi.org/10.1101/074161

UNOISE algorithm = Those who use the unoise3 ZOTU clustering  
Edgar, R.C. (2016), UNOISE2: Improved error-correction for Illumina 16S and ITS amplicon reads. \
doi: http://dx.doi.org/10.1101/081257

Expected error filtering and paired read merging = Paired-end read merging  
Edgar, R.C. and Flyvbjerg, H (2014) Error filtering, pair assembly and error correction for next-generation sequencing reads. \
doi: https://doi.org/10.1093/bioinformatics/btv401

UPARSE algorithm = OTU clustering \
Edgar, R.C. (2013) UPARSE: Highly accurate OTU sequences from microbial amplicon reads, Nature Methods \
doi: https://doi.org/10.1038/nmeth.2604

## QIIME 1.9.1  - DEPRECATED

QIIME was used for running PYNAST sequence alignment tool used prior to tree-building for prokaryote amplicons, and beta diversity analysis. Now these roles are taken over by other software listed on this page.

QIIME allows analysis of high-throughput community sequencing data
J Gregory Caporaso, Justin Kuczynski, Jesse Stombaugh, Kyle Bittinger, Frederic D Bushman, Elizabeth K Costello, Noah Fierer, Antonio Gonzalez Pena, Julia K Goodrich, Jeffrey I Gordon, Gavin A Huttley, Scott T Kelley, Dan Knights, Jeremy E Koenig, Ruth E Ley, Catherine A Lozupone, Daniel McDonald, Brian D Muegge, Meg Pirrung, Jens Reeder, Joel R Sevinsky, Peter J Turnbaugh, William A Walters, Jeremy Widmann, Tanya Yatsunenko, Jesse Zaneveld and Rob Knight; Nature Methods, 2010; doi:10.1038/nmeth.f.303

## MAFFT

MAFFT now replaces QIIME1's PYNAST. It uses the same parameters as in QIIME2.

Katoh, Misawa, Kuma, Miyata 2002 (Nucleic Acids Res. 30:3059-3066)
MAFFT: a novel method for rapid multiple sequence alignment based on fast Fourier transform.

## FastTree

Fasttree 2.1 is a tree algorithm used for Unifrac Beta diversity matrices. It uses the same parameters as in QIIME1.

Price, M.N., Dehal, P.S., and Arkin, A.P. (2009) FastTree: Computing Large Minimum-Evolution Trees with Profiles instead of a Distance Matrix. Molecular Biology and Evolution 26:1641-1650, doi:10.1093/molbev/msp077.



########################################


# Information on reference databases used for taxonomic classification

The reference databases available in AmpProc are updated as needed at each AmpProc version change.

Many of the databases have been slightly reformatted in order to be compatible with USEARCH's sintax function. Notably for databases modified by me, you may notice that parentheses were replaced by double underscores, and commas by single underscore. This is because characters like parentheses, brackets, etc., are regarded as having special meaning in the programming world. Ambiguous taxon names were also removed (e.g. Ambiguous taxa, unknown, unidentified, uncultured, metagenome). All these changes were made so that the database files run seamlessly with USEARCH's sintax taxonomy assignment function. If the creators of the databases had already formatted a SINTAX-compatible file, then those were used without further modifications.

Below are listed the reference databases that are recognized by AmpProc and their change status. More information on how to set up and use the databases is described in the "How to install AmpProc" section.

### Greengenes gg_13_8_otus

Changes made for AmpProc: None. This dbs is used as is.

The Greengenes database is used to filter out 16S rRNA gene sequences that are < 60% similar to known sequences. \
https://greengenes.secondgenome.com/

I found the following link on one of the QIIME forums to download the database. \
ftp://ftp.microbio.me/greengenes_release/gg_13_5/gg_13_8_otus.tar.gz

### SILVA LPT v.132, 16S rRNA gene

Changes made for AmpProc: None. This dbs is used as is. \
You can find it on the USEARCH website. \
https://www.drive5.com/usearch/manual/sintax_downloads.html

Yilmaz P, Parfrey LW, Yarza P, Gerken J, Pruesse E, Quast C, Schweer T, Peplies J, Ludwig W, Glöckner FO (2014) The SILVA and "All-species Living Tree Project (LTP)" taxonomic frameworks. Nucl. Acids Res. 42:D643-D648. \
doi: https://doi.org/10.1093/nar/gkt1209

### SILVA SSURef trunc 99% v.132, 16S rRNA gene

Changes made for AmpProc: Yes. \
Please contact me if you need a copy. The sintax-converted version is distributed under the [CC-BY 4.0 licence](https://creativecommons.org/licenses/by/4.0/).

The originals are found at the SILVA website. \
https://www.arb-silva.de/

Quast C, Pruesse E, Yilmaz P, Gerken J, Schweer T, Yarza P, Peplies J, Glöckner FO (2013) The SILVA ribosomal RNA gene database project: improved data processing and web-based tools. Nucl. Acids Res. 41 (D1): D590-D596. \
doi: https://doi.org/10.1093/nar/gkt1209

### SILVA SSURef trunc 99% v.138.1, 16S and 18S rRNA gene

Changes made for AmpProc: Yes. \
Please contact me if you need a copy. The sintax-converted version is distributed under the [CC-BY 4.0 licence](https://creativecommons.org/licenses/by/4.0/).

The originals are found at the SILVA website. \
https://www.arb-silva.de/

Quast C, Pruesse E, Yilmaz P, Gerken J, Schweer T, Yarza P, Peplies J, Glöckner FO (2013) The SILVA ribosomal RNA gene database project: improved data processing and web-based tools. Nucl. Acids Res. 41 (D1): D590-D596. \
doi: https://doi.org/10.1093/nar/gks1219

### MiDAS v.2.1.3

Changes made for AmpProc: Yes, it's available on the MiDAS website. \

https://www.midasfieldguide.org/

Simon Jon McIlroy, Rasmus Hansen Kirkegaard, Bianca McIlroy, Marta Nierychlo, Jannie Munk Kristensen, Søren Michael Karst, Mads Albertsen, Per Halkjær Nielsen, 2017. MiDAS 2.0: an ecosystem-specific taxonomy and online database for the organisms of wastewater treatment systems expanded for anaerobic digester groups. \
doi:  https://doi.org/10.1093/database/bax016

### MiDAS v.3.7

Changes made for AmpProc: None. This dbs is used as is. \

https://www.midasfieldguide.org/

Nierychlo, M., Andersen, K.S., Xu, Y., Green, N., Jiang, C., Albertsen, M., Dueholm, M.S., Nielsen, P.H., 2020. MiDAS 3: An ecosystem-specific reference database, taxonomy and knowledge platform for activated sludge and anaerobic digesters reveals species-level microbiome composition of activated sludge. Water Research 115955. \
doi: https://doi.org/10.1016/j.watres.2020.115955

### MiDAS v.5.1

Changes made for AmpProc: None. This dbs is used as is. \

https://www.midasfieldguide.org/

Dueholm, M.K.D., Andersen, K.S., Petersen, A.C., Rudkjøbing, V., MiDAS Global Consortium for Anaerobic Digesters, Nielsen, P.H. MiDAS 5: Global diversity of bacteria and archaea in anaerobic digesters. \
doi: https://doi.org/10.1101/2023.08.24.554448

### RDP training set v.16

Changes made for AmpProc: None.

You can find it the on the USEARCH website. \
https://www.drive5.com/usearch/manual/sintax_downloads.html

### UNITE fungal and eukaryotic ITS 1 & 2 v.9.0 (25.07.2023)

Changes made for AmpProc: Yes. The taxonomy domain was changed to kingdom. \
Please contact me if you need a copy of the database files. The sintax-converted modified versions are distributed under the [CC-BY-SA 4.0 licence](https://creativecommons.org/licenses/by-sa/4.0/).

The originals can be found at: \
https://unite.ut.ee/

Abarenkov, Kessy; Zirk, Allan; Piirmann, Timo; Pöhönen, Raivo; Ivanov, Filipp; Nilsson, R. Henrik; Kõljalg, Urmas (2023): UNITE USEARCH/UTAX release for Fungi. Version 18.07.2023. UNITE Community. \
https://doi.org/10.15156/BIO/2938083

Abarenkov, Kessy; Zirk, Allan; Piirmann, Timo; Pöhönen, Raivo; Ivanov, Filipp; Nilsson, R. Henrik; Kõljalg, Urmas (2023): UNITE USEARCH/UTAX release for eukaryotes. Version 18.07.2023. UNITE Community. \
https://doi.org/10.15156/BIO/2938084

### 12S Mitofish dbs

(The version used in AmpProc was originally extracted from Mitohelper.)

Changes made for AmpProc: Yes. \
Please contact me if you need a copy. The sintax-converted version is distributed under the [CC-BY 4.0 licence](https://creativecommons.org/licenses/by/4.0/).

http://mitofish.aori.u-tokyo.ac.jp/ \
https://github.com/aomlomics/mitohelper

Iwasaki W, Fukunaga T, Isagozawa R, Yamada K, Maeda Y, Satoh TP, Sado T, Mabuchi K, Takeshima H, Miya M, et al. 2013. MitoFish and MitoAnnotator: a mitochondrial genome database of fish with an accurate and automatic \ annotation pipeline. Mol Biol Evol 30:2531-2540.
doi: https://doi.org/10.1093%2Fmolbev%2Fmst141

### 12S MIDORI Unique and Longest metazoan databases vGB241 (2020-12)

Changes made for AmpProc: No.

You can find the SINTAX-formatted files on the MIDORI Reference 2 website. \
https://www.reference-midori.info/download.php#

Machida, R., Leray, M., Ho, SL. et al. Metazoan mitochondrial gene sequence reference datasets for taxonomic assignment of environmental samples. Sci Data 4, 170027 (2017). \
doi: https://doi.org/10.1038/sdata.2017.27

########################################

# How to install AmpProc

## Prerequisites

AmpProc has only been tested on Ubuntu Linux, so if you have other Linux distributions or MacOS, I won't be able to help you if you have problems.

You will need to install the following dependencies to make AmpProc work:
* GNU Bash terminal (This is the normal Bash in e.g. Ubuntu)
* USEARCH v.11.0.667_i86linux64 or linux32
* MAFFT (v.7.520 has been tested)
* FastTree (v.2.1.11 has been tested)
* Python 3 (v3.10.12 has been tested)
* Scikit Bio (v0.5.9 has been tested)
* newick v.1.0.1429 https://github.com/rcedgar/newick
* You need to download the correct reference database(s). You can find the specifics of the file names to download in the ampproc_congfig.sh file.
* Make sure that the executable file of the dependent software are executable (i.e. When you type "ls -la" in the terminal, you should see an "x" marked in the permissions list next to the executable file name.)

Please note that if you decide to run AmpProc on your own machines, you will need to get yourself a licensed copy of USEARCH. The 32-bit version is free but for larger datasets, you will need to purchase the [64-bit version](https://www.drive5.com/usearch/).

If you feel uncomfortable running AmpProc on your own and/or analyzing amplicon data, please contact me, and I'd be happy to process and analyze your data for you. (I charge a fee for the time I spend working on your project.) You can find my contact information further down on this page.

## Setting up the paths

1. Download and extract/unzip the reference database(s). You only need to download the databases that are required for the particular workflow you want to run. Pay close attention to the file name(s) that you need; you can find this information in the ampproc_config.sh file. Spaces in the downloaded files need to be converted to underscores.
    - Bacteria & Archaea 16S: Greengenes (required) and either a SILVA or MiDAS database.
    - Fungi ITS: UNITE Fungi
    - Microeukaryotes ITS: UNITE euk
    - 12S: Mitofish or MIDORI
    - Eukaryotes 18S: SILVA

2. You need to specify the path to the dependent packages/scripts in the ampproc_config.sh file so that AmpProc can find them. You can either specify the entire path to the executables or write just the name of the executable if either you already configured $PATH or the executables are in a bin/ folder that is specified in the $PATH.

3. You also need to specify in the ampproc_config.sh the path to the directory where your raw Illumina (or other compatible) fastq reads are located. The raw Illumina sequencing files must be in *.fastq.gz format, and there should only be one file per sample for single-read projects or an R1 file and an R2 file for paired-end projects. The file format should be like this: SampleID_\*R1\*.fastq.gz

## Configuring the AmpProc executable file

The AmpProc script needs to know where it is and where the different files and dependencies are found. Therefore running the install.sh will configure AmpProc and check for the presence of the required files that were specified in the ampproc_config.sh.

1. Go to the AmpProc directory using the 'cd' command in the Bash terminal.

```
For example:
$ cd $HOME/software/AmpProc
```

2. Run the install script:
```
~/software/AmpProc$ ./install.sh
```

3. Read the output text and make sure that the install.sh script found all of the required files.

If the install script failed, then you might have misspelled a path or command name. Fix the paths. You can rerun the script again.

```
~/software/AmpProc$ ./install.sh

Adding the current path to the ampproc script   ... done.
Created executable script: ampproc
Scripts' path is /home/Dopey/Software/AmpProc

Adding the current path to the ASVpipeline.sh script   ... done.
Can I find any fastq.gz files in the SEQPATH?   ... yes
usearch executable found.
mafft executable's path may not be correct. Cannot find mafft.
FastTreeMP executable's path may not be correct. Cannot find FastTreeMP.
newick found.
Python 3 found.
Scikit-bio found.
GG97REF found.
REFDATAPATHsilvaLTP132 found.
REFDATAPATHsilva99pc132 not found or the path may be not correct.
REFDATAPATHsilva99pc1381 found.
REFDATAPATHmidas2 found.
REFDATAPATHmidas3 not found or the path may not be correct. Make sure to replace the spaces in the file name with underscores.
REFDATAPATHmidas4 (latest version of MiDAS) not found or the path may not be correct. Make sure to replace the spaces in the file name with underscores
REFDATAPATHrdp not found or the path may not be correct.
REFDATAPATHuniteFUN found.
REFDATAPATHuniteEUK found.
REFDATAPATH12sMitohelper found.
REFDATAPATH12sMIDORIuniq found.
REFDATAPATH12SMIDORIlong found.
The install script has finished.
If the dependent executables were not found, you will need to fix the paths in the ampproc_config.sh, export the correct paths in the PATHS, and/or install the packages. You can rerun this installation script again.
```

########################################

# How to run AmpProc

### To run the help function with usage instructions, type either:

```
$ ampproc -h

OR

$ ampproc -help
```

### To run AmpProc's full pipeline:

1. Make sure that you create an empty directory, where you have just the file called: samples. This samples should contain your sample ID names, with one ID per line.

For example, if you have the following file names: \
Benji_S30_L001_R1_001.fastq.gz \
Benji_S30_L001_R2_001.fastq.gz \
Lassie_S31_L001_R1_001.fastq.gz \
Lassie_S31_L001_R2_001.fastq.gz

Then your samples file should look like this:
```
Benji
Lassie
```

2. To run AmpProc, go into the directory with the samples file in it, then type in the terminal:

```
# You should only have the samples file in the directory
~/Documents/analysis/processing$ ls
samples

# Check that AmpProc is in your path
~/Documents/analysis/processing$ echo $PATH
/home/Dopey/software/AmpProc:/usr/sbin:/bin etc...

# Now run AmpProc
~/Documents/analysis/processing$ ampproc
```

3. Be prepared to answer the questions asked by AmpProc. AmpProc is not an AI chatbot, so don't spill your heart into it or it will probably crash. Answers are also case-sensitive!

    - Whether you want OTU and/or ZOTU tables
    - Whether you want single-end and/or paired-end read processing
    - Which genomic region you have (essentially for determining length cutoffs)
    - Which reference database to use for taxonomy prediction (or none at all)
    - Whether to remove primer regions
    - MiDAS samples also have a separate workflow
    - Amplicon regions not on the list must use the VAR option
    - How many computer cores you wish you use

### To run AmpProc's taxonomy prediction a postiori using a different reference database, run the script with the following arguments:

1. The a postiori run with a default of 5 threads. Make sure that your computer can handle 5 threads. If not, you need to change the NUMTHREADS=5 to a lower number inside the ampproc script.

```
    -i  Input file. Must be otus.fa or zotus.fa (or single read variants).
    -t  Input file. Must be otu/zotu/asv table without taxonomy (e.g. otutable_notax.txt).
    -r  Reference database number for taxonomy prediction
          0  - no taxonomy assignment
          1  - SILVA LTP v132 16S
          2  - SILVA qiime99% v132 16S
          3  - SILVA SSURef trunc 99% v138.1 16S and 18S
          4  - MiDAS v2.1.3
          5  - MiDAS v3.7
          6  - MiDAS v5.1
          7  - RDP training set v16
          8  - UNITE fungi ITS 1&2 v9.0 (2023-07-25)
          9  - UNITE eukaryotes ITS 1&2 v9.0 (2023-07-25)
         10  - 12S Mitofish (Mitohelper 2021-03)
         11  - 12S MIDORI Unique metazoan vGB257 (2023-09)
         12  - 12S MIDORI Longest metazoan vGB257 (2023-09)
         14  - Custom sintax-formatted reference database. AmpProc will ask you the path.
```

For example:

```
$ ampproc -i zotus.fa -t zotutable_notax.txt -r 3
```


### To only incorporate the new SINTAX taxonomy output into an OTU/ZOTU/ASV table,
run the script:  otutab_sintax_to_ampvis.v1.2.sh (Run with -h for more information)

### Other Notes

FastTreeMP typically uses about 20 cores at its maximum run and this cannot be adjusted by the script.

The majority of the pipeline is a wrapper for USEARCH so you can refer to the memory requirements on the USEARCH website.

########################################

# GENERAL OUTPUT FILE FORMATS:


All OTU related files are indicated &ast;otu&ast;.  
All ZOTU related files are indicated &ast;zotu&ast; and &ast;asv&ast;.  
Single read equivalents are indicated &ast;R1&ast; and &ast;R2&ast;.  
Below are indicated the output files using OTU as an example. Everything written also applies for zotus.

Output file of OTU clustering:
 
    otus.fa


OTU table formats 

    OTU table: otutable_notax.txt  
    OTU table with taxonomy information: otutable.txt  
    OTU table normalized to 1000 reads per sample: otutable_notax.norm1000.txt

&ast; The otus.fa and otutable_notax.txt are required for running the a postiori taxonomy assignment function. (Same for their asv/zotu equivalents)


Generating otus taxonomy summary

    Output directory: taxonomy_summary/

    Phlyum summary: otus.phylum_summary.txt
    Class summary: otus.sintax.class_summary.txt
    Order summary: otus.sintax.order_summary.txt
    Family summary: otus.sintax.family_summary.txt
    Genus summary: otus.sintax.genus_summary.txt


Sequence alignment and phylogenetic tree of OTUs

    Output directory: aligned_seqs_OTUS/

    Aligned reads: *_aligned.fasta
    OTU tree: *.tre


Generating beta diversity matrices

    Output files in beta_div_OTUS/

    Weighted UniFrac matrix: *.weighted_unifrac.txt
    Unweighted UniFrac matrix: *.unweighted_unifrac.txt
    Bray Curtis matrix: *.bray_curtis.txt
    Jaccard (abundance-based): *.jaccard.txt
    Jaccard (presence-absence): *.jaccard_binary.txt

########################################

If you wish to contact me, you can reach me at e-y-a-s-h-i-r-o-2-at-g.m.a.i.l.dot,c.o.m without all the hyphens and punctuations. I'd be grateful if you refrain from sending me spam and marketing materials to this address.

########################################

# VERSION HISTORY

AmpProc v5.2.0 \
Released for user evaluation: XXX
- updated the following reference databases to the latest version
   - UNITE eukaryotes version 9.0
   - UNITE fungi version 9.0
   - MiDAS version 5.1 is the successor to the MiDAS global v4.8.1
   - MIDORI version GB257
- QIIME1 has been removed from the workflow because it is no longer supported by the developers. MAFFT is now the sequence aligner, using the same options as in QIIME2 (https://forum.qiime2.org/t/why-pynast-is-no-longer-available-in-qiime2/9464). The beta diversity calculations are now done with USEARCH.
- Added the newick command to check if phylogenetic tree is unrooted. If unrooted, then AmpProc will use scikit-bio's function to add a midpoint to the tree. This is the same procedure as what is done in QIIME2. The reason for root checking is because USEARCH beta diversity function will crash if an unrooted tree is used as input.
- The VAR option, for amplicons with lengths other than the ones on the list, is now available for single and paired-end reads. Taxonomy can also be assigned to reads with the VAR workflow.
- AmpProc now requires a config file (ampproc_config.sh) that needs to be manually updated by the user. In this file, the user must specify the paths to the reference database, to the raw sequence data, and command names of usearch and the other dependent software.
- An install.sh script now configures the paths in AmpProc and ASVpipeline and checks that the paths in ampproc_config.sh are correct. The executable file that users must use is now called ampproc.
- Paths in ASVpipeline have been updated to use the ampproc_config.sh file.
- The settings have been adjusted so that only the reads using the UNITE ITS databases use the aggregate tree to build UniFrac matrices. All other taxonomy mapping options (except 0) will build a phylogenetic tree if tree building is set to true.
- Other internal formatting done.

AmpProc5 v5.1.0.beta2.13  
Released for user evaluation: 22 November 2021
- Updated the following reference databases to the latest versions
   - UNITE eukaryotes version 8.3
   - UNITE fungi version 8.3
   - SILVA version 138.1 SSURef NR99 for 16S and 18S rRNA gene
   - MiDAS version 4.8.1 now contains both MiDAS3 (DK) and MiDAS4 (global) sequences. The MiDAS 3.4 is left in this version of AmpProc but will be removed in a future version.
   - MiDAS asvpipeline step of the workflow now uses ASVs_250bp_v3.0_20211110 instead of v2.0 for reference-based ASV taxonomic assignments.
- The MiDAS workflow has been speeded up at the otutab step by multithreading. Next version of AmpProc will embed this feature in the standard pipeline.
- A postiori taxonomy assignment can now accept custom sintax-formatted reference databases. The user needs to ensure that the reference database file does not contain Microsoft windows characters. The current implementation cannot accept the path to the reference database in the command string, so a separate Q&A will pop up to ask for the path. Both full and relative paths are accepted. Sintax-formatted fasta files were tested but udb files will probably also work but hasn't been tested.

AmpProc5 v5.1.0.beta2.12.1  
Released for user evaluation: 8 April 2021
- Fixed bug, where the workflow crashes after the Q&A section of standard workflow.

AmpProc5 v5.1.0.beta2.12.0  
Released for user evaluation: 6 April 2021
- Added the 12S mitochondrial gene reference databases:  
   - Mitofish based on the curated version in Mitohelper (March 2021), reformatted to sintax format.  
   - MIDORI UNIQ and LONG databases, based on the Genback v241, pre-formatted for sintax.  

AmpProc5 v5.1.0.beta2.11.1  
Released for user evaluation:  3 July 2020
- Bug fixes
- Polished the help section and Readme description.

AmpProc5 v5.1.0.beta2.11.0  
Released for user testing:  2 July 2020
- Added functionality for handling custom amplicons that are not in the current list of amplicons. The new amplicon setting "VAR" allows the users manually set the minimum length cutoff for the amplicon reads. Only paired-end sequenced reads are allowed with this setting. The amplicons using VAR will skip the prefiltering step (because there is not associated reference database), and use the same steps as for the ITS reads to build the maximum linkage cluster tree rather than the phylogenetic tree. The tree-building setting can be changed in a future version if users prefer the phylogenetic tree instead.

AmpProc5 v5.1.0.beta2.10.0  
Released for user evaluation:  12 June 2020
- Updated the MiDAS reference databases to versions 3.7 and 4.8.
- Fixed the typo error of the phylum taxonomy summary file

AmpProc5 v5.1.0.beta2.9.1  
Released for user evaluation:  5 May 2020
- Fixed bug so now V35 amplicons can have their phylo trees generated.

AmpProc5 v5.1.0.beta2.9  
Released for user evaluation:  22 April 2020
- Updated the Readme file in addition to the version history section.
- Added functionality for using the qiime-formatted Silva v138 NR99 database. As with the v132, some minor formatting changes were done; refer to README section on reference databases. Note that the Silva v138 was a major overhaul work by the Silva group so the classified output could look a bit different if you compare with v132. Some changes I've noticed include: spelling change Enterobacteriales became Enterobacterales; Bacteroidetes became Bacteroidota; phylum Deltaproteobacteria became other phylum names like Bdellovibrionota and Desulfobacterota.
- AmpProc can now classify 18S rRNA gene amplicons using the newest Silva v138 database.
- Sample names in the samples input file that either do not exist in the sequences folder or have zero reads will cause AmpProc to abort so that the user can go and check their samples file. 
- Samples that contain zero reads after filtering out PhiX contamination will be automatically be removed from further processing. You can find the list of excluded samples in the empty-samples.txt file.
- The Q&A section will automatically identify the server you are logged into and make a recommendation on the maximum number of threads to assign to AmpProc. You should always stay at or under that maximum recommendation, depending on what other jobs are running on that server computer.
- The MiDAS workflow in AmpProc now automatically outputs key steps into the logs file.

AmpProc5 v5.1.0.beta2.8  
Released for user evaluation:  6 February 2020
- Added functionality for using the qiime-formatted Silva v132 full database that had been depleted to 99% sequence identity.
- Added functionality for the same above database but for Silva v138, but the database is not yet ready to use. (feature coming soon)

AmpProc5 v5.1.0.beta2.7  
Released for user evaluation:  9 December 2019
- module releases of Qiime1, Biom, and Fasttree are now used.
- All reference databases have been reconnected to AmpProc.

AmpProc5 v5.1.0.beta2.6  
- After server crash, only ASV midas workflow is currently fully functional. The other reference databases need to be hooked up.

AmpProc5 v5.1.0.beta2.5  
Released for user evaluation: 15 November 2019
- Conversion of windows formated samples file to unix format is now more robust.
- Can generate only zotu/otu tables without taxonomy as an option.
- Allows trimming of primer regions based on number of bases to remove.
- Allows R1 and R2 only workflows in standard mode.
- NOTE: Even if you choose only R1 or R2, if you want to remove a primer region, you will still be asked the primer length to remove for both sides. Just put 0 (zero) for the reads side that you are not processing. I will fix that in the next version.

AmpProc5 v5.1.0.beta2.4  
Released for user evaluation: 7 November 2019
- Updated the MiDAS reference database versions to 3.6 and 4.6.

AmpProc5 v5.1.0.bet2.3  
Released for user evaluation: 29 October 2019
- Added option to indicate the archaeal V3-5 hypervariable region amplicons. Note that these are probably too long to stitch together into consensus reads from paired-end reads, so they should be run in single-read mode.

AmpProc5 v5.1.0.beta2.2  
Released for user evaluation: 24 October 2019
- Updated the MiDAS reference database versions to 3.5, and 4.5

AmpProc5 v5.1.0.beta2.1  
Released for user evaluation: 10 October 2019
- Changed the single reads truncate length to 250bp from 200bp in the standard workflow.
- The MiDAS workflow number of threads is now adjustable by the user.
- Added abundance-based and presence-absence-based Jaccard beta diversity metric in the Beta diversity workflow.

AmpProc5 v5.1.0.beta2.0  
Released for user evaluation: 27 September 2019
- Following is the update status of the reference databases
   - MiDAS 2.1.3 = unchanged
   - MiDAS 3.4 = newly implemented
   - MiDAS 4.4 = newly implemented
   - SILVA LTP = upgraded to v132
   - RDP training set v16 = unchanged
   - UNITE fungi = updated to v8.0  (ITS 1 and 2)
   - UNITE eukaryotes = newly implemented  (ITS 1 and 2)
- Added general workflow progress log file
- Added an input parameters log file so users have a record of what parameters they used in each run.
- Failure to properly build a zotu table under certain situations is now fixed, and zotu tables are properly generated.
- Updated Usearch10 to Usearch11
   - Replaced otutab_norm (obsolete) with otutab_rare.
- "usearch10 -cluster_agg" will remain default for generating the fungal cluster tree that is used to generate the unifrac matrices. Usearch11 no longer supports "-cluster_agg" but this is the recommended way to generate the tree prior to running unifrac for fungi.
- Fixed the issue where some of the representative reads were being excluded from the phylogenetic tree.
- The MiDAS ASV workflow now has the option to generate a phylogenetic tree and beta diversity output.
- The MiDAS ASV workflow has a choice of using either MiDAS 3 or 4 as reference database.

AmpProc5 v5.1.0.beta1.0  
Released for user evaluation: 10 September 2019
- Officially changed the script name to AmpProc5
- Added the MiDAS 3 ASVs workflow as an option

amplicon.workflow_v5.0.3.beta1.0.sh  
Released for user evaluation: 2 November 2018
- Added user environment configuration check to make sure that proper temporary folders are present for the QIIME steps.
- Added alias AmpProc5 as an executable command to run the script.
- Changed default number of threads used to 5 (originally 15) to account for the smaller servers.
- Polished the Help description

amplicon.workflow_v5.0.2.beta1.1.sh  
Released for user evaluation: 21 March 2018 
- Fixed the biom convert command, added the format parameter so the command works on Qiime 1.9.0
- Moved the prefilter step to after otu clustering, and lowered stringency, in order to speed up this step.

amplicon.workflow_v5.0.1.sh  
Released for user evaluation: 12 March 2018
- Fixed a bug in the taxonomy formatting of the final otutable.txt and zotutable.txt, where missing taxonomy levels in the middle of a taxonomy string were not recognized.
- Added version history information in the README file

amplicon.workflow_v5.0.sh  
Released for user evaluation: 7 February 2018
Major upgrade since version 4.3


