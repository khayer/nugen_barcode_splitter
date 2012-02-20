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
    assert_equal(temp.to_s, "fastq-multx  bc \\\n  <(gunzip -c fwd) \\\n  <(gunzip -c rev) \\\n  -o ~/Lane3//R1_33.%.fq ~/Lane3//R2_33.%.fq \\\n  >> ~/Lane3//nugen_demultiplexing.log\n")
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
    out_file = "test/fixtures/added.fq"
    fastq.add(4, out_file )
    assert(!File.zero?(out_file), "#{out_file} is empty!")
    test = File.open(out_file,'r')
    line = test.readlines[1]
    test.pos = 0
    assert(line.start_with?("NNNN"), "Reads do not start with NNNN")
    line = test.readlines[3]
    assert(line.start_with?("@@@@"), "Reads do not start with @@@@")
    File.delete(out_file)
  end

  def test_sample_sheet
    samplesheet = SampleSheet.new("test/fixtures/sample_sheet.csv")
    assert_equal(samplesheet.barcodes[3], "TTAG")
    assert_equal(samplesheet.sample_id[4], "RX3")

    samplesheet.create_barcode_txt("test/fixtures/barcode")

  end

  def test_statistics
    log_file = "test/fixtures/Lane4.log"
    stats = Statistics.new(log_file)
    assert_equal(stats.total, 31920000)
    assert_equal(stats.num_reads[0], 8533927)
    assert_equal(stats.num_unmatched, 2614681)
  end
end