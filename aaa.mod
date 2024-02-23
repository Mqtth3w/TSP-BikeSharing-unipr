### INSIEMI

set NODI ordered;  
set ARCHI := ( NODI cross NODI );   


### PARAMETRI  

param n := card(NODI); 
param t{ARCHI} default 100000000; 
param c{NODI};
param s{NODI};
param pc{i in NODI} := c[i] - s[i];
param k;


### VARIABILI  

var x{ARCHI} binary;
var y{NODI} >= 0, <= n-1, integer; 
var v{ARCHI} >= 0, <= k, integer; # num bici trasferite da i a j

### VINCOLI  

subject to ingresso{i in NODI} : sum{j in NODI :  (j,i) in ARCHI}
x[j,i] = 1; 
subject to uscita{i in NODI} : sum{j in NODI : (i,j) in ARCHI}
x[i,j] = 1; 
subject to sequenza{(i,j) in ARCHI : j != first(NODI)} :
y[j]-y[i] >= n*x[i,j]+1-n ;
subject to nodo_partenza : y[first(NODI)]=0; 


#subject to cap1{(i,j) in ARCHI}: x[i,j]*( c[i] - s[i] + c[j] - s[j] ) <= k;
subject to cap2{i in NODI} : sum{j in NODI : (i,j) in ARCHI} x[i,j]*(c[i] - s[i]) <= k;
#subject to cap3{i in NODI} : sum{j in NODI : (i,j) in ARCHI} x[i,j]*(c[i] - s[i]) >= 0;
#subject to cap1{i in NODI, j in NODI : (i,j) in ARCHI}: x[i,j]*( c[i] - s[i] - c[j] + s[j] ) >= 0;
#subject to css{(i,j) in ARCHI : pc[i] <0 && pc[j]<0}: x[i,j] = 0; #forzato

#subject to nodo_consentito1{i in NODI} : (sum{j in NODI : (i,j) in ARCHI} x[i,j]*(c[i] - s[i] )) >= 0;

#subject to nodo_consentito1{i in NODI, m in NODI : i > m} : sum{j in NODI : (m,j) in ARCHI} 
#x[m,j]*(c[m] - s[m]) >= ( if( (c[i] - s[i]) < 0) then -pc[i] else  -100000000 );



### OBIETTIVO  

minimize distanza_totale : sum{(i,j) in ARCHI : i != j}
t[i,j]*x[i,j]; 

