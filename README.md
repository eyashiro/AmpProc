# README

Last modified: 6 April 2021

Author: Erika Yashiro, Ph.D.

Script name: AmpProc

Version: 5.1.0.beta2.12.0


########################################

### Contents
   - How to run the help function with usage instructions
   - How to cite the tools used in the workflow
   - Information on reference databases used for taxonomic classification
   - General output file formats
   - Version history


########################################

### To run the help function with usage instructions, type either:

AmpProc5.1 -h

OR

AmpProc5.1 -help

########################################



# For citing the tools used in the workflow:

--------
AmpProc
--------
This is a custom workflow that processes raw amplicon reads. AmpProc acts BOTH as a wrapper for other published software as well as a script that processes and reformats data for downstream applications.  
AmpProc is mainly geared toward amplicon data sequenced on the Illumina sequencing platforms, but I can implement further QC features to handle other technologies if you ask me for them.  
Currently, AmpProc handles mostly ribosomal operon amplicons, and other amplicon types are also now possible to process.  
Author: Erika Yashiro, Ph.D.  
https://github.com/eyashiro/AmpProc

The MiDAS workflow (ASVpipeline.sh) is a collaboration with Kasper Skytte Andersen. The version in AmpProc was adapted from the original version in https://github.com/KasperSkytte/ASV_pipeline

---------------
USEARCH 10 & 11
---------------
version: usearch10.0.240_i86linux64 (used only in one step of Fungi/Eukaryote to generate cluster tree)  
version: usearch11.0.667_i86linux64 (used for all steps of AmpProc)

USEARCH and UCLUST algorithms  
Edgar, R.C. (2010) Search and clustering orders of magnitude faster than BLAST, Bioinformatics 26(19), 2460-2461.  
doi: 10.1093/bioinformatics/btq461

SINTAX algorithm = Taxonomy assignment  
Edgar, R.C. (2016), SINTAX, a simple non-Bayesian taxonomy classifier for 16S and ITS sequences, http://dx.doi.org/10.1101/074161.

UNOISE algorithm = Those who use the unoise3 ZOTU clustering  
Edgar, R.C. (2016), UNOISE2: Improved error-correction for Illumina 16S and ITS amplicon reads.http://dx.doi.org/10.1101/081257

Expected error filtering and paired read merging = Paired-end read merging  
Edgar, R.C. and Flyvbjerg, H (2014) Error filtering, pair assembly and error correction for next-generation sequencing reads  [doi: 10.1093/bioinformatics/btv401].

UPARSE algorithm = OTU clustering  
Edgar, R.C. (2013) UPARSE: Highly accurate OTU sequences from microbial amplicon reads, Nature Methods [Pubmed:23955772,  dx.doi.org/10.1038/nmeth.2604].

--------------------
QIIME 1.9.1
--------------------

QIIME = used for running PYNAST sequence alignment tool used prior to tree-building for prokaryote amplicons, and beta diversity analysis

QIIME allows analysis of high-throughput community sequencing data
J Gregory Caporaso, Justin Kuczynski, Jesse Stombaugh, Kyle Bittinger, Frederic D Bushman, Elizabeth K Costello, Noah Fierer, Antonio Gonzalez Pena, Julia K Goodrich, Jeffrey I Gordon, Gavin A Huttley, Scott T Kelley, Dan Knights, Jeremy E Koenig, Ruth E Ley, Catherine A Lozupone, Daniel McDonald, Brian D Muegge, Meg Pirrung, Jens Reeder, Joel R Sevinsky, Peter J Turnbaugh, William A Walters, Jeremy Widmann, Tanya Yatsunenko, Jesse Zaneveld and Rob Knight; Nature Methods, 2010; doi:10.1038/nmeth.f.303

--------
Fasttree
--------

Fasttree 2.1 = Tree algorithm for V13 and V4, used for Unifrac Beta diversity matrices  
Price, M.N., Dehal, P.S., and Arkin, A.P. (2009) FastTree: Computing Large Minimum-Evolution Trees with Profiles instead of a Distance Matrix. Molecular Biology and Evolution 26:1641-1650, doi:10.1093/molbev/msp077.


########################################


# Information on reference databases used for taxonomic classification

The reference databases linked to AmpProc are updated as needed at each AmpProc version change.

The databases have been slightly reformatted in order to be compatible with USEARCH's sintax function. Notably, you may notice that parentheses were replaced by double underscores, and commas by single underscore. Ambiguous taxon names were also removed (e.g. Ambiguous taxa, unknown, unidentified, uncultured, metagenome).


########################################


# GENERAL OUTPUT FILE FORMATS:


All OTU related files are indicated &ast;otu&ast;.  
All ZOTU related files are indicated &ast;zotu&ast; and &ast;asv&ast;.  
Single read equivalents are indicated &ast;R1&ast; and &ast;R2&ast;.  
Bellow are indicated the output files using OTU as an example. Everything written also applies for zotus.  

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

# VERSION HISTORY

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


