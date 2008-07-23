# S1 with C2-Isotropy and four V4-points

#    1
#   2 3
#  4   5
#   6 7
#    8

M := [ [1,2], [1,3], [2,4], [3,5], [4,6], [5,7], [6,8], [7,8] ];
C2 := Group( (1,2) );
V4 := Group( (1,2), (3,4) );
Isotropy := rec( 1 := V4, 2 := C2, 3 := C2, 4 := V4, 5 := V4, 6 := C2, 7 := C2, 8 := V4 );
mult := [];
dim := 3;


