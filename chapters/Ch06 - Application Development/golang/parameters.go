/*
Using parameters in GoLang

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
	ctx := context.Background()
	if err != nil {
		fmt.Fprintf(os.Stderr, "CockroachDB error: %v\n", err)
	}
	tx, err := conn.Begin(context.Background())
	if err != nil {
		fmt.Fprintf(os.Stderr, "CockroachDB error: %v\n", err)
	}
	defer tx.Rollback(context.Background())
	execSQL(*conn, "USE movr")
	execSQL(*conn, "set tracing=on")

	sql := `SELECT u.name FROM movr.rides r   
		      JOIN movr.users u ON (r.rider_id=u.id)   
             WHERE r.id=$1`
	rows, err := conn.Query(ctx, sql, "ffc3c373-63ec-43fe-98ff-311f29424d8b")
	rows.Next()
	var name string
	err = rows.Scan(&name)
	fmt.Println(name)

}

func execSQL(conn pgx.Conn, sql string) {
	result, err := conn.Exec(context.Background(), sql)
	if err != nil {
		fmt.Fprintf(os.Stderr, "CockroachDB error: %v\n", err)
		os.Exit(1)
	}
	fmt.Fprintf(os.Stdout, "%v rows affected\n", result.RowsAffected())
}

func traceData(conn pgx.Conn) {
	rows, err := conn.Query(context.Background(), "show tracing")
	if err != nil {
		fmt.Fprintf(os.Stderr, "CockroachDB error: %v\n", err)
	}
	defer rows.Close()
	for rows.Next() {
		var tracing string
		err = rows.Scan(&tracing)
		fmt.Println(tracing)
	}
	sql := `SELECT age , message
	FROM [SHOW TRACE FOR SESSION]
	WHERE message LIKE 'query cache miss'
	OR message LIKE 'rows affected%'
	OR message LIKE '%executing PrepareStmt%'
	OR message LIKE 'executing:%'
	ORDER BY age`
	sql = "show trace for session"
	fmt.Println(sql)
	rows, err = conn.Query(context.Background(), sql)
	if err != nil {
		fmt.Fprintf(os.Stderr, "CockroachDB error: %v\n", err)
	}
	defer rows.Close()
	for rows.Next() {
		var message string
		err = rows.Scan(&message)
		fmt.Println(message)
	}
}
