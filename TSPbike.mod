### INSIEMI

set NODI ordered;  
set ARCHI := (NODI cross NODI);   


### PARAMETRI  

param n := card(NODI); 
param t{ARCHI} default 10000000; 
param k default 10;
param c{NODI} default 10;
param s{NODI} default 10;
param pc{i in NODI} := s[i] - c[i];


### VARIABILI  

var x{ARCHI} binary;
var y{NODI} >= 0, <= n-1, integer; 
var fc >= 0, <= k, integer;

### VINCOLI  

subject to successivo1 {i in NODI}: if(y[i] != 0) then { sum{j in NODI : (j,i) in ARCHI} pc[i] + pc[0] <= k};
subject to successivo2 {i in NODI}: (sum{j in NODI : (i,j) in ARCHI && y[i] != 0} pc[i]) + pc[0] <= k;

### subject to successivo: yj − yi >= pc[j] * x[i,j] − k(1 − x[i,j])

### subject to successivo1 {i in NODI}: if (fc = 0) then { if (pc[i] >= 0) then {fc == fc + pc[i]} };
### subject to successivo2 {i in NODI}: if (fc = K) then { if (pc[i] <= 0) then {fc == fc - pc[i]} };
### subject to successivo3 {i in NODI}: if (0 <= fc <= K) then { if (pc[i] > 0) then { if (fc + pc[i]) <= K) then {fc == fc + pc[i]} };
### subject to successivo4 {i in NODI}: if (0 <= fc <= K) then { if (pc[i] < 0) then { if (fc + pc[i]) >= 0) then{fc == fc - pc[i]} };

subject to ingresso{i in NODI} : sum{j in NODI :  (j,i) in ARCHI}
x[j,i] = 1; 
subject to uscita{i in NODI} : sum{j in NODI : (i,j) in ARCHI}
x[i,j] = 1; 
subject to sequenza{(i,j) in ARCHI : j != first(NODI)} :
y[j]-y[i] >= n*x[i,j]+1-n ;
subject to nodo_partenza : y[first(NODI)]=0; 


 

### OBIETTIVO  

minimize distanza_totale : sum{(i,j) in ARCHI}
t[i,j]*x[i,j]; 
