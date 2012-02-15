require "erubis"

class Nugen_Template

  def initialize(fastq_multx)
    context = {
      :fastq_multx => fastq_multx
    }

    nugen_template =<<EOF

    #!/bin/bash
    #\$ -pe DJ 4
    #\$ -l h_vmem=6G
    #\$ -j y
    #\$ -N fq.<%= @lane %>
    #\$ -o <%= @lane %>/nugen_demultiplexing.log

    <%= @fastq_multx %> -B <%= @barcodes %> \\
      <%= @fwd %> <%= @rev %> \\
      -o <%= @r1 %>.%.fq <%= @r2 %>.%.fq

EOF

    eruby = Erubis::Eruby.new(nugen_template)
    eruby.evalute(context)
  end

  def fill_template(dirs)

  end

end