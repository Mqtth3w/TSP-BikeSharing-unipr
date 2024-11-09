# TPS with capacity in BikeSharing Relocation

## Problem description

A company that manages bike-sharing has the problem of relocating bikes every evening in the stalls where there is the greatest demand. In practice there are N stalls, each stall i has a certain number Ci of bikes parked in it in the evening and wants si parked in the same one in the morning. The bikes are recovered using a van that has a maximum capacity of K. The travel times Ti,j between the different pairs i, j ∈ N of stalls are then known. The problem to be solved consists in trying to plan the operations of relocating the bikes in a minimum time. Formulate a mathematical model of this problem, translate it into AMPL and solve and comment on a particular instance of the problem.

Detailed documentation [BikeSharing documentazione](./BikeSharing-documentazione.pdf).

## AMPL 
- [TSP_eqN.mod](./TSP_eqN.mod) this model is a simplified version.
- [TSPbike.mod](./TSPbike.mod) this file contains the model.
