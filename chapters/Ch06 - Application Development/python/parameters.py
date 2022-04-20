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

Parameterized queries in python 

"""

import psycopg2
import sys
import time
import csv
 
def main():

  if ((len(sys.argv)) !=2):
    sys.exit("Error:No URL provided on command line")
  uri=sys.argv[1]

  connection = psycopg2.connect(uri)
  cursor=connection.cursor()
  cursor.execute('USE movr')
  cursor.execute('set tracing=on')
  sql = """SELECT u.name FROM movr.rides r   
             JOIN movr.users u ON (r.rider_id=u.id)   
            WHERE r.id=%s"""
  cursor.execute(sql,('ffc3c373-63ec-43fe-98ff-311f29424d8b',))
  row=cursor.fetchone()
  print(row[0])

main()