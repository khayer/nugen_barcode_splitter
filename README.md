Nugen Barcode Splitter for Illumina
===================================

This gem is designed to demultiplex reads produced by Illumina with [Nugen](http://www.nugeninc.com/nugen/) barcodes. It is using [fastq_multx](http://code.google.com/p/ea-utils/wiki/FastqMultx) for the barcode splitting.

The classes
-----------

# Fastq

This class makes sure the given file is in fastq format, when it is initialized. The method <code> add </code> enlarges the read by a given number of *N*'s (base) and it also adds the lowest score of quality *@* to the quality line accordingly.

# Nugen Template

This class delivers the templates for the different fastq_multx runs.

