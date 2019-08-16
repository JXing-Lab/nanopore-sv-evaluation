This is a singularity container that includes all the pipelines and the random forest classifier. The container can be accessed at https://github.com/JXing-Lab/nanopore-sv-evaluation/releases/tag/1.0

The nanosv_bed is only required by the NanoSV caller.

#### Usage:
```
Pipelines:
singularity run --bind <PATH:PATH> nanopore-pipeline.sif [pipeline] [fastq] [reference] [output_dir] [threads] [nanosv_bed]
Possible pipelines:
	minimap2-sniffles
	minimap2-nanosv
	ngmlr-sniffles
	ngmlr-nanosv
	graphmap-sniffles
	graphmap-nanosv
	last-picky

Classifier:
singularity run --bind <PATH:PATH> nanopore-pipeline.sif train [model] [SV_type] [trueset_ins] [trueset_del] [vcf...]
singularity run --bind <PATH:PATH> nanopore-pipeline.sif predict [model] [SV_type] [output] [vcf...]
Description:
	model: The output file of the trained model
	SV_type: Type of the SV to include in the analysis: INS, DEL, or BOTH
	trueset_ins: The insertion trueset, in BED format
	trueset_del: The deletion trueset, in BED format
	output: File name of the ouput result
	vcf: Multiple VCF file as input
```

#### Example:

##### Pipeline:
```
singularity run -B /nfs:/nfs nanopore-pipeline.sif graphmap-nanosv reads.fastq ref.fna graphmap-nanosv 16 human_b38.bed
```

##### Training:
```
singularity run -B /nfs:/nfs nanopore-pipeline.sif predict my_model.joblib INS prediction.txt chm13/minimap2-nanosv/nanosv.vcf chm13/graphmap-nanosv/nanosv.vcf
```

##### Predicting:
```
singularity run -B /nfs:/nfs nanopore-pipeline.sif train my_model.joblib INS chm13/ngmlr-nanosv/nanosv.vcf
```

##### To run programs with custom options:
```
singularity exec -B /nfs:/nfs nanopore-pipeline.sif minimap2 ...
```
