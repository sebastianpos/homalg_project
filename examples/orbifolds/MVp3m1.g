# S1 with C2-Isotropy, three D6-points

#    1
#   2 3
#  4 5 6

M := [ [1,2], [1,3], [2,4], [3,6], [4,5], [5,6] ];

C2 := Group( (1,2) );
D6 := Group( (1,2), (1,2,3) );

Isotropy := rec( 1 := D6, 2 := C2, 3 := C2, 4 := D6, 5 := C2, 6 := D6 );
mult := [];
dim := 3;

