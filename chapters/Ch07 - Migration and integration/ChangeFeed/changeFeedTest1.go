package main

import (
	"context"
	"log"
	"os"
	"time"

	"github.com/jackc/pgx/v4/pgxpool"
)

func writer(start time.Time, pool *pgxpool.Pool) {
	ctx := context.Background()
	for i := 0; ; i++ {
		_, err := pool.Exec(ctx, "INSERT INTO streaming_test (v) VALUES ($1)", i)
		if err != nil {
			log.Printf("failed insert %d: %s", i, err)
		}
		log.Printf("%v: wrote %d", time.Since(start), i)
		time.Sleep(time.Second)
	}
}

func reader(start time.Time, pool *pgxpool.Pool) {
	ctx := context.Background()
	rows, err := pool.Query(ctx, "EXPERIMENTAL CHANGEFEED FOR streaming_test")
	log.Printf("changefeed Query returned after %v", time.Since(start))
	if err != nil {
		panic(err)
	}
	for rows.Next() {
		values, err := rows.Values()
		if err != nil {
			panic(err)
		}
		log.Printf("%v: read %s", time.Since(start), values)
	}
}

func main() {
	ctx := context.Background()
	dbURI := os.Getenv("DB_URI")
	pool, err := pgxpool.Connect(ctx, dbURI)
	if err != nil {
		panic(err)
	}

	_, err = pool.Exec(ctx, `DROP TABLE IF EXISTS streaming_test`)
	if err != nil {
		panic(err)
	}

	_, err = pool.Exec(ctx, `
      CREATE TABLE IF NOT EXISTS streaming_test (
          k UUID PRIMARY KEY DEFAULT gen_random_uuid(),
          v INTEGER)`)
	if err != nil {
		panic(err)
	}

	start := time.Now()
	go reader(start, pool)
	go writer(start, pool)
	<-ctx.Done()
}
