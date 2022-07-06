#!/usr/bin/env dyalogscript

⍝ hadamard gate
H←(2*¯.5)×2 2⍴ 1 1 1 ¯1

⍝ x rotation of an angle
rx←{2 2⍴(2○⍵÷2)(-0j1×1○⍵÷2)(-0j1×1○⍵÷2)(2○⍵÷2)}
⍝ measure qubits
m←{1⊃¨{⍵>?0}¨+\¨|2*⍨¨⍵}

⍝ equal distribution of all possible values using hadamard gates
had_rand←{
  ⍝ number of qubits and iterations
  n i←⍎¨⍵
  ⍝ all initial states
  q←1 0
  ⍝ apply hadamard gates
  s←(H+.×⊢)¨n⍴⊂q
  ⍝ measure
  ⎕←(⊂∘⍋⌷⊢){⍺,(≢⍵)}⌸⎕←{2⊥m s}¨⍳i
}

⍝ equal distribution of all possible values using rotation gates
rot_rand←{
  ⍝ number of qubits and iterations
  n i←⍎¨⍵
  ⍝ all initial states
  q←1 0
  ⍝ apply rotation gates
  s←((rx○.5)+.×⊢)¨n⍴⊂q
  ⍝ measure
  ⎕←(⊂∘⍋⌷⊢){⍺,(≢⍵)}⌸⎕←{2⊥m s}¨⍳i
}

⍝ set the probability of getting a result
fixed_probability←{
  ⍝ number of qubits, iterations, expected probability and result
  n i p r←⍎¨⍵
  ⍝ all initial states
  q←1 0
  ⍝ expected bits
  b←r⊤⍨n⍴2

  ⍝ first rotations
  ⍝ expected qubit values
  ev←(1÷2×n)*⍨p
  ⍝ rx input values
  riv←n⍴2×¯2○ev
  ⍝ apply quantum gates
  s←(q+.×⍨rx)¨riv

  ⍝ second rotations
  s←+.×⌿2n⍴s,rx¨○~b

  ⍝ measure
  ⎕←(⊂∘⍋⌷⊢){⍺,(≢⍵)}⌸⎕←{2⊥m s}¨⍳i
}

print_usage←{
  ⎕←'usage:',⎕ucs 10
  ⎕←'  equal distribution of all possible values using hadamard gates:',⎕ucs 10
  ⎕←'    h [number_of_qubits] [number_of_iterations]',⎕ucs 10
  ⎕←'  equal distribution of all possible values using rotation gates:',⎕ucs 10
  ⎕←'    r [number_of_qubits] [number_of_iterations]',⎕ucs 10
  ⎕←'  set the probability of getting a result:',⎕ucs 10
  ⎕←'    f [number_of_qubits] [number_of_iterations] [expected_probability] [expected_result]',⎕ucs 10
}

main←{
  1=≢⍵:print_usage⍬
  'h'=2⊃⍵:had_rand 2↓⍵
  'r'=2⊃⍵:rot_rand 2↓⍵
  'f'=2⊃⍵:fixed_probability 2↓⍵
}

main 2⎕nq#'getcommandlineargs'
