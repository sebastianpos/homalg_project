# S1 with C2-Isotropy and a C4-point

M := [ [1,2], [1,3], [2,3] ];
C2 := Group( (1,3)(2,4) );
C4 := Group( (1,2,3,4) );
Isotropy := rec( 1 := C4, 2 := C2, 3 := C2 );
mult := [];
dim := 4;

