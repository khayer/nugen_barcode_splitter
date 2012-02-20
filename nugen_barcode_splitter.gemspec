# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
#require "nugen_barcode_splitter/version"

Gem::Specification.new do |s|
  s.name        = "nugen_barcode_splitter"
 # s.version     = NugenBarcodeSplitter::VERSION
  s.version     = "0.0.9"
  s.date        = "2012-02-15"
  s.authors     = ["Katharina Hayer"]
  s.email       = ["katharinaehayer@gmail.com"]
  s.homepage    = "https://github.com/khayer/nugen_barcode_splitter"
  s.summary     = %q{Nugen Barcode Splitter for Illumina}
  s.description = %q{This gem is designed to demultiplex reads
                     produced by Illumina with Nugen
                     (http://www.nugeninc.com/nugen/) barcodes.}

  s.rubyforge_project = "nugen_barcode_splitter"

  s.files         = `git ls-files -- {lib,bin}/*`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
