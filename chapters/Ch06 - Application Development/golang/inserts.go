/*
Array inserts in GoLang

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
	ctx := context.Background()
	connection, err := pgx.Connect(ctx, uri)
	if err != nil {
		fmt.Fprintf(os.Stderr, "CockroachDB error: %v\n", err)
	}
	result, err := connection.Query(context.Background(), "SELECT NOW()")
	if err != nil {
		fmt.Fprintf(os.Stderr, "CockroachDB error: %v\n", err)
	}

	result.Next()
	values, err := result.Values()
	if err != nil {
		panic(err)
	}
	fmt.Fprintf(os.Stdout, "%v \n", values[0])
	result.Close()

	// Array insert testing
	const rowsToInsert int = 10000

	var idArray [rowsToInsert]int

	var xArray [rowsToInsert]string
	var yArray [rowsToInsert]int

	for i := 0; i < rowsToInsert; i++ {
		idArray[i] = i
		xArray[i] = "Nonsense data"
		yArray[i] = i
	}
	execSQL(*connection, "USE chapter06")
	execSQL(*connection, "DROP TABLE IF EXISTS insertTest")
	execSQL(*connection, "CREATE TABLE insertTest (id int primary key,x string,y int)")

	sql := "INSERT INTO insertTest (id,x,y) VALUES ($1, $2, $3)"
	lowIdx := 0
	highIdx := 1000
	idSlice := idArray[lowIdx:highIdx]
	xSlice := xArray[lowIdx:highIdx]
	ySlice := yArray[lowIdx:highIdx]
	_, err = connection.Exec(ctx, sql, idSlice, xSlice, ySlice)
	if err != nil {
		fmt.Fprintf(os.Stderr, "CockroachDB error: %v\n", err)
		os.Exit(1)
	}

}

func execSQL(conn pgx.Conn, sql string) {
	result, err := conn.Exec(context.Background(), sql)
	fmt.Println(sql)
	if err != nil {
		fmt.Fprintf(os.Stderr, "CockroachDB error: %v\n", err)
		os.Exit(1)
	}
	fmt.Fprintf(os.Stdout, "%v rows affected\n", result.RowsAffected())
}
