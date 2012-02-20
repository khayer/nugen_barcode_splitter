require "csv"

# Samplesheets are suppose to look like this
=begin
FCID,Lane,SampleID,SampleRef,Index,Description,Control,Recipe,Operator,SampleProject,
C0ED3ACXX,4,R-1,hg19,ACCC,RNA Seq,N,,,47644,Nugen barcodes
C0ED3ACXX,4,R-2,hg19,GAGT,RNA Seq,N,,,47644,Nugen barcodes
=end

class SampleSheet

  def initialize(samplesheet)
    @lanes = []
    @sample_id = []
    @barcodes = []

    CSV.foreach(samplesheet, {:headers => :first_row}) do |row|
      @lanes << row["Lane"]
      @sample_id << row["SampleID"].gsub(/\W/,"X")
      @barcodes << row["Index"]
    end
  end

  attr_accessor :lanes, :sample_id, :barcodes, :barcode_lengths

  def create_barcode_txt(prefix)
    current_lane = "dummy"
    handler = File.new(prefix,'w')
    @lanes.each_with_index do |lane, i|
      if current_lane != lane
        outfile = "#{prefix}_#{lane}.txt"
        current_lane = lane
        handler.close()
        handler = File.new(outfile,'w')
        handler.write("# SampleName Barcode \n")
      end
      handler.write("#{@sample_id[i]} #{@barcodes[i]} \n")
    end
    handler.close()
    File.delete(prefix)
  end

end