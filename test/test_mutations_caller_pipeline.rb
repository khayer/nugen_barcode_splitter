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

  def test_fastq
    fastq_file = "test/fixtures/invalid.fq"
    assert_raise RuntimeError do
      Fastq.new(fastq_file)
    end
    fastq_file = "test/fixtures/test.fq"
    assert_nothing_raised do
      fastq = Fastq.new(fastq_file)
    end
    fastq = Fastq.new(fastq_file)
    fastq.add(4, "test/fixtures/test_added_ns.fq")
  end

  def test_samplesheet
    samplesheet = SampleSheet.new("test/fixtures/sample_sheet.csv")
    assert_equal(samplesheet.barcodes[3], "TTAG")
  end

  def test_create_location_file

  end
end