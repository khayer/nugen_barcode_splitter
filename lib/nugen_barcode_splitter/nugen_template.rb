require "erubis"

class NugenTemplate

  def initialize(fastq_multx, options)
    @template =<<EOF
#{fastq_multx} #{options}  <%= @barcodes %> \\
  <(gunzip -c <%= @read %>) \\
  -o <%= @lane_dir %>/<%= @direction %>.%.fq  \\
  >> <%= @lane_dir %>/nugen_demultiplexing.log
EOF
  end

  def fill(lane, number, lane_dir, barcodes, read, is_fwd)
    if is_fwd
      direction = "R1_#{number}"
    else
      direction = "R2_#{number}"
    end
    context = {
      :lane => lane,
      :number => number,
      :lane_dir => lane_dir,
      :barcodes => barcodes,
      :read => read,
      :direction => direction
    }

    eruby = Erubis::Eruby.new(@template)
    eruby.evaluate(context)
  end

  def to_s
    template = "#{@template.chomp()}"
  end

end