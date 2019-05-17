# Coverage

## Subsetting
```
seqtk sample -s seed=11 simulated_reads.fasta 0.2 > simulated_reads_10x.fasta

/usr/bin/time -v minimap2 -ax map-ont -t 16 --MD /nfs/XingLab_ISI/Nanopore/Evaluation/Reference/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna /nfs/XingLab_ISI/Nanopore/Coverage/rel3-nanopore-wgs_10x.fastq | samtools sort -o rel3-nanopore-wgs_10x.bam

sniffles -m rel3-nanopore-wgs_10x.bam -v rel3-nanopore-wgs_10x.vcf
```