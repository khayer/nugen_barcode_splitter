class Fastq
  def initialize(filename)
    @filehandle = File.open(filename, "r")
    line = @filehandle.readline()
    raise RuntimeError, "Invalid fastq file!" if !line.include?("@")
    @filehandle.pos = 0
  end

  def add(num, outdir)
    bases = "N" * num
    outfile = File.open(outdir, 'w')
    while !@filehandle.eof?
      outfile.write(@filehandle.readline)
      outfile.write("#{bases}" + @filehandle.readline)
      outfile.write(@filehandle.readline)
      outfile.write("#{qualities}" + @filehandle.readline)
    end
  end
end