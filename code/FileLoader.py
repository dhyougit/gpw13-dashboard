# -*- coding: utf-8 -*-
"""
Combine GHO datafiles into GPW13 and UHC indicator set 
1. Get file list 
1.1 get file name and sheet name for all xlsx files 
2. Combine CSV/excel files into one excel file and use filename as sheet name 

3. Combine WHSfiles into one file first and check the format of table if it is coherent. 

@author: dyou
"""


import pandas as pd 
import numpy as np
import os 
import glob

path='C:/Users/dyou/Desktop/document/R_shiny'
os.chdir(path)
totallist=os.listdir(path)
csvlist=glob.glob("*.csv")
xlsxlist=glob.glob("*.xls*")

len(csvlist),len(xlsxlist)



excelfilenames=csvlist
for excelfilename in excelfilenames: 
    df = pd.read_csv(str(excelfilename), None)
    print ("================="+ excelfilename+"=========================")
    print (df.keys()) 
 

excelfilenames=xlsxlist
for excelfilename in excelfilenames: 
    df = pd.read_excel(str(excelfilename), None)
    print ("================="+ excelfilename+"=========================")
    print (df.keys()) 
 


WHSexcelfilenames= ['./whs2016_AnnexB.xls','./whs2017_AnnexB.xlsx','./whs2018_AnnexB.xls']
excelfilename=WHSexcelfilenames
for excelfilename in excelfilenames: 
    df = pd.read_excel(str(excelfilename), None)
    print (df.keys()) 
 

# WHS2018 
df = pd.read_excel('./whs2018_AnnexB.xls',sheetname ='Annex B-1')


df=pd.read_csv('HealthEquity_AntenatalCareCoverage_aggrgtByEconomicStatus.csv', None)