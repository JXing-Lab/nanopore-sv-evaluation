cat graphmap-nanosv/nanosv.chr.del.sort.merge.bed graphmap-sniffles/sniffles.chr.del.sort.merge.bed ngmlr-nanosv/nanosv.chr.del.sort.merge.bed ngmlr-sniffles/sniffles.chr.del.sort.merge.bed minimap2-nanosv/nanosv.chr.del.sort.merge.bed minimap2-sniffles/sniffles.chr.del.sort.merge.bed last-picky/picky.allsv.chr.del.sort.merge.bed > cat.del.bed

cat graphmap-nanosv/nanosv.chr.ins.bp.sort.merge.bed graphmap-sniffles/sniffles.chr.ins.bp.sort.merge.bed ngmlr-nanosv/nanosv.chr.ins.bp.sort.merge.bed ngmlr-sniffles/sniffles.chr.ins.bp.sort.merge.bed minimap2-nanosv/nanosv.chr.ins.bp.sort.merge.bed minimap2-sniffles/sniffles.chr.ins.bp.sort.merge.bed last-picky/picky.allsv.chr.ins.bp.sort.merge.bed > cat.ins.bed

bedtools sort -i cat.del.bed | bedtools merge -c 1 -o count > merged.del.bed

bedtools sort -i cat.ins.bed | bedtools merge -c 1 -d 100 -o count > merged.ins.bed

awk '$4>=2{print}' merged.del.bed > consensus2.del.bed
awk '$4>=3{print}' merged.del.bed > consensus3.del.bed
awk '$4>=4{print}' merged.del.bed > consensus4.del.bed
awk '$4>=5{print}' merged.del.bed > consensus5.del.bed
awk '$4>=6{print}' merged.del.bed > consensus6.del.bed
awk '$4>=7{print}' merged.del.bed > consensus7.del.bed

awk '$4>=2{print}' merged.ins.bed > consensus2.ins.bed
awk '$4>=3{print}' merged.ins.bed > consensus3.ins.bed
awk '$4>=4{print}' merged.ins.bed > consensus4.ins.bed
awk '$4>=5{print}' merged.ins.bed > consensus5.ins.bed
awk '$4>=6{print}' merged.ins.bed > consensus6.ins.bed
awk '$4>=7{print}' merged.ins.bed > consensus7.ins.bed
