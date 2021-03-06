require "zlib"

class Merger
  def initialize(fwd,rev,outdir,number,barcodes)
    # get sampleID
    @sample_ids = []
    i = 0
    File.open(barcodes).each do |line|
      next if line.include?("#")
      line = line.split(" ")
      @sample_ids[i] = line[0]
      i += 1
    end
    @fwd = fwd
    @rev = rev
    @outdir = outdir
    @number = number
  end

  attr_accessor :sample_ids

  def merge()
    statistics = Array.new(@sample_ids.length()+2,0)
    fwd_file = Zlib::GzipReader.open(@fwd)
    rev_file = Zlib::GzipReader.open(@rev)
    fwd_splitted_files = []
    fwd_out_files = []
    rev_out_files = []
    fwd_out_unmatched = File.open(@outdir+"/R1_#{@number}.unmatched.updated.fq",'w')
    rev_out_unmatched = File.open(@outdir+"/R2_#{@number}.unmatched.updated.fq",'w')

    @sample_ids.each_with_index do |sample_id, i|
      fwd_splitted_files[i] = File.open(@outdir+"/R1_#{@number}.#{sample_id}.fq")
      fwd_out_files[i] = File.open(@outdir+"/R1_#{@number}.#{sample_id}.updated.fq",'w')
      rev_out_files[i] = File.open(@outdir+"/R2_#{@number}.#{sample_id}.updated.fq",'w')
    end

    fwd_file.each do |fwd_line|
      statistics[-1] += 1
      rev_line = rev_file.readline()
      rev_name = rev_line.split(" ")
      fwd_name = fwd_line.split(" ")
      marker = true

      @sample_ids.each_with_index do |sample_id, i|
        if !fwd_splitted_files[i].eof? && marker
          compare_line_fwd = fwd_splitted_files[i].readline()
          name_compare_fwd = compare_line_fwd.split(" ")
          if fwd_name[0] == name_compare_fwd[0]
            marker = false
            statistics[i] += 1
            fwd_out_files[i].write(fwd_line)
            rev_out_files[i].write(rev_line)
            for k in 1..3
              fwd_file.readline()
              compare_line_fwd = fwd_splitted_files[i].readline()
              fwd_out_files[i].write(compare_line_fwd.gsub(/^[A-Z]{4}/,"NNNN")) if k == 1
              fwd_out_files[i].write(compare_line_fwd) if k == 2
              fwd_out_files[i].write(compare_line_fwd.gsub(/^[\S]{4}/,"@@@@")) if k == 3
              rev_out_files[i].write(rev_file.readline())
            end
            fwd_file.lineno = fwd_file.lineno - 1
            rev_file.lineno = rev_file.lineno - 1
          else
            fwd_splitted_files[i].pos = fwd_splitted_files[i].pos - compare_line_fwd.length()
          end
        end
      end

      if marker
        statistics[-2] += 1
        fwd_out_unmatched.write(fwd_line)
        rev_out_unmatched.write(rev_line)
        for k in 1..3
          rev_out_unmatched.write(rev_file.readline())
          fwd_out_unmatched.write(fwd_file.readline())
        end
      end
    end
    stats = make_stats(statistics)
  end

  def make_stats(statistics)
    stats = ""
    @sample_ids.each_with_index do |id,i|
      stats += id +"\t" + statistics[i].to_s + "\n"
    end
    stats += "unmatched\t" + statistics[-2].to_s + "\n"
    stats += "total\t" + statistics[-1].to_s + "\n"
  end
end




