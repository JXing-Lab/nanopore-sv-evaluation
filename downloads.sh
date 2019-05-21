# download md5 and file names for NA12878
wget https://raw.githubusercontent.com/nanopore-wgs-consortium/NA12878/master/nanopore-human-genome/rel3-md5s.txt

# create and execute download cmds
awk '{print("wget http://s3.amazonaws.com/nanopore-human-wgs/"$2)}' rel3-md5s.txt > download.sh
bash download.sh

# concatenate fastq
cat *.fastq > cat.fastq

# download SV calls for NA12878
wget ftp://ftp-trace.ncbi.nlm.nih.gov/giab/ftp/data/NA12878/NA12878_PacBio_MtSinai/NA12878.sorted.vcf.gz
wget ftp://ftp-trace.ncbi.nlm.nih.gov/giab/ftp/data/NA12878/NA12878_PacBio_MtSinai/NA12878.sorted.vcf.gz.tbi

# download SV calls for CHM1
wget http://eichlerlab.gs.washington.edu/publications/chm1-structural-variation/data/GRCh37/insertions.bed
wget http://eichlerlab.gs.washington.edu/publications/chm1-structural-variation/data/GRCh37/deletions.bed
