require "zlib"

module MyOperations
  def merge(fwd,rev,outdir,number,barcodes)
    # get sampleID
    sample_ids = []
    File.open(barcodes).each_with_index do |line, i|
      line = line.split(" ")
      sample_ids[i] = line[0]
    end

    #rev_file = File.open(rev)
    #File.open(fwd).each do |line_fwd|
    #  line_rev = rev_file.readline()
#
    #end
  end
end