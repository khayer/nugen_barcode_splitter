require 'csv'
class Statistics

  def initialize(lane_log)
    # getting barcodes:
    i = 0
    @barcodes = []
    File.open(lane_log).each do |line|
      next if line.include?("Id")
      next if line.empty?
      break if line.include?("unmatched")
      line = line.split("\t")
      barcodes[i] = line[0]
      i += 1
    end

    @num_reads = Array.new(barcodes.length(),0)
    @num_unmatched = 0
    @total = 0
    @barcodes = barcodes
    File.open(lane_log).each do |line|
      next if line.include?("Id")
      next if line.empty?
      line = line.split("\t")
      case line[0]
      when "unmatched"
        @num_unmatched += line[1].to_i
      when "total"
        @total += line[1].to_i
      else
        if i = @barcodes.index(line[0])
          @num_reads[i]+= line[1].to_i
        end
      end
    end
  end

  attr_accessor :num_reads, :num_unmatched, :total, :barcodes

  def to_s
    str = "Statistics: \nBarcode\t# of reads\n"
    @barcodes.each_with_index do |code, i|
      str += "#{code}:\t#{@num_reads[i]} \n"
    end
    #percent = (100 / @total.to_f) * @num_unmatched.to_f
    #percent = (percent.to_f * 100).round / 100.to_f
    str += "Unmatched:\t#{@num_unmatched}\n"
    str += "Total:\t#{@total}"
    str.to_s
  end
end