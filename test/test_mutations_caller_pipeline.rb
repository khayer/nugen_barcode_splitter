require 'test/unit'
require 'nugen_barcode_splitter'

class NugenBarcodeSplitterTest < Test::Unit::TestCase
  def test_hi
    puts "HAHA"
    assert_equal  "Hello World!", NugenBarcodeSplitter.hi()
    #File.delete("haas")
  end

  def test_bwa_caller
    #k = BwaCaller.call_paired_end("r1", "r2", "out_file", "index", "haas", "bwa", "samtools")
    #assert(k)
    #assert(File.exist?("haas"))
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