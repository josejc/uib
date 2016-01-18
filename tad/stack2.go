type stack struct{ vec []int }

func (s stack) Empty() bool { return len(s.vec) == 0 }
func (s stack) Peek() int   { return s.vec[len(s.vec)-1] }
func (s stack) Len() int    { return len(s.vec) }
func (s *stack) Put(i int)  { s.vec = append(s.vec, i) }
func (s *stack) Pop() int {
  d := s.vec[len(s.vec)-1]
  s.vec = s.vec[:len(s.vec)-1]
  return d
}