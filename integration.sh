cat graphmap-nanosv/nanosv.chr.del.sort.merge.bed graphmap-sniffles/sniffles.chr.del.sort.merge.bed ngmlr-nanosv/nanosv.chr.del.sort.merge.bed ngmlr-sniffles/sniffles.chr.del.sort.merge.bed minimap2-nanosv/nanosv.chr.del.sort.merge.bed minimap2-sniffles/sniffles.chr.del.sort.merge.bed last-picky/picky.allsv.chr.del.sort.merge.bed > cat.del.bed

cat graphmap-nanosv/nanosv.chr.ins.bp.sort.merge.bed graphmap-sniffles/sniffles.chr.ins.bp.sort.merge.bed ngmlr-nanosv/nanosv.chr.ins.bp.sort.merge.bed ngmlr-sniffles/sniffles.chr.ins.bp.sort.merge.bed minimap2-nanosv/nanosv.chr.ins.bp.sort.merge.bed minimap2-sniffles/sniffles.chr.ins.bp.sort.merge.bed last-picky/picky.allsv.chr.ins.bp.sort.merge.bed > cat.ins.bed

bedtools sort -i cat.del.bed | bedtools merge -c 1 -o count > merged.del.bed

awk '$4>=2{print}' merged.del.bed > consensus2.del.bed
