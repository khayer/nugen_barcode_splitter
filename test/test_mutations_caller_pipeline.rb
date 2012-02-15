require 'test/unit'
require 'nugen_barcode_splitter'

class NugenBarcodeSplitterTest < Test::Unit::TestCase
  def setup

  end

  def test_nugen_template
    template = NugenTemplate.new("fastq-multx", "")
    assert template.to_s.include?("fastq-multx")
    assert template.to_s.include?("<%= @fwd %>")
    temp = template.fill("Lane_3", "33", "~/Lane3/", "bc", "fwd", "rev")
    assert_equal("\n    #!/bin/bash\n    \#$ -pe DJ 4\n    \#$ -l h_vmem=6G\n    \#$ -j y\n    \#$ -N fq.Lane_3.33\n    \#$ -o ~/Lane3//nugen_demultiplexing.log\n\n    fastq-multx  -B bc \\\n      fwd rev \\\n      -o R1_33.%.fq R2_33.%.fq\n\n","#{temp}")
  end

  def test_samtools_indexing

  end

  def test_gatk_caller
    #k = GatkCaller.call("haas", "~/Documents/GATK/dist/GenomeAnalysisTK.jar", "jsjs", "baba", "saa")
    #assert(!k)
  end

  def test_create_location_file

  end
end