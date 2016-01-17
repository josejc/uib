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

// initf read a file the sample of ramdon U[0,1]
func initf(f *os.File, w *[M][N][H]int) bool {
	var r *strings.Reader
	var b byte
	var x, y, oldy int

	input := bufio.NewScanner(f)
	for input.Scan() {
		s := strings.Split(input.Text(), " ")
		x, _ = strconv.Atoi(s[1])
		y, _ = strconv.Atoi(s[2])
		x += (M / 2)
		y += (N / 2)
	}
	return true
	// NOTE: ignoring potential errors from input.Err()
}

// main function for run and test the B2 practice implementation
func main() {
	var world [M][N][H]int

	run := true
	files := os.Args[1:]
	if len(files) == 0 {
		// World initialization
	} else {
		// Only open the first argument, one file
		arg := files[0]
		f, err := os.Open(arg)
		if err != nil {
			fmt.Fprintf(os.Stderr, "ERROR: %v\n", err)
			run = false
		} else {
			run = initf(f, &world)
			f.Close()
		}
	}
	if run {
	}
}
