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
var f{NODI} >= 0, <= k, integer; # capacita del furgone nel nodo i

### VINCOLI  

subject to ingresso{i in NODI} : sum{j in NODI :  (j,i) in ARCHI}
x[j,i] = 1; 
subject to uscita{i in NODI} : sum{j in NODI : (i,j) in ARCHI}
x[i,j] = 1; 
subject to sequenza{(i,j) in ARCHI : j != first(NODI)} :
y[j]-y[i] >= n*x[i,j]+1-n ;
subject to nodo_partenza : y[first(NODI)]=0; 


#subject to constr1{i in NODI} : sum{j in NODI} (c[j] - s[j]) = f[i];
#subject to cap1{(i,j) in ARCHI}: x[i,j]*( c[i] - s[i] + c[j] - s[j] ) = 0; # solo se N è uguale

# 
subject to cap1{(i,j) in ARCHI}: 
x[i,j]*( c[i] - s[i] + c[j] - s[j] ) <= k;



# abbastanza da posare nel successivo
subject to flow1{(i, j) in ARCHI : pc[j] < 0 && i != j} : 
f[i] >= (-pc[j]*x[i,j]);



# (pc[j] > 0) x[i,j] = 1 -> f[i] + pc[j] <= k
subject to flow2{(i, j) in ARCHI : pc[j] > 0 && i != j} : 
(-f[i])  >= ((pc[j] - k)*x[i,j] - (1 - x[i,j])*k);

#------------------------------------------------------------------------

# (pc[i] > 0 && pc[j] < 0) x[i,j] = 1 -> f[j] <= f[i] + pc[j]
subject to flow3{(i, j) in ARCHI : i != j && pc[i] > 0 && pc[j] < 0} : 
(f[i] - f[j]) >= ( (-pc[j])*x[i,j] - (1 - x[i,j])*(k-1));
# (pc[i] > 0 && pc[j] < 0) x[i,j] = 1 -> f[j] >= f[i] + pc[j]
subject to flow32{(i, j) in ARCHI : i != j && pc[i] > 0 && pc[j] < 0} : 
(f[j] - f[i]) >= (pc[j]*x[i,j] + (1 - x[i,j]));



# (pc[i] > 0 && pc[j] > 0) x[i,j] = 1 -> f[j] >= f[i] + pc[j]
subject to flow4{(i, j) in ARCHI : i != j && pc[i] > 0 && pc[j] > 0} : 
(f[j] - f[i]) >= ( pc[j]*x[i,j] - (1 - x[i,j])*(k-1));
# (pc[i] > 0 && pc[j] > 0) x[i,j] = 1 -> f[j] <= f[i] + pc[j]
subject to flow42{(i, j) in ARCHI : i != j && pc[i] > 0 && pc[j] > 0} : 
(f[i] - f[j]) >= ( (-pc[j])*x[i,j] + (1 - x[i,j]));



# (pc[i] < 0 && pc[j] < 0) x[i,j] = 1 -> f[j] <= f[i] + pc[j] 
subject to flow5{(i, j) in ARCHI : i != j && pc[i] < 0 && pc[j] < 0} : 
(f[i] - f[j]) >= ((-pc[j])*x[i,j] - (1 - x[i,j])*(k-1));
# (pc[i] < 0 && pc[j] < 0) x[i,j] = 1 -> f[j] >= f[i] + pc[j]
subject to flow52{(i, j) in ARCHI : i != j && pc[i] < 0 && pc[j] < 0} : 
(f[j] - f[i]) >= (pc[j]*x[i,j] - (1 - x[i,j])*(k-1));



# (pc[i] < 0 && pc[j] > 0) x[i,j] = 1 -> f[j] >= f[i] + pc[j] 
subject to flow6{(i, j) in ARCHI : i != j && pc[i] < 0 && pc[j] > 0} :
(f[j] - f[i]) >= (pc[j]*x[i,j] - (1 - x[i,j])*k);
# (pc[i] < 0 && pc[j] > 0) x[i,j] = 1 -> f[j] <= f[i] + pc[j] 
subject to flow62{(i, j) in ARCHI : i != j && pc[i] < 0 && pc[j] > 0} :
(f[i] - f[j]) >= ( (-pc[j])*x[i,j] + (1 - x[i,j]));

#------------------------------------------------------------------------

subject to neg_limit{i in NODI : pc[i] < 0} : f[i] <= k + pc[i]; 
subject to pos_limit{i in NODI : pc[i] > 0} : f[i] >= pc[i];
subject to start : f[first(NODI)] = pc[first(NODI)];




#subject to cap2{i in NODI} : sum{j in NODI : (i,j) in ARCHI} x[i,j]*(c[i] - s[i]) <= k;
#subject to cap3{i in NODI} : sum{j in NODI : (i,j) in ARCHI} x[i,j]*(c[i] - s[i]) >= 0;
#subject to cap1{i in NODI, j in NODI : (i,j) in ARCHI}: x[i,j]*( c[i] - s[i] - c[j] + s[j] ) >= 0;
#subject to css{(i,j) in ARCHI : pc[i] <0 && pc[j]<0}: x[i,j] = 0; #forzato

#subject to nodo_consentito1{i in NODI} : (sum{j in NODI : (i,j) in ARCHI} x[i,j]*(c[i] - s[i] )) >= 0;

#subject to nodo_consentito1{i in NODI, m in NODI : i > m} : sum{j in NODI : (m,j) in ARCHI} 
#x[m,j]*(c[m] - s[m]) >= ( if( (c[i] - s[i]) < 0) then -pc[i] else  -100000000 );



### OBIETTIVO  

minimize distanza_totale : sum{(i,j) in ARCHI}
t[i,j]*x[i,j]; 

