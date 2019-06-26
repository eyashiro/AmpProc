#!/bin/bash

#######################################################
#
# Script: otutab_sintax_to_ampvis.v1.1.sh
#
# Author: Erika Yashiro, Ph.D.
#
# Last modified: 13 March, 2018
#
# script.sh -i [otu table_notax] -t [sintax.out.txt] -r [which reference database used for sintax]
#
# REFDATABASE: MiDAS / SILVA (or silva) / RDP / UNITE
#
#######################################################

# Set error check
set -e
set -o pipefail


while getopts :i:t:r: option
   do
   case "${option}"
   in
   i) OTUTABLE_NOTAX=${OPTARG} ;;
   t) SINTAX=${OPTARG} ;;
   r) REFDATABASE=${OPTARG} ;;
   \?) echo ""
       echo "Invalid option: -$OPTARG" >&2
       echo ""
       echo "Usage: script.sh -i [otutable_notax.txt] -t [sintax.out.txt] -r [which reference database used for sintax]"
       echo ""
       echo "Exiting script."
       echo ""
       exit 1 ;;
   :) echo ""
      echo "Option -$OPTARG requires an argument"
      echo ""
      echo "Usage: script.sh -i [otutable_notax.txt] -t [sintax.out.txt] -r [which reference database used for sintax]"
      echo ""
      echo "Exiting script."
      echo ""
      exit 1 ;;
   esac
done


# Input files:
#OTUTABLE_NOTAX=$1
#SINTAX=$2
#REFDATABASE=$3
# REFDATABASE: MiDAS / SILVA / RDP / UNITE

# Remove file extension from input otu table name.
FILERAD=`echo $OTUTABLE_NOTAX | sed 's/\..*//g'`

# Sort otu table (-V is version sort)
awk 'NR<2{print $0; next}{print $0 | "sort -k1 -V"}' $OTUTABLE_NOTAX | sed 's/#OTU ID/OTU/g' > otutable_notax_sorted.txt

# In some cases, especially with zotus, a couple raw reads match the same otus/zotus. In such a case some of the otus/zotus get eliminated from the final z/otu table and cause the joining of taxonomy and frequency table to fail.
# Remove entries that don't match up between z/otu table and sintax output.
   # z/otu list from z/otu table
cut -f1 $OTUTABLE_NOTAX > label_otu
  # z/otu list from sintax output
cut -f1 $SINTAX > label_sintax
  # remove non-congruent z/otus from sintax file
cat label_otu label_sintax | sort | uniq -u > label_uniques
grep -v -w -F -f label_uniques $SINTAX | sed '/^--$/d' > $SINTAX.trimmed

# Extract columns, sort
#awk -F "\t" '{ print $1"\t"$4 }' $SINTAX | sed 's/,/\t/g' | sort -k1 -V >> $SINTAX.sorted.tmp
awk -F "\t" '{ print $1"\t"$4 }' $SINTAX.trimmed | sort -k1 -V > $SINTAX.sorted.tmp0

# Extract just the taxonomy column
awk -F "\t" '{ print $2 }' $SINTAX.sorted.tmp0 > $SINTAX.sorted.tmp

#echo "Hello, $SINTAX.sorted.tmp"
#head $SINTAX.sorted.tmp
# Swap domain for kingdom if presented as such
#BACTDOMAIN=$(head -n 10 $SINTAX.sorted.tmp | grep -c "^d")
#head -n10 $SINTAX.sorted.tmp | grep "d:" | wc -l
#echo "domain: $BACTDOMAIN"

#if [ -n $DOMAIN ]
#if [ "$BACTDOMAIN" -le 0 ]
#  then
#  sed -i 's/d:/k:/g' $SINTAX.sorted.tmp
#  else
#  echo ""
#fi

# Check presence of all taxonomy levels
awk -F ',' 'OFS="," { if ($1 !~ /k:/) {$1="k:,"$1; print $0} else {print $0} }' $SINTAX.sorted.tmp > $SINTAX.sorted.tmpa

awk -F ',' 'OFS="," { if ($2 !~ /p:/) {$2="p:,"$2; print $0} else {print $0} }' $SINTAX.sorted.tmpa > $SINTAX.sorted.tmpb

awk -F ',' 'OFS="," { if ($3 !~ /c:/) {$3="c:,"$3; print $0} else {print $0} }' $SINTAX.sorted.tmpb > $SINTAX.sorted.tmpc

awk -F ',' 'OFS="," { if ($4 !~ /o:/) {$4="o:,"$4; print $0} else {print $0} }' $SINTAX.sorted.tmpc > $SINTAX.sorted.tmpd

awk -F ',' 'OFS="," { if ($5 !~ /f:/) {$5="f:,"$5; print $0} else {print $0} }' $SINTAX.sorted.tmpd > $SINTAX.sorted.tmpe

awk -F ',' 'OFS="," { if ($6 !~ /g:/) {$6="g:,"$6; print $0} else {print $0} }' $SINTAX.sorted.tmpe > $SINTAX.sorted.tmpf

awk -F ',' 'OFS="," { if ($7 !~ /s:/) {$7="s:"$7; print $0} else {print $0} }' $SINTAX.sorted.tmpf > $SINTAX.sorted.tmpg

# replace kingdom with domain if necessary
#if [ -n $DOMAIN ]
#if [ $DOMAINpresent -gt 0 ]
#  then
#  sed -i 's/k:/d:/g' $SINTAX.sorted.tmpg
#fi

# Reappend the OTU column
awk -F "\t" '{ print $1 }' $SINTAX.sorted.tmp0 > $SINTAX.sorted.tmp00
paste -d "\t" $SINTAX.sorted.tmp00 $SINTAX.sorted.tmpg > $SINTAX.sorted.tmph

# Append all columns and header
    printf "OTU\tKingdom\tPhylum\tClass\tOrder\tFamily\tGenus\tSpecies\n" > $SINTAX.sorted
    sed -e 's/:/__/g' -e 's/,/\t/g' $SINTAX.sorted.tmph >> $SINTAX.sorted


# Append tax to otutable
#join -t '	' otutable_notax_sorted.txt $SINTAX.sorted > ${FILERAD}_${REFDATABASE}.txt
join -t $'\t' otutable_notax_sorted.txt $SINTAX.sorted > ${FILERAD}_${REFDATABASE}.txt

mv otutable_notax_sorted.txt ${FILERAD}_${REFDATABASE}.sorted.txt

rm $SINTAX.trimmed label_otu label_sintax label_uniques
rm $SINTAX.sorted
rm $SINTAX.sorted.tmp*
#rm otutable_notax_sorted.txt



