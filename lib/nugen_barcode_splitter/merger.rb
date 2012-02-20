require "zlib"

class Merger
  def initialize(fwd,rev,outdir,number,barcodes)
    # get sampleID
    @sample_ids = []
    i = 0
    File.open(barcodes).each_with_index do |line, i|
      line = line.split(" ")
      @sample_ids[i] = line[0]
      @sample_ids[i] = "unmatched" if line.include?("#")
      i += 1
    end
    @fwd = fwd
    @rev = rev
    @outdir = outdir
    @number = number
  end

  attr_accessor :sample_ids

  def merge()
    fwd_file = File.open(@fwd)
    rev_file = File.open(@rev)
    fwd_splitted_files = []
    rev_splitted_files = []
    @sample_ids.each_with_index do |sample_id, i|
      fwd_splitted_files[i] = File.open(@outdir+"/R1_#{number}.#{sample_id}.fq")
      rev_splitted_files[i] = File.open(@outdir+"/R1_#{number}.#{sample_id}.fq")
      #OUTFILES????
    end
    fwd_file.each do |fwd_line|
      rev_line = rev_file.readline()

    end


  end
end