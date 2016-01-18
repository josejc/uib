# Abstract Data Type (Tipus Abstracte Dades)

## List

Variations:

* With tail pointer
* With dummy node (sentinels)
* Double linked list (Go package "container/list")

## Stack (list lifo) (Go implementation with slices)

Operations:

* push(x,s)
* pop(s)
* initialize(s)
* full(s)/empty(s)

## Queue (list fifo) (maybe Go implementation with slices)

Operations:

* enqueue(x,q)
* dequeue(q)
* initilize(q)
* full(q)/empty(q)

## Priority queue (Go implementation with heap)

Operations:

* insert(x,p)
* max(p)
* extractmax(p)

## Dictionary (maybe Go implemenatation with map)

Operations: 

* insert(x,d)
* delete(x,d)
* search(k,d)

## Set (maybe Go implementation with map)

Operations:

* member(x,s)
* union(A,B)
* intersection(A,B)
* insert(x,s)
* delete(x,s)

## Go Language

Basic types:

* array
* slice
* map

Package container:

* heap (tree special)
* list (double link)
* ring (circular list)

Bonda...
