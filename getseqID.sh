#!/bin/bash

VERSIONNUMBER=1.0
MODIFIEDDATE="29 April 2020"

###################################################################################################
#
# Usage: getseqID.sh [input list of query IDs]
# 
# Companion script to AmpProc.
# This script retrieves the LIB and Sequence IDs from either the LIB or SEQ ID user query.
#
# It is currently only supported for internal use at Aalborg University.
# 
# Author: Erika Yashiro, Ph.D.
#
###################################################################################################

# Check if user is running in Bash or Shell
if [ ! -n "$BASH" ]
    then
    echo "Please rerun this script with bash (bash), not shell (sh)."
    echo ""
    echo "Rerun the script with the -h or -help for more information."
    exit 1
fi

# Set error check
set -e
set -o pipefail

#############
# PARAMETERS
#############

# Define the location of the sequences folders
SEQPATH="/space/sequences/"

# Define script start date-time
STARTTIME=$(date '+%Y%m%d-%H%M%S')

#LISTFILE=$1

# Reference seqID/libID list location and file name
#REFPATH=/home/erika/Documents/test_LIB/tmpout3
REFPATH=/space/HiSeqUser/SeqLibID_reference
REFLIST=SeqLibID.txt

#########################################################
# HELP
#########################################################

#if [[ $1 =~ ^(-h|-help)$ ]]  => only works with bash, not shell.
Help_Function () {
    echo ""
    echo "############################################################################"
    echo "#"
    echo "# getseqID version $VERSIONNUMBER"
    echo "#"
    echo "# Companion script to AmpProc."
    echo "# This script retrieves the LIB and Sequence IDs from either the LIB or "
    echo "# SEQ ID user query."
    echo "# Under default mode, it will first create a reference list "
    echo "# of all available Lib and Seq IDs. This could take some time so"
    echo "# use the -x to avoid updating the reference list too often."
    echo "#"
    echo "# It is currently only supported for internal use at Aalborg University."
    echo "# "
    echo "# Author: Erika Yashiro, Ph.D."
    echo "#"
    echo "# Last modified: $MODIFIEDDATE"
    echo "#"
    echo "############################################################################"
   echo ""
   echo ""
   echo "Usage: getseqID -i [ID name] -x"
   echo "Usage: getseqID -f [ID list file] -x"
   echo ""
   echo "   -i               Input LIB or SEQ ID name"
   echo "   -f               Input file with list of LIB and/or SEQ ID names"
   echo "   -x               Set -x to use existing ID reference list"
   echo "   -v/-V --version  Output the script's version number and when the ID reference list was last updated"
   echo "   -h -help         Output the help information"
   echo ""
   exit 0
}

# Arguments: help/h
if [[ "$1" =~ ^(-help|-h)$ ]]
  then
  Help_Function
  else
  if [[ "$1" =~ ^(-v|-V|--version)$ ]]
     then
     echo "getseqID version: $VERSIONNUMBER"
     printf "ID reference list was last updated: "
     cat $REFPATH/version.txt
     exit
     else
     # if there are parameters present
     if [ $1 ]
       then
       while getopts :i:f:x option
         do
         case "${option}"
         in
         # -i input LIB or SEQ ID name
         i) IDNAME=${OPTARG} ;;

         # -f input LIB or SEQ ID list file
         f) LISTFILE=${OPTARG}
            # Check if input file is present
            if [ ! -f "$LISTFILE" ]
               then
               echo "Input file $LISTFILE does not exist. If you have some weird characters (or spaces) in your file name, I'm too stupid to interpret them. Exiting script"
               exit 1
            fi
            ;;

         # -x do not update the sequencing STATS reference file
         x) UPDATEREF="no"
            ;;

         \?) echo ""
             echo "Invalid option: $OPTARG" >&2
             echo "Check the help function using -help of -h"
             echo "Exiting script. "
             echo ""
             exit 1 ;;

         :) echo ""
            echo "Option -$OPTARG requires an argument"
            echo "Check the help function using -help or -h"
            echo "Exiting script."
            echo ""
            exit 1 ;;
         esac
         done
         else
           echo "Parameters are required."
           echo "Check the help function using -help or -h"
           echo "Exiting script."
           echo ""
           exit 1
     fi
  fi
fi



# Extract all LIB-ID + MQ-ID lines from STAT files.
#find $SEQPATH -name STATS-*.txt 2>/dev/null -exec sed -n '/\[Data\]/,/bcl2fastq command line/p' > 

 # this also works recursively from indicated path.
#find . -name "STATS*.txt" -exec sed -n '/\[Data\]/,/bcl2fastq command line/p' {} \; > tmpout2

if [ "$UPDATEREF" != "no" ]
  then
  # Generate the full list of SeqIDs / LibIDs from the STATS files.
  echo "Updating the list of SeqIDs and LibIDs..."
  find $SEQPATH -name "STATS*.txt" -exec sed -n '/\[Data\]/,/bcl2fastq command line/p' {} \; | sed -e '/\[Data\]/d' -e '/bcl2fastq command line/d' -e '/Sample_ID,Sample_Name,index,index2,Description/d' -e '/^$/d' > $REFPATH/$REFLIST
  date > $REFPATH/version.txt
  echo "   Done."
  echo ""
  else
    echo ""
    printf "SeqID and LibId reference list last updated: "
    cat $REFPATH/version.txt
    echo ""
fi

# Retrieve query LibIDs and SeqIDs
if [ "$LISTFILE" ]
  then
  echo "Retrieving query list of Lib/Seq IDs..."
  # check that ID list file is usable.
  cp $LISTFILE tmplist0.txt
  dos2unix -q tmplist0.txt
  cat tmplist0.txt | sed -e '$a\' | sed -e '/^$/d' -e 's/ //g' > tmplist.txt
  rm tmplist0.txt

  echo "Sample_ID,Sample_Name,index,index2,Description" > Illumina_seqIDs_out.txt
  grep -w -F -f tmplist.txt $REFPATH/$REFLIST >> Illumina_seqIDs_out.txt
  rm tmplist.txt
  echo ""
  echo "Output file is ready: Illumina_seqIDs_out.txt"
fi

if [ "$IDNAME" ]
  then
  echo "Retrieving query Lib/Seq ID..."
  echo ""
  echo "Sample_ID,Sample_Name,index,index2,Description"
  grep -w "$IDNAME" $REFPATH/$REFLIST
  echo ""
fi



