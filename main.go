package main

import (
	"fmt"
	"net/http"
	"time"
)

func handler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w,
		"{ 'Time': '%s','RequestURI': '%s','Host': '%s', 'UserAgent': '%s' }",
		time.Now().Format(time.RFC1123), r.RequestURI, r.Host, r.UserAgent())
}

func main() {
	http.HandleFunc("/", handler)
	http.ListenAndServe(":8028", nil)
}
