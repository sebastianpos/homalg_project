#############################################################################
##
##  MapleHomalg.gi              homalg package               Mohamed Barakat
##
##  Copyright 2007-2008 Lehrstuhl B für Mathematik, RWTH Aachen
##
##  The rings available through the Maple implementation of homalg
##
#############################################################################

####################################
#
# constructor functions and methods:
#
####################################

InstallMethod( CreateHomalgTable,
               "for maple homalg rings",
               [ IsHomalgExternalObjectRep and IsHomalgExternalObjectWithIOStream and IsHomalgMapleRing ],

  function( arg )
    local RP;

    RP := rec( 
               ## Can optionally be provided by the RingPackage
               ## (homalg functions check if these functions are defined or not)
               ## (HomalgTable gives no default value)
               
               BestBasis :=
                 function( arg )
                   local M, R, nargs, S, rank_of_S, U, V;
                   
                   M := arg[1];
                   
                   R := HomalgRing( M );
                   
                   nargs := Length( arg );
                   
                   if nargs > 1 then
                       ## compute S, U and (if nargs > 2) V: S = U*M*V
                       HomalgSendBlocking( [ "_S,_U,_V =", M, ".dense_matrix().smith_form()" ], "need_command" );
                       HomalgSendBlocking( [ "left_matrix=matrix(ZZ,", NrRows( M ), ",sparse=true)" ], "need_command", R );
                       HomalgSendBlocking( [ "for i in range(", NrRows( M ), "):\n  left_matrix[i,", NrRows( M ) - 1, "-i]=1\n\n" ], "need_command", R );
                       HomalgSendBlocking( [ "right_matrix=matrix(ZZ,", NrColumns( M ), ",sparse=true)" ], "need_command", R );
                       HomalgSendBlocking( [ "for i in range(", NrColumns( M ), "):\n  right_matrix[i,", NrColumns( M ) - 1, "-i]=1\n\n" ], "need_command", R );
                       rank_of_S := Int( HomalgSendBlocking( [ "_S.rank()" ], "need_output", R ) );
                       S := HomalgSendBlocking( [ "left_matrix*_S.sparse_matrix()*right_matrix" ], R );
                       U := HomalgSendBlocking( [ "left_matrix*_U.sparse_matrix()" ], R );
                       if nargs > 2 then V := HomalgSendBlocking( [ "_V.sparse_matrix()*right_matrix" ], R ); fi;
                   else
                       ## compute S only:
                       HomalgSendBlocking( [ "elemdivlist=", M, ".elementary_divisors()" ], "need_command" );
                       HomalgSendBlocking( [ "TempMat=matrix(ZZ,", NrRows(M), ",", NrColumns(M), ",sparse=true)" ], "need_command", R );
                       HomalgSendBlocking( [ "for i in range(len(elemdivlist)):\n  TempMat[i,i]=elemdivlist[i]\n\n" ], "need_command", R );
                       rank_of_S := Int( HomalgSendBlocking( [ "TempMat.rank()" ], "need_output", R ) );
                       S := HomalgSendBlocking( [ "TempMat" ], R );
                   fi;
                   
                   # assign U:
                   if nargs > 1 and IsHomalgMatrix( arg[2] ) then ## not BestBasis( M, "", V )
                       SetEval( arg[2], U );
                       SetNrRows( arg[2], NrRows( M ) );
                       SetNrColumns( arg[2], NrRows( M ) );
                       SetIsFullRowRankMatrix( arg[2], true );
                       SetIsFullColumnRankMatrix( arg[2], true );
                   fi;
                   
                   # assign V:
                   if nargs > 2 and IsHomalgMatrix( arg[3] ) then ## not BestBasis( M, U, "" )
                       SetEval( arg[3], V );
                       SetNrRows( arg[3], NrColumns( M ) );
                       SetNrColumns( arg[3], NrColumns( M ) );
                       SetIsFullRowRankMatrix( arg[3], true );
                       SetIsFullColumnRankMatrix( arg[3], true );
                   fi;
                   
                   S := HomalgMatrix( S, R );
                   
                   SetNrRows( S, NrRows( M ) );
                   SetNrColumns( S, NrColumns( M ) );
                   SetRowRankOfMatrix( S, rank_of_S );
                   SetIsDiagonalMatrix( S, true );
                   
                   return S;
                   
                 end,
               
               ElementaryDivisors :=
                 function( arg )
                   local M;
                   
                   M:=arg[1];
                   
                   return HomalgSendBlocking( [ M, ".elementary_divisors()" ] );
                   
                 end,
                 
               ## Must be defined if other functions are not defined
               
               TriangularBasisOfRows :=
                 function( arg )
                   local M, R, nargs, N, rank_of_N, U;
                   
                   M := arg[1];
                   
                   R := HomalgRing( M );
                   
                   nargs := Length( arg );
                   
                   if nargs > 1 then
                       ## compute N and U:
                       HomalgSendBlocking( [ "_N,_U = ", M, ".dense_matrix().echelon_form(transformation=True)" ], "need_command" );
                       HomalgSendBlocking( [ "_N = _N.sparse_matrix()" ], "need_command", R );
                       rank_of_N := Int( HomalgSendBlocking( [ "_N.rank()" ], "need_output", R ) );
                       N := HomalgSendBlocking( [ "_N" ], R );
                       U := HomalgSendBlocking( [ "_U.sparse_matrix()" ], R );
                       HomalgSendBlocking( [ "_N=0; _U=0;" ], "need_command", R );
                   else
                       ## compute N only:
                       HomalgSendBlocking( [ "_N = ", M, ".echelon_form()" ], "need_command" );
                       HomalgSendBlocking( [ "_N = _N.sparse_matrix()" ], "need_command", R );
                       rank_of_N := Int( HomalgSendBlocking( [ "_N.rank()" ], "need_output", R ) );
                       N := HomalgSendBlocking( [ "_N" ], R );
                       HomalgSendBlocking( [ "_N=0;" ], "need_command", R );
                   fi;
                   
                   # assign U:
                   if nargs > 1 and IsHomalgMatrix( arg[2] ) then ## not TriangularBasisOfRows( M, "" )
                       SetEval( arg[2], U );
                       SetNrRows( arg[2], NrRows( M ) );
                       SetNrColumns( arg[2], NrRows( M ) );
                       SetIsFullRowRankMatrix( arg[2], true );
                       SetIsFullColumnRankMatrix( arg[2], true );
                   fi;
                   
                   N := HomalgMatrix( N, R );
                   
                   SetNrRows( N, NrRows( M ) );
                   SetNrColumns( N, NrColumns( M ) );
                   SetRowRankOfMatrix( N, rank_of_N );
                   
                   if HasIsDiagonalMatrix( M ) and IsDiagonalMatrix( M ) then
                       SetIsDiagonalMatrix( N, true );
                   else
                       SetIsUpperTriangularMatrix( N, true );
                   fi;
                   
                   return N;
                   
                 end,
               
               ## Must only then be provided by the RingPackage in case the default
               ## "service" function does not match the Ring
                   
               True := "true",
               
               Zero := HomalgExternalObject( "0", "Maple" ),
               
               One := HomalgExternalObject( "1", "Maple" ),
               
               MinusOne := HomalgExternalObject( "(-1)", "Maple" ),
               
               Equal :=
                 function( A, B )
                 
                   return HomalgSendBlocking( [ A, "=", B ], "need_ouput" );
                 
                 end,
               
               ZeroMatrix :=
                 function( C )
                   local R;
                   
                   R := HomalgRing( C );
                   
                   return HomalgSendBlocking( [ "ZeroMap(", NrRows( C ), NrColumns( C ), R, "[1],", R, "[2])" ] );
                   
                 end,
             
               IdentityMatrix :=
                 function( C )
                   local R;
                   
                   R := HomalgRing( C );
                   
                   return HomalgSendBlocking( [ "IdentityMap(", NrRows( C ), R, "[1],", R, "[2])" ] );
                   
                 end,
               
               Involution :=
                 function( M )
                   local R;
                   
                   R := HomalgRing( M );
                   
                   return HomalgSendBlocking( [ "Involution(", M, R, "[1],", R, "[2])" ] );
                   
                 end,
               
               CertainRows :=
                 function( M, plist )
                   local R;
                   
                   R := HomalgRing( M );
                   
                   return HomalgSendBlocking( [ R, "[2][CertainRows](", M, plist, ")" ] );
                   
                 end,
               
               CertainColumns :=
                 function( M, plist )
                   local R;
                   
                   R := HomalgRing( M );
                   
                   return HomalgSendBlocking( [ R, "[2][CertainColumns](", M, plist, ")" ] );
                   
                 end,
               
               UnionOfRows :=
                 function( A, B )
                   local R;
                   
                   R := HomalgRing( A );
                   
                   return HomalgSendBlocking( [ R, "[2][matrix](", R, "[2][UnionOfRows](", A, B, "))" ] );
                   
                 end,
               
               UnionOfColumns :=
                 function( A, B )
                   local R;
                   
                   R := HomalgRing( A );
                   
                   return HomalgSendBlocking( [ R, "[2][matrix](", R, "[2][UnionOfColumns](", A, B, "))" ] );
                   
                 end,
               
               DiagMat :=
                 function( e )
                   local f;
                   
                   f := ShallowCopy( e );
                   Add( f, "block_diagonal_matrix(" ,1 );
                   Add( f, ")" );
                   return HomalgSendBlocking( f );
                   
                 end,
               
               MulMat :=
                 function( a, A )
                   local R;
                   
                   R := HomalgRing( A );
                   
                   return HomalgSendBlocking( [ "MulMat(", a, A, R, "[1],", R, "[2])" ] );
                   
                 end,
               
               AddMat :=
                 function( A, B )
                   local R;
                   
                   R := HomalgRing( A );
                   
                   return HomalgSendBlocking( [ "AddMat(", A, B, R, "[1],", R, "[2])" ] );
                   
                 end,
               
               SubMat :=
                 function( A, B )
                   local R;
                   
                   R := HomalgRing( A );
                   
                   return HomalgSendBlocking( [ "SubMat(", A, B, R, "[1],", R, "[2])" ] );
                   
                 end,
               
               Compose :=
                 function( A, B )
                   local R;
                   
                   R := HomalgRing( A );
                   
                   return HomalgSendBlocking( [ "Compose(", A, B, R, "[1],", R, "[2])" ] );
                   
                 end,
               
               NrRows :=
                 function( C )
                   local R;
                   
                   R := HomalgRing( C );
                   
                   return Int( NormalizedWhitespace( HomalgSendBlocking( [ R, "[2][NumberOfRows](", C, ")" ], "need_output" ) ) );
                   
                 end,
               
               NrColumns :=
                 function( C )
                   local R;
                   
                   R := HomalgRing( C );
                   
                   return Int( NormalizedWhitespace( HomalgSendBlocking( [ R, "[2][NumberOfGenerators](", C, ")" ], "need_output" ) ) );
                   
                 end,
               
               ZeroRows :=
                 function( C )
                   local R, list_string;
                   
                   R := HomalgRing( C );
                   
                   HomalgSendBlocking( [ "Checklist=[", C, ".row(x).is_zero() for x in range(", NrRows( C ), ")]" ], "need_command" );
                   HomalgSendBlocking( [ "def check(i):\n  return Checklist[i]\n\n" ], "need_command", R );
                   list_string := HomalgSendBlocking( [ "filter(check,range(", NrRows( C ), "))" ], "need_output", R );
		   list_string := StringToIntList( list_string );
                   return list_string + 1;
                   
                 end,
               
               ZeroColumns :=
                 function( C )
                   local R, list_string;
                   
                   R := HomalgRing( C );
                   
                   HomalgSendBlocking( [ "Checklist=[", C, ".column(x).is_zero() for x in range(", NrColumns( C ), ")]" ], "need_command" );
                   HomalgSendBlocking( [ "def check(i):\n  return Checklist[i]\n\n" ], "need_command", R );
                   list_string := HomalgSendBlocking( [ "filter(check,range(", NrColumns( C ), "))" ], "need_output", R );
		   list_string := StringToIntList( list_string );
                   return list_string + 1;
                   
                 end
       
          );
    
    Objectify( HomalgTableType, RP );
    
    return RP;
    
end );
