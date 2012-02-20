require "erubis"

class NugenTemplate

  def initialize(fastq_multx, options)
    @template =<<EOF
#{fastq_multx} #{options} <%= @barcodes %> \\
  <(gunzip -c <%= @fwd %>) \\
  <(gunzip -c <%= @rev %>) \\
  -o <%= @lane_dir %>/<%= @r1 %>.%.fq <%= @lane_dir %>/<%= @r2 %>.%.fq \\
  >> <%= @lane_dir %>/nugen_demultiplexing.log
EOF
  end

  def fill(lane, number, lane_dir, barcodes, fwd, rev)

    context = {
      :lane => lane,
      :number => number,
      :lane_dir => lane_dir,
      :barcodes => barcodes,
      :fwd => fwd,
      :rev => rev,
      :r1 => "R1_#{number}",
      :r2 => "R2_#{number}"
    }

    eruby = Erubis::Eruby.new(@template)
    eruby.evaluate(context)
  end

  def to_s
    template = "#{@template.chomp()}"
  end

end