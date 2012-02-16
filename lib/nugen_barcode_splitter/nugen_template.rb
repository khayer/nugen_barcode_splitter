require "erubis"

class NugenTemplate

  def initialize(fastq_multx, options)
    @template =<<EOF

    #!/bin/bash
    #\$ -pe DJ 4
    #\$ -l h_vmem=6G
    #\$ -j y
    #\$ -N fq.<%= @lane %>.<%= @number %>
    #\$ -o <%= @lane_dir %>/nugen_demultiplexing.log

    #{fastq_multx} #{options} -B <%= @barcodes %> \\
      <%= @fwd %> <%= @rev %> \\
      -o <%= @r1 %>.%.fq <%= @r2 %>.%.fq



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