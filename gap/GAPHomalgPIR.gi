#############################################################################
##
##  GAPHomalgPIR.gi           RingsForHomalg package         Mohamed Barakat
##
##  Copyright 2007-2008 Lehrstuhl B für Mathematik, RWTH Aachen
##
##  Implementations for the external rings provided by the GAP package homalg.
##
#############################################################################

####################################
#
# constructor functions and methods:
#
####################################

InstallMethod( CreateHomalgTable,
        "for rings provided by the gap package homalg",
        [ IsHomalgExternalRingObjectInGAPRep
          and IsPrincipalIdealRing ],
        
  function( ext_ring_obj )
    local RP, RP_Basic, RP_BestBasis, RP_specific, component;
    
    RP := ShallowCopy( CommonHomalgTableForGAPHomalgTools );
    
    RP_Basic := ShallowCopy( CommonHomalgTableForGAPHomalgBasic );
    
    RP_BestBasis := ShallowCopy( CommonHomalgTableForGAPHomalgBestBasis );
    
    RP_specific :=
          rec(
               ## Can optionally be provided by the RingPackage
               ## (homalg functions check if these functions are defined or not)
               ## (homalgTable gives no default value)
               
               ElementaryDivisors :=
                 function( arg )
                   local M, R;
                   
                   M:=arg[1];
                   
                   R := HomalgRing( M );
                   
                   return homalgSendBlocking( [ "ElementaryDivisors(", M, ")" ], "need_output", HOMALG_IO.Pictograms.ElementaryDivisors );
                   
                 end,
               
               RowRankOfMatrixOverDomain :=
                 function( M )
                     
                     return Int( homalgSendBlocking( [ "RowRankOfMatrix(", M, ")" ], "need_output" ) );
                     
                 end,
               
               ## Must be defined if other functions are not defined
               
               TriangularBasisOfRows :=
                 function( arg )
                   local M, R, nargs, N, U;
                   
                   M := arg[1];
                   
                   R := HomalgRing( M );
                   
                   nargs := Length( arg );
                   
                   N := HomalgVoidMatrix( "unknown_number_of_rows", NrColumns( M ), R );
                   
                   if nargs > 1 and IsHomalgMatrix( arg[2] ) then ## not TriangularBasisOfRows( M, "" )
                       # assign U:
                       U := arg[2];
                       SetNrRows( U, NrRows( M ) );
                       SetNrColumns( U, NrRows( M ) );
                       SetIsInvertibleMatrix( U, true );
                       
                       ## compute N and U:
                       homalgSendBlocking( [ U, ":=HomalgVoidMatrix(", R, ");;", N, ":=TriangularBasisOfRows(", M, U, ")" ], "need_command", HOMALG_IO.Pictograms.TriangularBasisC );
                   else
                       ## compute N only:
                       homalgSendBlocking( [ N, ":=TriangularBasisOfRows(", M, ")" ], "need_command", HOMALG_IO.Pictograms.TriangularBasis );
                   fi;
                   
                   SetIsUpperTriangularMatrix( N, true );
                   
                   return N;
                   
                 end
               
          );
    
    if homalgSendBlocking( [ "IsBound(homalgTable(", ext_ring_obj, ")!.BestBasis)" ], "need_output", HOMALG_IO.Pictograms.initialize ) = "true" then
        for component in NamesOfComponents( RP_BestBasis ) do
            RP.(component) := RP_BestBasis.(component);
        od;
    fi;
    
    for component in NamesOfComponents( RP_Basic ) do
        RP.(component) := RP_Basic.(component);
    od;
    
    for component in NamesOfComponents( RP_specific ) do
        RP.(component) := RP_specific.(component);
    od;
    
    Objectify( TheTypeHomalgTable, RP );
    
    return RP;
    
end );
