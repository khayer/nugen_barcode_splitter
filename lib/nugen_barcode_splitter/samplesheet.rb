require "csv"

# Samplesheets are suppose to look like this
=begin
FCID,Lane,SampleID,SampleRef,Index,Description,Control,Recipe,Operator,SampleProject,
C0ED3ACXX,4,R-1,hg19,ACCC,RNA Seq,N,,,47644,Nugen barcodes
C0ED3ACXX,4,R-2,hg19,GAGT,RNA Seq,N,,,47644,Nugen barcodes
=end

class Samplesheet

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

end