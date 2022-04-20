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
	conn, err := pgx.Connect(ctx, uri)
	// conn, err := pgxpool.Connect(ctx, uri)
	if err != nil {
		panic(err)
	}
	sql := "EXPERIMENTAL CHANGEFEED FOR movr.rides WITH updated, resolved"
	rows, err := conn.Query(ctx, sql)
	if err != nil {
		panic(err)
	}

	for rows.Next() {
		values, err := rows.Values()
		if err != nil {
			panic(err)
		}
		fmt.Println(values)
		/*var tableName string
		var key string
		var value string
		err = rows.Scan(&tableName, &key, &value)
		if err != nil {
			panic(err)
		}
		fmt.Println(tableName, key, value)*/
	}
	fmt.Fprintf(os.Stdout, "Bye")
}
