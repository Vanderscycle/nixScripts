package main

import (
	"fmt"
	"log"
	"os"
)

// retruns a list of dir
func IsDirectory(path string, debug ...bool) ([]string, error) {
	listDir := []string{}
	fi, err := os.ReadDir(path)
	if err != nil {
		return listDir, err
	}
	for _, v := range fi {
		if len(debug) > 0 {
			fmt.Println(v.IsDir(), v.Name())
		}
		if v.IsDir() {
			listDir = append(listDir, v.Name())
		}
	}
	return listDir, err
}

func main() {
	listDir, err := IsDirectory(".")
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println(listDir)

	// os.Chdir(fmt.Sprintf("./%s", v.Name()))
	// fi2, _ := os.ReadDir(".")
	// fmt.Println(fi2)
}
