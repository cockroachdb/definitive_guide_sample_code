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

Cursors in python 

"""
import psycopg2
import sys
import time
import csv

from dbhelpers import Psycopg2Connection
from dbhelpers import cm_cursor
from dbhelpers import fetchiter
 
def main():

  if ((len(sys.argv)) !=2):
    sys.exit("Error:No URL provided on command line")
  uri=sys.argv[1]

  connection = psycopg2.connect(uri)
  cursor=connection.cursor()
  cursor.execute("use chapter06")
  cursor.execute("set tracing=on")

  start=time.time()
  cursor = connection.cursor('guy1')
  cursor.execute("""SELECT post_timestamp, summary 
                      FROM blog_posts ORDER BY post_timestamp DESC """) 
  rowCount=0
  for row in cursor:
    rowCount+=1
    print(row)
    if (rowCount>9):
        break
  end=time.time()
  print("sever side",end-start) 

 

  dbhelper_conn = Psycopg2Connection(db='defaultdb', user='root',host='guy13',port=26257).connect()
  start=time.time()
  with cm_cursor(dbhelper_conn) as cursor:
        cursor.execute("use chapter06")
        cursor.execute("set tracing=on")
        cursor.execute("""SELECT post_timestamp, summary 
                            FROM blog_posts ORDER BY post_timestamp DESC """)
        rowCount=0
        for row in fetchiter(cursor):
          rowCount+=1
          print(row)
          if (rowCount>9):
            break
        end=time.time()
        cursor.execute("""SELECT age , message
                    FROM [SHOW TRACE FOR SESSION]
                    WHERE message LIKE 'query cache miss'
                    OR message LIKE 'rows affected%'
                    OR message LIKE '%executing PrepareStmt%'
                    OR message LIKE 'executing:%'
                    ORDER BY age""")
        for row in cursor:
          print(row[1])
  print("fetchIter",end-start) 
 
  start=time.time()
  cursor = connection.cursor()
  cursor.execute("""SELECT post_timestamp, summary 
                      FROM blog_posts ORDER BY post_timestamp DESC """) 
  rowCount=0
  for row in cursor:
    rowCount+=1
    print(row)
    if (rowCount>9):
        break
  end=time.time()
  print("Iterate",end-start) 

 

  start=time.time()
  cursor.execute("""SELECT post_timestamp, summary 
                      FROM blog_posts ORDER BY post_timestamp DESC """)
  for x in range(0, 9):
      row=cursor.fetchone()
      print(row)
  end=time.time()
  print("fetchone",end-start)

  cursor=connection.cursor()
  cursor.arraysize=100
  cursor.itersize=100
  cursor.execute("use chapter06")
  start=time.time()
  cursor.execute("""SELECT post_timestamp, summary 
                      FROM blog_posts ORDER BY post_timestamp DESC """)
  cursor.arraysize=100
  cursor.itersize=100
  for x in range(0, 9):
      row=cursor.fetchone()
      print(row)
  end=time.time()
  print("Arraysize/itersize 100 ", (end-start))  

  start=time.time()
  cursor.execute("""SELECT post_timestamp, summary 
                      FROM blog_posts ORDER BY post_timestamp DESC """)
  rows=cursor.fetchall()
  print("%s rows returned" % len(rows))
  for x in range(0, 9):
      print(rows[x])
  
  end=time.time()
  print("FetchAll",end-start)  

  start=time.time()
  cursor.execute("""SELECT post_timestamp, summary 
                      FROM blog_posts ORDER BY post_timestamp DESC """) 
  rows = cursor.fetchmany(size=10)
  for x in range(0,len(rows)):
      print(rows[x])
  end=time.time()
  print("fetchMany size=10",end-start)  

  cursor.execute("""SELECT age , message
                    FROM [SHOW TRACE FOR SESSION]
                    WHERE message LIKE 'query cache miss'
                    OR message LIKE 'rows affected%'
                    OR message LIKE '%executing PrepareStmt%'
                    OR message LIKE 'executing:%'
                    ORDER BY age""")
  for row in cursor:
    print(row[1])

  cursor.execute("SHOW TRACE FOR SESSION")
  with open('trace.txt', 'w') as fp:
    for row in cursor:
      fp.write(str(row))

main()