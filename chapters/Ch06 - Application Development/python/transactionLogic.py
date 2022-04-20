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

simple transaction logic

"""

import psycopg2
import sys
import time
import csv

from dbhelpers import Psycopg2Connection

connection = None 
 
def main():

  if ((len(sys.argv)) !=2):
    sys.exit("Error:No URL provided on command line")
  uri=sys.argv[1]

  connection = psycopg2.connect(uri)
  cursor=connection.cursor()
  cursor.execute('DROP TABLE IF EXISTS balances')
  cursor.execute('CREATE TABLE balances (id int PRIMARY KEY, balance float)')
  cursor.execute('INSERT INTO balances (id,balance) VALUES (1,100), (2,100)')
  txferFunds(1,2,10)
  cursor.execute('SELECT * FROM balances')
  for row in cursor:
    print(row)

 
def txferFunds(fromAcc,toAcc,amount): 
    cursor=connection.cursor()
    try:
        cursor.execute('BEGIN')
        cursor.execute('SELECT * FROM balances WHERE id in (%s,%s) FOR UPDATE' % (fromAcc,toAcc))
        balances=cursor.fetchOne()
        print(balanced)
        cursor.execute('UPDATE balances SET balance=balance-%s WHERE id=%s'%(amount,fromAcc))
        cursor.execute('UPDATE balances SET balance=balance+%s WHERE id=%s'%(amount,toAcc))
        cursor.execute('COMMIT')
    except:
        cursor.execute('ROLLBACK')

main()