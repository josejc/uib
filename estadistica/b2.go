// Package MAIN ;)
package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

// Constants in CAPITALS
const ()

// initf read a file the sample of random U[0,1] return slice with the values
func initf(f *os.File) []float64 {
	var values []float64

	input := bufio.NewScanner(f)
	for input.Scan() {
		s := strings.Split(input.Text(), " ")
		for _, elem := range s {
			i, err := strconv.ParseFloat(elem, 32)
			if err != nil {
				// fmt.Fprintf(os.Stderr, "ERROR: %v\n", err)
			} else {
				values = append(values, i)
			}
		}
	}
	return values
	// NOTE: ignoring potential errors from input.Err()
}

// main function for run and test the B2 practice implementation
func main() {
	var u []float64

	run := true
	files := os.Args[1:]
	if len(files) == 0 {
		// World initialization
	} else {
		// Only open the first argument, one file
		arg := files[0]
		fd, err := os.Open(arg)
		if err != nil {
			fmt.Fprintf(os.Stderr, "ERROR: %v\n", err)
			run = false
		} else {
			u = initf(fd)
			fd.Close()
		}
	}
	if run {
		fmt.Println(u)
	}
}
