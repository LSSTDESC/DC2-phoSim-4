#!/bin/bash
## Delete a persistent Burst Buffer reservation
##  Note that persistent reservations hold until explicitly cancelled
##  (either by you or NERSC admins after ~8 weeks)
#SBATCH -q debug
#SBATCH -N 1
#SBATCH -C haswell
#SBATCH -t 00:05:00
#BB delete_persistent name=Run2_0p
