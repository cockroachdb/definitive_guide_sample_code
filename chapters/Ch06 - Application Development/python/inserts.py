#!/usr/bin/env python3
""" 
CockroachDB the Definitive Guide sample code 
This code  is public domain software, i.e. not copyrighted.

Warranty Exclusion
------------------
You agree that this software is a non-commercially developed program that may 
contain "bugs"   and that it may not function as intended.
The software is licensed "as is". The authors make no, and hereby expressly
disclaim all, warranties, express, implied, statutory, or otherwise
with respect to the software, including noninfringement and the implied
warranties of merchantability and fitness for a particular purpose.

@author:  gharriso (guy.a.harrison@gmail.com) 

Array inserts in python

"""

import sys
import time
import csv
import random
import string

import psycopg2
from psycopg2 import pool
from psycopg2 import extras

if ((len(sys.argv)) !=2):
    sys.exit("Error:No URL provided on command line")
uri=sys.argv[1]
rowCount=10000

connection = psycopg2.connect(uri)
arrayValues=[]
for i in range(0,rowCount) : 
    idvalue=i
    xvalue=''.join(random.choices(string.ascii_uppercase + string.digits, k=100))
    yvalue=i+1
    arrayValues.append((idvalue,xvalue,yvalue))

cursor=connection.cursor()
cursor.execute("USE chapter06")
cursor.execute("DROP TABLE if EXISTS insertTestP1")
cursor.execute("CREATE TABLE insertTestP1 (id int primary key,x string,y int)")

sql="INSERT INTO insertTestP1(id,x,y) VALUES"
valueCount=0
for value in arrayValues:
    if valueCount>0:
        sql=sql+","
    sql=sql+"(%d,'%s',%d)" % value
    valueCount+=1
# cursor.execute(sql)

startTime = time.time()
extras.execute_values(cursor,
    "INSERT INTO insertTestP1(id,x,y) VALUES %s",
    arrayValues)
elapsedTime = time.time()- startTime 
print (elapsedTime)

cursor.execute("TRUNCATE TABLE insertTestP1")
startTime = time.time()
for value in arrayValues:
    cursor.execute("INSERT INTO insertTestP1(id,x,y) VALUES (%s,%s,%s)",
                    (value[0],value[1],value[2])) 
elapsedTime = time.time()- startTime 
print (elapsedTime)   

cursor.execute("SELECT * FROM inserttestP1 LIMIT 10")
for rows in cursor:
    print(rows)
 

 

def arrayInsert(arrayValues):

  
    startTime = time.clock()
    ins_csr=connection.cursor()
    ins_csr.prepare(" INSERT /* array */ INTO PythonDemo (x, y) " +\
          " VALUES (:1, :2)")
    ins_csr.executemany(None,arrayValues)

    connection.commit()
    elapsedTime = time.clock()- startTime 
    print( "%d rows affected %f s " % (ins_csr.rowcount, elapsedTime))

 