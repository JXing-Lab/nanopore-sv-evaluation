awk '{print $0"\t"FILENAME}' graphmap-nanosv/nanosv.chr.del.sort.merge.bed graphmap-sniffles/sniffles.chr.del.sort.merge.bed ngmlr-nanosv/nanosv.chr.del.sort.merge.bed ngmlr-sniffles/sniffles.chr.del.sort.merge.bed minimap2-nanosv/nanosv.chr.del.sort.merge.bed minimap2-sniffles/sniffles.chr.del.sort.merge.bed last-picky/picky.allsv.chr.del.sort.merge.bed > cat.del.bed

awk '{print $0"\t"FILENAME}' graphmap-nanosv/nanosv.chr.ins.bp.sort.merge.bed graphmap-sniffles/sniffles.chr.ins.bp.sort.merge.bed ngmlr-nanosv/nanosv.chr.ins.bp.sort.merge.bed ngmlr-sniffles/sniffles.chr.ins.bp.sort.merge.bed minimap2-nanosv/nanosv.chr.ins.bp.sort.merge.bed minimap2-sniffles/sniffles.chr.ins.bp.sort.merge.bed last-picky/picky.allsv.chr.ins.bp.sort.merge.bed > cat.ins.bed

bedtools sort -i cat.del.bed | bedtools merge -c 5 -o count_distinct > integrated.del.bed

bedtools sort -i cat.ins.bed | bedtools merge -d 100 -c 5 -o count_distinct > integrated.ins.bed

for i in `seq 2 7`; do awk '$4>=i{print}' i=$i integrated.ins.bed > let$i.ins.bed; done

for i in `seq 2 7`; do awk '$4>=i{print}' i=$i integrated.del.bed > let$i.del.bed; done
