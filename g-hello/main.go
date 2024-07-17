package main

import (
	"fmt"
)

func main() {
	fmt.Println("Hello flake")

	m := map[string]interface{}{
		"flag":  true,
		"float": 3.14,
		"hello": "world",
		"hash": map[string]interface{}{
			"first_value": 200,
		},
	}
	fmt.Print(m)
}
