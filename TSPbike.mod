### INSIEMI ###--------------------------------------------------------------------------

set NODI ordered;  
set ARCHI := ( NODI cross NODI );   


### PARAMETRI ###------------------------------------------------------------------------

param n := card(NODI); 
param t{ARCHI} default 100000000; 
param c{NODI};
param s{NODI};
param pc{i in NODI} := c[i] - s[i];
param k;


### VARIABILI ###------------------------------------------------------------------------

var x{ARCHI} binary;
var y{NODI} >= 0, <= n-1, integer; 
var f{NODI} >= 0, <= k, integer; # capacita del furgone nel nodo i


### VINCOLI ###--------------------------------------------------------------------------

subject to ingresso{i in NODI} : sum{j in NODI :  (j,i) in ARCHI}
x[j,i] = 1; 
subject to uscita{i in NODI} : sum{j in NODI : (i,j) in ARCHI}
x[i,j] = 1; 
subject to sequenza{(i,j) in ARCHI : j != first(NODI)} :
y[j]-y[i] >= n*x[i,j]+1-n ;
subject to nodo_partenza : y[first(NODI)]=0; 

subject to flusso_1{(i, j) in ARCHI : i != j} :
(f[j] - f[i]) >= (pc[j]*x[i,j] + (1 - x[i,j])*(-k));
subject to flusso_12{(i, j) in ARCHI : i != j} :
(f[j] - f[i]) <= (pc[j]*x[i,j] + (1 - x[i,j])*k);
subject to start : f[first(NODI)] = if(pc[first(NODI)] > 0) then pc[first(NODI)] else 0;


### OBIETTIVO ###------------------------------------------------------------------------

minimize distanza_totale : sum{(i,j) in ARCHI}
t[i,j]*x[i,j];


