##  this creates the documentation, needs: GAPDoc package, latex, pdflatex,
##  mkindex, dvips
##  
##  Call this with GAP.
##

LoadPackage( "GAPDoc" );

SetGapDocLaTeXOptions( "utf8" );

bib := ParseBibFiles( "doc/ExamplesForHomalg.bib" );
WriteBibXMLextFile( "doc/ExamplesForHomalgBib.xml", bib );

list := [
         "../gap/ExamplesForHomalg.gd",
         "../gap/ExamplesForHomalg.gi",
         "../examples/Schenck-3.2.g",
         "../examples/Schenck-8.3.g",
         "../examples/Schenck-8.3.3.g",
         "../examples/DE-2.2.g",
         "../examples/DE-Code.g",
         ];

MakeGAPDocDoc( "doc", "ExamplesForHomalg", list, "ExamplesForHomalg" );

GAPDocManualLab("ExamplesForHomalg");

quit;

