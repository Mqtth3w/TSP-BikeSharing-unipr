
### INSIEMI

set NODI ordered;  
set ARCHI := (NODI cross NODI);

### PARAMETRI

param n := card(NODI); 
param t{ARCHI} default 20; 
param c{NODI} default 10;   
param s{NODI} default 10;    
param k default 10;        

### VARIABILI

var x{ARCHI} binary;  
var ya{NODI} >= 0;  
var y{NODI} >= 0, <= n-1, integer;     

### VINCOLI

subject to capacity_constraint:
    sum {i in NODI} ya[i] <= k;  ### Il furgone non può superare la sua capacità massima
    
###subject to flow_constraint {i in NODI}:
 ###   ya[i] = c[i] - sum {j in NODI} x[i,j] * s[j];  ### Vincoli di flusso


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