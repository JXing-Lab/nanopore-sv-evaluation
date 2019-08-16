# subsetting fasta reads
seqtk sample -s seed=11 simulated_reads.fasta 0.2 > simulated_reads_10x.fasta

# map using minimap2
/usr/bin/time -v minimap2 -ax map-ont -t 16 --MD ref.fna simulated_reads_10x.fastq | samtools sort -o mapped_10x.bam

# SV call using sniffles
sniffles -m mapped_10x.bam -v mapped_10x.vcf
