#!/bin/bash

# $1: test
# $2: truth ins
# $3: truth del

cat $1 | grep -e "#" -e "INS" | bedtools window -w 100 -u -a stdin -b $2 > overlap_ins.vcf

cat $1 | grep -e "#" -e "DEL" | bedtools intersect -f 0.5 -wa -a stdin -b $3 > overlap_del.vcf

cat overlap_del.vcf overlap_ins.vcf > overlap.vcf

awk 'NR==FNR{a[$1"-"$2"-"$4]==1;next;}$0!~/#/{if($1"-"$2"-"$4 in a){print "True"}else{print "False"}}' overlap.vcf $1 > ${1}_label.txt

rm overlap_ins.vcf overlap_del.vcf overlap.vcf
