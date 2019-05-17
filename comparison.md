# Nanopore comparison
### Filter unknown chromosomes
```
for f in `find . -name '*.vcf'`; do awk '($1 !~/^$/)&&($1=="chr1"||$1=="chr2"||$1=="chr3"||$1=="chr4"||$1=="chr5"||$1=="chr6"||$1=="chr7"||$1=="chr8"||$1=="chr9"||$1=="chr10"||$1=="chr11"||$1=="chr12"||$1=="chr13"||$1=="chr14"||$1=="chr15"||$1=="chr16"||$1=="chr17"||$1=="chr18"||$1=="chr19"||$1=="chr20"||$1=="chr21"||$1=="chr22"||$1=="chrX"||$1=="chrY"||$1~/^##/)&&($3 !="gap"){print$0}' $f > ${f%vcf}chr.vcf; done
```

### Extract insertions/duplications & filter <100kb && >30kb
```
# len
for f in `find . -name '*.chr.vcf'`; do awk '$0!~/#/{split($0,a,"SVLEN=");split(a[2],b,";");if($2>0&&($5=="<INS>"||$5=="<DUP>")){if(b[1]<=100000&&b[1]>30){print $1"\t"$2-1"\t"$2+b[1]-1;}}}' $f > ${f%vcf}ins.len.bed; done

#bp
for f in `find . -name '*.chr.vcf'`; do awk '$0!~/#/{split($0,a,"SVLEN=");split(a[2],b,";");if($2>0&&($5=="<INS>"||$5=="<DUP>")){if(b[1]<=100000&&b[1]>30){print $1"\t"$2-1"\t"$2;}}}' $f > ${f%vcf}ins.bp.bed; done
```

### Extract deletions & filter <100kb && >30kb
```
for f in `find . -name '*.chr.vcf'`; do awk '$0!~/#/{split($0,a,"END=");split(a[2],b,";");if($2>0&&($5=="<DEL>")){if($2<=b[1]&&b[1]-$2<=100000&&b[1]-$2>30){print $1"\t"$2-1"\t"b[1]-1;}else if($2>b[1]&&$2-b[1]<=100000&&b[1]-$2>30){print $1"\t"b[1]-1"\t"$2-1;}}}' $f > ${f%vcf}del.bed; done
```

### Sort
```
for f in `find . -name '*.chr.*.bed'`; do bedtools sort -i $f > ${f%bed}sort.bed; done
```

### Merge overlapping regions
```
for f in `find . -name '*.chr.*.sort.bed'`; do bedtools merge -i $f -c 1 -o count > ${f%bed}merge.bed; done
```

### Compare
```
#Deletions
bedtools intersect -f 0.50 -wa -a $CALLSET -b $TRUESET | sort | uniq | wc -l

#Insertions
bedtools window -u -w 100 -a $CALLSET -b $TRUESET | sort | uniq | wc -l
```

### Integrate
```
cat graphmap-nanosv/nanosv.chr.del.sort.merge.bed graphmap-sniffles/sniffles.chr.del.sort.merge.bed ngmlr-nanosv/nanosv.chr.del.sort.merge.bed ngmlr-sniffles/sniffles.chr.del.sort.merge.bed minimap2-nanosv/nanosv.chr.del.sort.merge.bed minimap2-sniffles/sniffles.chr.del.sort.merge.bed last-picky/picky.allsv.chr.del.sort.merge.bed > cat.del.bed

cat graphmap-nanosv/nanosv.chr.ins.bp.sort.merge.bed graphmap-sniffles/sniffles.chr.ins.bp.sort.merge.bed ngmlr-nanosv/nanosv.chr.ins.bp.sort.merge.bed ngmlr-sniffles/sniffles.chr.ins.bp.sort.merge.bed minimap2-nanosv/nanosv.chr.ins.bp.sort.merge.bed minimap2-sniffles/sniffles.chr.ins.bp.sort.merge.bed last-picky/picky.allsv.chr.ins.bp.sort.merge.bed > cat.ins.bed

bedtools sort -i cat.del.bed | bedtools merge -c 1 -o count > merged.del.bed

awk '$4>=2{print}' merged.del.bed > consensus2.del.bed
```

### Calculate length dist for plot
```
#del
for f in `find ../mtsinai/ -name "*del.sort.merge.bed"`; do n=`echo $f | cut -f3 -d'/'`; echo $n", "$f; bedtools intersect -f 0.50 -wa -a $f -b ../mtsinai/NA12878.pass.del.sort.merge.bed | sort | uniq | awk '{print($3-$2)}' > na-$n.true.length; bedtools intersect -f 0.50 -v -wa -b $f -a ../mtsinai/NA12878.pass.del.sort.merge.bed | sort | uniq | awk '{print($3-$2)}' > na-$n.missed.length; bedtools intersect -f 0.50 -v -wa -a $f -b ../mtsinai/NA12878.pass.del.sort.merge.bed | sort | uniq | awk '{print($3-$2)}' > na-$n.false.length; done

#ins
for f in `find ../mtsinai -name "*ins.len.sort.merge.bed"`; do n=`echo $f | cut -f3 -d'/'`; echo $n", "$f; bedtools window -w 100 -u -a $f -b ../mtsinai/NA12878.pass.ins.len.sort.merge.bed | sort | uniq | awk '{print($3-$2)}' > na-$n.true.length; bedtools window -w 100 -v -b $f -a ../mtsinai/NA12878.pass.ins.len.sort.merge.bed | sort | uniq | awk '{print($3-$2)}' > na-$n.missed.length; bedtools window -w 100 -v -a $f -b ../mtsinai/NA12878.pass.ins.len.sort.merge.bed | sort | uniq | awk '{print($3-$2)}' > na-$n.false.length; done
```
