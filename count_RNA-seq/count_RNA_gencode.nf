params.gene_annotation = '/apps/data/ftp.sanger.ac.uk/pub/gencode/Gencode_human/release_25/GRCh37_mapping/gencode.v25lift37.annotation.gtf'
bam_files = Channel.fromPath('bam/*.bam')
GTF = file(params.gene_annotation)

process count_reads {
  module 'Subread'
  executor 'slurm'
  memory '20 GB'
  cpus 5
  time '10 h'
  publishDir 'out', mode: 'copy'
  input:
    file bampaths from bam_files.toSortedList()
    file GTF
  output:
    file "gene_counts.txt" into rnaCounts
  """
  featureCounts -T ${task.cpus} -s 1 -t exon -g gene_id -a "$GTF" \
    -o gene_counts.txt $bampaths
  """
}

