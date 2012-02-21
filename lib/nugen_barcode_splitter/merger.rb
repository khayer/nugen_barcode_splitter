require "zlib"

class Merger
  def initialize(fwd,rev,outdir,number,barcodes)
    # get sampleID
    @values_fwd = []
    @values_rev = []
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

  attr_accessor :sample_ids, :values_fwd, :values_rev

  #def prepare_hash()
  #  @sample_ids.each_with_index do |sample_id, i|
  #    a = Thread.new {
  #      filehandler = File.open(@outdir+"/R1_#{@number}.#{sample_id}.fq")
  #      filehandler.each do |line|
  #        next unless line.include?("@HWI-")
  #        line = line.split(" ")
  #        name = line[0].split(":")[4..-1].join(":")
  #        @values_fwd[i].store(name,filehandler.pos)
  #      end
  #      filehandler.close()
  #    }
  #    b = Thread.new {
  #      filehandler = File.open(@outdir+"/R2_#{@number}.#{sample_id}.fq")
  #      filehandler.each do |line|
  #        next unless line.include?("@HWI-")
  #        line = line.split(" ")
  #        name = line[0].split(":")[4..-1].join(":")
  #        @values_rev[i].store(name,filehandler.pos)
  #      end
  #      filehandler.close()
  #    }
  #    a.join
  #    b.join
  #  end
  #end

  def merge()
    fwd_file = Zlib::GzipReader.open(@fwd)
    rev_file = Zlib::GzipReader.open(@rev)
    fwd_splitted_files = []
    rev_splitted_files = []
    fwd_out_files = []
    rev_out_files = []
    fwd_out_unmatched = File.open(@outdir+"/R1_#{@number}.unmatched_updated.fq",'w')
    rev_out_unmatched = File.open(@outdir+"/R2_#{@number}.unmatched_updated.fq",'w')
    @sample_ids.each_with_index do |sample_id, i|
      fwd_splitted_files[i] = File.open(@outdir+"/R1_#{@number}.#{sample_id}.fq")
      rev_splitted_files[i] = File.open(@outdir+"/R2_#{@number}.#{sample_id}.fq")
      #OUTFILES????
      fwd_out_files[i] = File.open(@outdir+"/R1_#{@number}.#{sample_id}_updated.fq",'w')
      rev_out_files[i] = File.open(@outdir+"/R2_#{@number}.#{sample_id}_updated.fq",'w')
    end
    fwd_file.each do |fwd_line|
      rev_line = rev_file.readline()
      rev_name = rev_line.split(" ")
      fwd_name = fwd_line.split(" ")
      marker = true

      @sample_ids.each_with_index do |sample_id, i|
        if !fwd_splitted_files[i].eof?
          compare_line_fwd = fwd_splitted_files[i].readline().split(" ")
          if fwd_line[0] == compare_line_fwd[0] && marker
            marker = false
            fwd_out_files[i].write(fwd_line)
            rev_out_files[i].write(rev_line)
            for k in 1..3
              fwd_file.readline()
              rev_splitted_files[i].readline if marker2
              compare_line_fwd = fwd_splitted_files[i].readline()
              fwd_out_files[i].write("NNNN"+compare_line_fwd) if k == 1
              fwd_out_files[i].write(compare_line_fwd) if k == 2
              fwd_out_files[i].write("@@@@"+compare_line_fwd) if k == 3
              rev_out_files[i].write(rev_file.readline())
            end
          end
        end
        if !marker && !rev_splitted_files[i].eof?
          compare_line_rev = rev_splitted_files[i].readline().split(" ")
          if compare_line_rev[0] == compare_line_fwd[0]
            for k in 1..3
              rev_splitted_files[i].readline()
            end
          end
        end
        break if !marker
        if !rev_splitted_files[i].eof?
          compare_line_rev = rev_splitted_files[i].readline().split(" ")
          if rev_name[0] == compare_line_rev[0] && marker
            marker = false
            fwd_out_files[i].write(fwd_line)
            rev_out_files[i].write(rev_line)
            for k in 1..3
              rev_file.readline()
              compare_line_rev = rev_splitted_files[i].readline()
              rev_out_files[i].write("NNNN"+compare_line_rev) if k == 1
              rev_out_files[i].write(compare_line_rev) if k == 2
              rev_out_files[i].write("@@@@"+compare_line_rev) if k == 3
              fwd_out_files[i].write(fwd_file.readline())
            end
          end
        end
        break if !marker
      end

      if marker
        fwd_out_unmatched.write(fwd_line)
        rev_out_unmatched.write(rev_line)
        for k in 1..3
          rev_out_unmatched.write(rev_file.readline())
          fwd_out_unmatched.write(fwd_file.readline())
        end
      end

    end


  end
end