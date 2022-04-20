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

Using AS OF SYSTEM TIME 

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
  connection.autocommit=False
  cursor.execute('ROLLBACK')
  cursor.execute("BEGIN AS OF SYSTEM TIME '-10s'" )
  top10cities=cursor.execute('''SELECT city,count(*) 
                                  FROM movr.rides GROUP BY city 
                                 ORDER BY 2 DESC LIMIT 10''')
  top10users=cursor.execute('''SELECT name, rides   
                                 FROM movr.user_ride_counts 
                                ORDER BY  rides DESC LIMIT 10''')
  cursor.execute('COMMIT')

  print (now)
  cursor.close()
  connection.close()
 
main()