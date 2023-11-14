#!/bin/bash

MODIFIEDDATE="14 November 2023"

###############################################################################
#
#  Amplicon DNA workflow
#  script: install.sh
#
# This script will add to the script file the path where AmpProc is located. The script will also check to make sure that it can find the dependent software executables and that the correct path has been specified for the reference databases.
#
# To run, go to the directory where the AmpProc files are located and then type:  ./install.sh
#
#  Author: Erika Yashiro, Ph.D.
#
#
###############################################################################



# Set error check
set -e
set -o pipefail

# Check current path
CURRENTPATH=$(pwd)

echo ""
echo "Starting the install.sh script..."
echo $(date)
echo ""

# Add current path to AmpProc script. Use the below 2-line clunky approach because it's less buggy than a 1-liner approach.
echo ""
printf "Adding the current path to the ampproc script   "
sed '0,/^SCRIPTPATH=.*/ s//SCRIPTPATH=PathToYourScript/' AmpProc5.sh > ampproc
sed -i "s#SCRIPTPATH=PathToYourScript#SCRIPTPATH=$CURRENTPATH#g" ampproc
echo "... done."

# make ampproc executable
chmod a+x ampproc
echo "Created executable script: ampproc"

# Test AmpProc new script
echo "Testing whether ampproc works..."
./ampproc -testpath
if [ $? -eq 0 ]
  then
  echo "ok, ampproc test run was successful."
fi


# Add current path to ASVpipeline.sh
echo ""
printf "Adding the current path to the ASVpipeline.sh script   "
sed -i '0,/^SCRIPTPATH=.*/ s//SCRIPTPATH=PathToYourScript/' ASVpipeline.sh
sed -i "s#SCRIPTPATH=PathToYourScript#SCRIPTPATH=$CURRENTPATH#g" ASVpipeline.sh
echo "... done."

# make ASVpipeline.sh executable
#chmod a+x ASVpipeline.sh



######################################
# test all paths in ampproc_config.sh
######################################

# Import parameters file
SCRIPTPATH=$CURRENTPATH

if [ "$SCRIPTPATH/ampproc_config.sh" ]
  then
  printf "Importing ampproc_config.sh...  "
  source $SCRIPTPATH/ampproc_config.sh
  echo "  done."
  else
  echo "The file ampproc_config.sh cannot be found in $SCRIPTPATH"
  echo "You need to make sure that the file is here and that the paths to the scripts and databases are filled out manually in that file."
  echo "Once done, you can rerun install.sh."
  echo "exiting install.sh"
  exit 1
fi

# Test fastq.gz directory
printf "Can I find any fastq.gz files in the SEQPATH?   "
if [ -d "$SEQPATH" ]
  then
  TESTFIND=$(find $SEQPATH -name *.fastq.gz | sed -n '1p')
  if [ "$TESTFIND" ]
    then
    echo "... yes"
    else
    echo "fastq.gz files not found in the SEQPATH location."
  fi
  else
  echo "... SEQPATH directory cannot be found!"
fi


# Test if USEARCH is found
if [ -x "$USEARCH" ]
  then
  echo "usearch executable found."
  else
  echo "usearch executable's path may not be correct. Cannot find usearch."
fi

# Test if mafft is found
if [ -x "$MAFFT" ]
  then
  echo "mafft executable found."
  else
  echo "mafft executable's path may not be correct. Cannot find mafft."
fi

# Test if FastTreeMP is found
if [ -x "$FATTREEMP" ]
  then
  echo "FastTreeMP found."
  else
  echo "FastTreeMP executable's path may not be correct. Cannot find FastTreeMP."
fi

# Test if newick script is found
if [ -x "$NEWICK" ]
  then
  echo "newick found."
  else
  echo "newick executable's path may not be correct. Cannot find newick."
fi

# Test that python version is v3
if [[ $(pip --version | grep "python 3") ]]
  then
  echo "Python 3 found."
  else
  echo "Python 3 could not be accessed using pip"
fi

# Test if scikit bio is available.
if [[ $(pip list | grep "scikit-bio") ]]
  then
  echo "Scikit-bio found."
  else
  echo "Scikit-bio not found."
fi


# Test if Greengnes 97_otus.fasta is found
if [ -f "$GG97REF" ]
  then
  FILENAME=$(echo "$GG97REF" | rev | cut -d "/" -f 1 | rev)
  if [ "$FILENAME" == "97_otus.fasta" ]
    then
     echo "GG97REF found."
     else
     echo "GG97REF was found, but it was not named $FILENAME"
  fi
  else
  echo "GG97REF not found or the path may not be correct."
fi

# Test if Silva LPT dbs is found
if [ -f "$REFDATAPATHsilvaLTP132" ]
  then
  FILENAME=$(echo "$REFDATAPATHsilvaLTP132" | rev | cut -d "/" -f 1 | rev)
  if [ "$FILENAME" == "silva_132_qiime99_16S_sorted.sintax.fasta" ]
    then
    echo "REFDATAPATHsilvaLTP132 found."
    else
    echo "REFDATAPATHsilvaLTP132 was found, but it is not named $FILENAME"
  fi
  else
  echo "REFDATAPATHsilvaLTP132 not found or the path may not be correct."
fi

# Test if SILVA 132 is found
if [ -f "$REFDATAPATHsilva99pc132" ]
  then
  FILENAME=$(echo "$REFDATAPATHsilva99pc132" | rev | cut -d "/" -f 1 | rev)
  if [ "$FILENAME" == "silva_132_qiime99_16S_sorted.sintax.fasta" ]
    then
    echo "REFDATAPATHsilva99pc132 found."
    else
    echo "REFDATAPATHsilva99pc132 was found, but it is not named $FILENAME"
  fi
  else
  echo "REFDATAPATHsilva99pc132 not found or the path may be not correct."
fi

# Test if SILVA latest version is found
if [ -f "$REFDATAPATHsilva99pc1381" ]
  then
  FILENAME=$(echo "$REFDATAPATHsilva99pc1381" | rev | cut -d "/" -f 1 | rev)
  if [ "$FILENAME" == "SILVA_138.1_SSURef_NR99_tax_silva_trunc.sintax.fasta" ]
    then
    echo "REFDATAPATHsilva99pc1381 found."
    else
    echo "REFDATAPATHsilva99pc1381 was found but it was not named $FILENAME."
  fi
  else
  echo "REFDATAPATHsilva99pc1381 not found or the path may be not correct."
fi

# Test if MiDAS 2.1.3 is found
if [ -f "$REFDATAPATHmidas2" ]
  then
  FILENAME=$(echo "$REFDATAPATHmidas2" | rev | cut -d "/" -f 1 | rev)
  if [ "$FILENAME" == "SINTAX_fa_file_MiDAS_2.1.3.fa" ]
    then
    echo "REFDATAPATHmidas2 found."
    else
    echo "REFDATAPATHmidas2 was found, but it was not named $FILENAME."
  fi
  else
  echo "REFDATAPATHmidas2 not found or the path may not be correct."
fi

# Test if MiDAS v3.7 is found
if [ -f "$REFDATAPATHmidas3" ]
  then
  FILENAME=$(echo "$REFDATAPATHmidas3" | rev | cut -d "/" -f 1 | rev)
  if [ "$FILENAME" == "SINTAX_fa_file_MiDAS_3.7.fa" ]
    then
    echo "REFDATAPATHmidas3 found."
    else
    echo "REFDATAPATHmidas3  was found, but it was not named $FILENAME. Make sure to replace the spaces in the file name with underscores."
  fi
  else
  echo "REFDATAPATHmidas3 not found or the path may not be correct. Make sure to replace the spaces in the file name with underscores."
fi

# Test if MiDAS lastest version is found
if [ -f "$REFDATAPATHmidas4" ]
  then
  FILENAME=$(echo "$REFDATAPATHmidas4" | rev | cut -d "/" -f 1 | rev)
  if [ "$FILENAME" == "SINTAX_fa_MiDAS_5.1.fa" ]
    then
    echo "REFDATAPATHmidas4 (latest version is v5.1) found."
    else
    echo "REFDATAPATHmidas4  was found, but it was not named $FILENAME. Make sure to replace the spaces in the file name with underscores."
  fi
  else
  echo "REFDATAPATHmidas4 (latest version of MiDAS) not found or the path may not be correct. Make sure to replace the spaces in the file name with underscores"
fi

# Test if RDP training set is found
if [ -f "$REFDATAPATHrdp" ]
  then
  FILENAME=$(echo "$REFDATAPATHrdp" | rev | cut -d "/" -f 1 | rev)
  if [ "$FILENAME" == "rdp_16s_v16s_sp_sintax.cleaned.20180103.fa" ]
    then
    echo "REFDATAPATHrdp found."
    else
    echo "REFDATAPATHrdp  was found, but it was not named $FILENAME."
  fi
  else
  echo "REFDATAPATHrdp not found or the path may not be correct."
fi

# Test if UNITE Fungi is found
if [ -f "$REFDATAPATHuniteFUN" ]
  then
  FILENAME=$(echo "$REFDATAPATHuniteFUN" | rev | cut -d "/" -f 1 | rev)
  if [ "$FILENAME" == "utax_reference_dataset_fungi_25.07.2023.v9.0.corrected.fasta" ]
    then
    echo "REFDATAPATHuniteFUN found."
    else
    echo "REFDATAPATHuniteFUN  was found, but it was not named $FILENAME."
  fi
  else
  echo "REFDATAPATHuniteFUN not found or the path may not be correct."
fi

# Test if UNITE Eukaryote is found
if [ -f "$REFDATAPATHuniteEUK" ]
  then
  FILENAME=$(echo "$REFDATAPATHuniteEUK" | rev | cut -d "/" -f 1 | rev)
  if [ "$FILENAME" == "utax_reference_dataset_all_25.07.2023.v9.0.corrected.fasta" ]
    then
    echo "REFDATAPATHuniteEUK found."
    else
    echo "REFDATAPATHuniteEUK was found, but it was not named $FILENAME."
  fi
  else
  echo "REFDATAPATHuniteEUK not found or the path may not be correct."
fi

# Test if Mitofish is found
if [ -f "$REFDATAPATH12sMitohelper" ]
  then
  FILENAME=$(echo "$REFDATAPATH12sMitohelper" | rev | cut -d "/" -f 1 | rev)
  if [ "$FILENAME" = "12S.Mar2021.sintax.fasta" ]
    then
    echo "REFDATAPATH12sMitohelper found."
    else
    echo "REFDATAPATH12sMitohelper was found, but it was not named $FILENAME."
  fi
  else
  echo "REFDATAPATH12sMitohelper not found or the path may not be correct."
fi

# Test if MIDORI Unique is found
if [ -f "$REFDATAPATH12sMIDORIuniq" ]
  then
  FILENAME=$(echo "$REFDATAPATH12sMIDORIuniq" | rev | cut -d "/" -f 1 | rev)
  if [ "$FILENAME" == "MIDORI2_UNIQ_NUC_GB257_srRNA_SINTAX.fasta" ]
    then
    echo "REFDATAPATH12sMIDORIuniq found."
    else
    echo "REFDATAPATH12sMIDORIuniq  was found, but it was not named $FILENAME."
  fi
  else
  echo "REFDATAPATH12sMIDORIuniq not found or the path may not be correct."
fi

# Test if MIDORI Long is found
if [ -f "$REFDATAPATH12SMIDORIlong" ]
  then
  FILENAME=$(echo "$REFDATAPATH12SMIDORIlong" | rev | cut -d "/" -f 1 | rev)
  if [ "$FILENAME" == "MIDORI2_LONGEST_NUC_GB257_srRNA_SINTAX.fasta" ]
    then
    echo "REFDATAPATH12SMIDORIlong found."
    else
    echo "REFDATAPATH12SMIDORIlong was found, but it was not named $FILENAME."
  fi
  else
  echo "REFDATAPATH12SMIDORIlong not found or the path may not be correct."
fi

echo "If the dependent executables were not found, you will need to fix the paths in the ampproc_config.sh, export the correct paths in the PATHS, and/or install the packages. You can rerun this installation script again."
echo "The install script has finished."
echo "Bye bye!"
echo ""
exit 0
