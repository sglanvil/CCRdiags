#!/usr/bin/env python

# -------- BEFORE RUNNING SCRIPT -------- 
# (optional) module remove conda (autofill, maybe conda/latest)
# module load python
# python3 sg_annual.py
# ---------------------------------------

# -------- USER SPECIFICATIONS ----------
caseName="b.e21.BWHIST.SD.f09_g17.002.nudgedOcn"
# ---------------------------------------

import os
os.system("pip install netCDF4")
import netCDF4 as nc

dir="/glade/scratch/ssfcst/archive/b.e21.BWHIST.SD.f09_g17.002.nudgedOcn/atm/hist/"
fil=dir+caseName+".cam.h0.2021-12.nc"
print(fil)

ds=nc.Dataset(fil)
print(ds)
print(ds.__dict__)
print(ds.__dict__['case'])

for dim in ds.dimensions.values():
    print(dim)

for var in ds.variables.values():
    print(var)
    print(" ")

print(ds['TS'])
TS=ds['TS'][:]
print(TS)

