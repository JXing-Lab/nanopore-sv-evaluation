# graphmap
/usr/bin/time -v graphmap align -t 16 -r ref.fna -d reads.fasta -o graphmap.sam

# last
/usr/bin/time -v lastal -C2 -K2 -r1 -q3 -a2 -b1 -v -v -P16 -Q1 ref.last reads.fastq 2>last.lastal.log | picky.pl selectRep --thread 16 --preload 6 1>last.align 2>last.selectRep.log

# ngmlr
/usr/bin/time -v /home/azhou/Tools/ngmlr-0.2.6/ngmlr -t 16 -r ref.fna -q reads.fasta -o ngmlr.sam -x ont

# minimap2
/usr/bin/time -v minimap2 -ax map-ont -t 16 --MD ref.fna reads.fasta > minimap2.sam

# nanosv
source activate nanosv
/usr/bin/time -v NanoSV -t 16 -b human_b38.bed -s samtools -o nanosv.vcf ../graphmap.bam

# picky 
cat ../last.align | /usr/bin/time -v picky.pl callSV --oprefix picky --exclude=chrM
/home/azhou/Tools/Picky/src/picky.pl xls2vcf --re 10 --xls picky.profile.DEL.xls --xls picky.profile.INS.xls --xls picky.profile.CTLC.xls --xls picky.profile.INDEL.xls --xls picky.profile.INV.xls --xls picky.profile.TTLC.xls --xls picky.profile.TDSR.xls --xls picky.profile.TDC.xls > picky.allsv.vcf

# sniffles
/usr/bin/time -v sniffles -t 16 -m ../graphmap.bam -v sniffles.vcf
