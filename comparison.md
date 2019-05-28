# Nanopore comparison

### Filter unknown chromosomes
```
for f in `find . -name '*.vcf'`; do awk '($1 !~/^$/)&&($1=="chr1"||$1=="chr2"||$1=="chr3"||$1=="chr4"||$1=="chr5"||$1=="chr6"||$1=="chr7"||$1=="chr8"||$1=="chr9"||$1=="chr10"||$1=="chr11"||$1=="chr12"||$1=="chr13"||$1=="chr14"||$1=="chr15"||$1=="chr16"||$1=="chr17"||$1=="chr18"||$1=="chr19"||$1=="chr20"||$1=="chr21"||$1=="chr22"||$1=="chrX"||$1=="chrY"||$1~/^##/)&&($3 !="gap"){print$0}' $f > ${f%vcf}chr.vcf; done
```

### Extract insertions/duplications & filter >30bp && <=100kb
```
for f in `find . -name "*.chr.vcf"`; do awk '$0!~/#/{split($0,a,"SVLEN=");split(a[2],b,";");if($2>0&&($5=="<INS>"||$5=="<DUP>")){if(b[1]<=100000&&b[1]>30){print $1"\t"$2-1"\t"$2-1"\t"b[1];}}}' $f > ${f%vcf}ins.bp.bed; done
```

### Extract deletions & filter >30bp && <=100kb
```
for f in `find . -name "*.chr.vcf"`; do awk '$0!~/#/{split($0,a,"END=");split(a[2],b,";");if($2>0&&($5=="<DEL>")){if($2<=b[1]&&b[1]-$2<=100000&&b[1]-$2>30){print $1"\t"$2-1"\t"b[1]-1"\t"b[1]-$2;}else if($2>b[1]&&$2-b[1]<=100000&&b[1]-$2>30){print $1"\t"b[1]-1"\t"$2-1"\t"$2-b[1];}}}' $f > ${f%vcf}del.bed; done
```

### Sort
```
for f in `find . -name '*.chr.*.bed'`; do bedtools sort -i $f > ${f%bed}sort.bed; done
```

### Merge overlapping regions
```
for f in `find . -name '*.chr.del*.sort.bed'`; do bedtools merge -i $f -c 4 -o collapse > ${f%bed}merge.bed; done
```

### Liftover true sets
```
liftOver NA12878.sort.bed hg19ToHg38.over.chain NA12878_hg38.sort.bed unmapped.bed
```

### Compare
```
# Deletions
# callset overlaps with trueset represented by callset
OVERLAP_CALL_DEL=`bedtools intersect -f 0.50 -wa -a $CALLSET_DEL -b $TRUESET_DEL | sort | uniq | wc -l | awk '{print $1}'`
TOTAL_CALL_DEL=`wc -l $CALLSET_DEL | awk '{print $1}'`
PRE_DEL=echo "scale=4; $OVERLAP_CALL_DEL/TOTAL_CALL_DEL" | bc
# trueset overlaps with callset represented by trueset
OVERLAP_TRUE_DEL=`bedtools intersect -f 0.50 -wa -b $CALLSET_DEL -a $TRUESET_DEL | sort | uniq | wc -l | awk '{print $1}'`
TOTAL_TRUE_DEL=`wc -l $TRUESET_DEL | awk '{print $1}'`
SEN_DEL=echo "scale=4; $OVERLAP_TRUE_DEL/TOTAL_TRUE_DEL" | bc

F1_DEL=echo "scale=4; 2*($PRE_DEL*$SEN_DEL)/($PRE_DEL+$SEN_DEL)" | bc

# Insertions
# callset overlaps with trueset represented by callset
OVERLAP_CALL_INS=`bedtools window -u -w 100 -a $CALLSET_INS -b $TRUESET_INS | sort | uniq | wc -l | awk '{print $1}'`
TOTAL_CALL_INS=`wc -l $CALLSET_INS | awk '{print $1}'`
PRE_INS=echo "scale=4; $OVERLAP_CALL_INS/TOTAL_CALL_INS" | bc
# trueset overlaps with callset represented by trueset
OVERLAP_TRUE_INS=`bedtools window -u -w 100 -b $CALLSET_INS -a $TRUESET_INS | sort | uniq | wc -l | awk '{print $1}'`
TOTAL_TRUE_INS=`wc -l $TRUESET_INS | awk '{print $1}'`
SEN_INS=echo "scale=4; $OVERLAP_TRUE_INS/TOTAL_TRUE_INS" | bc

F1_DEL=echo "scale=4; 2*($PRE_DEL*$SEN_DEL)/($PRE_DEL+$SEN_DEL)" | bc


```
