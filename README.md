Nugen Barcode Splitter for Illumina
===================================

This gem is designed to demultiplex paired end reads produced by Illumina with [Nugen](http://www.nugeninc.com/nugen/) barcodes. It is using [FASTX Barcode Splitter](http://hannonlab.cshl.edu/fastx_toolkit/commandline.html#fastx_barcode_splitter_usage) from the [FASTX-Toolkit](http://hannonlab.cshl.edu/fastx_toolkit/index.html) for the barcode splitting.

Usage
-----

<code>
      nugen_barcode_splitter [options] -p project_dir -o out_dir -c sample_sheet_nugen

</code>


Example sample_sheet_nugen.csv :

FCID,Lane,SampleID,SampleRef,Index,Description,Control,Recipe,Operator,SampleProject
C0ED3ACXX,4,S1,hg19,ACCC,RNA Seq,N,,,33333
C0ED3ACXX,4,S2,hg19,GAGT,RNA Seq,N,,,44444
C0ED3ACXX,4,S3,hg19,CGTA,RNA Seq,N,,,33333
C0ED3ACXX,4,S4,hg19,TTAG,RNA Seq,N,,,44444
C0ED3ACXX,5,S5,hg19,AGGG,RNA Seq,N,,,33333
C0ED3ACXX,5,S6,hg19,GTCA,RNA Seq,N,,,44444
C0ED3ACXX,6,S7,hg19,CCAT,RNA Seq,N,,,33333

Note: The sample names must be alphanumerical!

<code>
    -p, --project_dir                Illumina project directory (../Unaligned/ProjectXXX/)
    -o, --out_dir                    The desired output directory
    -s, --sample_sheet               Please provide your sample_sheet
    -e, --end_of_line                Limit the search for the barcode to the end of the line DEFAULT:false
    -b, --begin_of_line              Limit the search for the barcode to the start of the line DEFAULT:false
    -k, --keep_barcode               Do not trim of the barcode DEFAULT:false
    -m, --mismatches NUM             Number of mismatches (Default:1)
    -x, --fastq_multx DIR
    -d, --debug                      Debug mode!
    -h, --help                       Show this message

</code>

The classes
-----------

### Merger

Since this gem is for pairend reads, the results of the FASTX Barcode splitter. The Nugen barcode can be found on the forward read at the beginning of each line (5' end).

### Fastq

This class makes sure the given file is in fastq format, when it is initialized. The method <code> add </code> enlarges the read by a given number of *N*'s (base) and it also adds the lowest score of quality *@* to the quality line accordingly.

### NugenTemplate

This class delivers the templates for the different <code>fastx_barcode_splitter.pl</code> runs.

### SampleSheet

A class SampleSheet consists of sample_id's, barcodes and lanes. It also creates barcode.txt files for the fastq_multx part.

### Statistics

Statistics combines the log output into one statistic.

