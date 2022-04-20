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

Connection pools in python 

"""


import sys
import time
import csv

import psycopg2
from psycopg2 import pool
 
def main():

  if ((len(sys.argv)) !=2):
    sys.exit("Error:No URL provided on command line")
  uri=sys.argv[1]

  pool= psycopg2.pool.ThreadedConnectionPool(10, 40, uri) # min connection=10, max=40

  connection = pool.getconn()

  cursor=connection.cursor()
  cursor.execute("SELECT now()")
  for row in cursor:
    print(row[0])
  cursor.close()
  connection.close()
 
main()