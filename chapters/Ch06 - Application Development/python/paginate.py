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

Paginating results

"""
import psycopg2
import sys
import time
import csv
import datetime

def main():

  if ((len(sys.argv)) !=2):
    sys.exit("Error:No URL provided on command line")
  uri=sys.argv[1]
  global connection 
  connection = psycopg2.connect(uri)
  connection.autocommit=True

  cursor=connection.cursor()
  cursor.execute("use chapter06")
  for rows in getPage(100,100):
    print(rows)

  start=0
  batchSize=10000
  maxPages=100
  pageNo=1
  while True:
    startTime = time.time()
    rows=getPage(start,batchSize)
    print("%s, %s" % (pageNo,(time.time()-startTime)))
    start=start+batchSize
    pageNo=pageNo+1
    if (pageNo>maxPages):
      break

  start = datetime.datetime.now()
  pageNo=1
  while True:
    startTime = time.time()
    rows=getPageKeySet(start,batchSize)
    print("%s, %s" % (pageNo,(time.time()-startTime)))
    start=(rows[len(rows)-1][0])
    pageNo=pageNo+1
    if (pageNo>maxPages):
      break

  systemTime = datetime.datetime.utcnow()
  start=systemTime
  pageNo=1
  while True:
    startTime = time.time()
    rows=getPageKeySetST(start,batchSize,systemTime)
    print("%s, %s" % (pageNo,(time.time()-startTime)))
    start=(rows[len(rows)-1][0])
    pageNo=pageNo+1
    if (pageNo>maxPages):
      break
  
  


def getPage(startIndex,nEntries):
  cursor=connection.cursor()
  sql="""SELECT post_timestamp, summary 
            FROM blog_posts ORDER BY post_timestamp DESC
          OFFSET %s LIMIT %s"""
  cursor.execute(sql,(startIndex,nEntries))
  return cursor.fetchall()
   
def getPageKeySet(startTimeStamp,nEntries):
  cursor=connection.cursor()
  sql="""SELECT post_timestamp, summary 
            FROM blog_posts
           WHERE post_timestamp< %s
           ORDER BY post_timestamp DESC
           LIMIT %s"""
  cursor.execute(sql,(startTimeStamp,nEntries))
  return cursor.fetchall()
 

def getPageKeySetST(startTimeStamp,nEntries,systemTime):
  cursor=connection.cursor()
  sql="""SELECT post_timestamp, summary 
            FROM blog_posts
           AS OF SYSTEM TIME %s
           WHERE post_timestamp< %s
           ORDER BY post_timestamp DESC
           LIMIT %s
           """
  cursor.execute(sql,(systemTime,startTimeStamp,nEntries))
  return cursor.fetchall()

main()