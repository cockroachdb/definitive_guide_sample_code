/*
Simple GoLang example

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
*/
package main

import (
	"context"
	"fmt"
	"os"

	"github.com/jackc/pgx"
)

func main() {
	if len(os.Args) < 2 {
		fmt.Fprintln(os.Stderr, "Missing URL argument")
		os.Exit(1)
	}
	uri := os.Args[1]
	conn, err := pgx.Connect(context.Background(), uri)
	if err != nil {
		fmt.Fprintf(os.Stderr, "CockroachDB error: %v\n", err)
	}
	execSQL(*conn, "DROP TABLE IF EXISTS names")
	execSQL(*conn, "CREATE TABLE names (name String PRIMARY KEY NOT NULL)")
	execSQL(*conn, "INSERT INTO names (name) VALUES('Ben'),('Jesse'),('Guy')")

	rows, err := conn.Query(context.Background(), "SELECT name FROM names")
	if err != nil {
		fmt.Fprintf(os.Stderr, "CockroachDB error: %v\n", err)
	}
	defer rows.Close()
	for rows.Next() {
		var name string
		err = rows.Scan(&name)
		fmt.Println(name)
	}
}

func execSQL(conn pgx.Conn, sql string) {
	result, err := conn.Exec(context.Background(), sql)
	if err != nil {
		fmt.Fprintf(os.Stderr, "CockroachDB error: %v\n", err)
		os.Exit(1)
	}
	fmt.Fprintf(os.Stdout, "%v rows affected\n", result.RowsAffected())
}
