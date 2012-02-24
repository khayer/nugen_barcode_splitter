require 'test/unit'
require 'nugen_barcode_splitter'

class NugenBarcodeSplitterTest < Test::Unit::TestCase
  def setup

  end

  def test_nugen_template
    template = NugenTemplate.new("fastq-multx", "")
    assert template.to_s.include?("fastq-multx")
    assert template.to_s.include?("<%= @read %>")
    temp = template.fill("Lane_3", "33", "~/Lane3/", "bc", "fwd", true)
    assert_equal(temp.to_s, "gunzip -c fwd | fastq-multx \\\n  --bcfile bc  --bol \\\n  --prefix ~/Lane3//R1_33. \\\n  --suffix \".fq\"\n")
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

  def test_merger
    merger = Merger.new("test/fixtures/Sample_Lane8/Lane8_NoIndex_L008_R1_019.fastq.gz",
      "test/fixtures/Sample_Lane8/Lane8_NoIndex_L008_R2_019.fastq.gz",
      "test/fixtures/Sample_Lane8", "019", "test/fixtures/barcode_8.txt")
    assert_equal(["RX9", "RX10", "RX9X2", "RX10X2"], merger.sample_ids)
    stats = merger.merge()
    assert_equal("RX9\t22464\nRX10\t28699\nRX9X2\t26434\nRX10X2\t22994\nunmatched\t15445\ntotal\t116036\n",stats)
  end
end