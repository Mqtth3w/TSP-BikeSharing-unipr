### INSIEMI

set NODI ordered;  
set ARCHI := ( NODI cross NODI );   


### PARAMETRI  

param n := card(NODI); 
param t{ARCHI} default 100000000; 
param c{NODI};
param s{NODI};

### VARIABILI  

var x{ARCHI} binary;
var y{NODI} >= 0, <= n-1, integer; 

### VINCOLI  

subject to ingresso{i in NODI} : sum{j in NODI :  (j,i) in ARCHI}
x[j,i] = 1; 
subject to uscita{i in NODI} : sum{j in NODI : (i,j) in ARCHI}
x[i,j] = 1; 
subject to sequenza{(i,j) in ARCHI : j != first(NODI)} :
y[j]-y[i] >= n*x[i,j]+1-n ;
subject to nodo_partenza : y[first(NODI)]=0; 
subject to cap1{(i,j) in ARCHI}: x[i,j]*( c[i] - s[i] + c[j] - s[j] ) = 0;

### OBIETTIVO  

minimize distanza_totale : sum{(i,j) in ARCHI : i != j}
t[i,j]*x[i,j]; 
