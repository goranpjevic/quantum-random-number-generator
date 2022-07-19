#!/usr/bin/env dyalogscript

⍝ zero state
z←1 0
⍝ hadamard gate
H←(2*¯.5)×2 2⍴ 1 1 1 ¯1

⍝ x rotation of an angle
rx←{2 2⍴(2○⍵÷2)(-0j1×1○⍵÷2)(-0j1×1○⍵÷2)(2○⍵÷2)}
⍝ measure a qubit
m←{(?0)<|2*⍨⊃⍵}

⍝ apply a quantum gate on each qubit and measure them
apply_gate←{
  ⍝ number of qubits and iterations
  n i←⍎¨⍵
  ⍝ apply the quantum gate on each qubit
  s←(⍺+.×⊢)¨n⍴⊂z
  ⍝ measure
  ⎕←(⊂∘⍋⌷⊢){⍺,(≢⍵)}⌸⎕←{2⊥m¨s}¨⍳i
}

⍝ set the probability of getting a result
fixed_probability←{
  ⍝ number of qubits, iterations, expected probability and result
  n i p r←⍎¨⍵
  ⍝ expected bits
  b←r⊤⍨n⍴2

  ⍝ first rotations
  ⍝ expected qubit values
  ev←(1÷2×n)*⍨p
  ⍝ rx input values
  riv←n⍴2×¯2○ev
  ⍝ apply the quantum gates
  s←(z+.×⍨rx)¨riv

  ⍝ second rotations
  s←+.×⌿2n⍴s,rx¨○~b

  ⍝ measure
  ⎕←(⊂∘⍋⌷⊢){⍺,(≢⍵)}⌸⎕←{2⊥m¨s}¨⍳i
}

print_usage←{
  ⎕←'usage:',⎕ucs 10
  ⎕←'  qrng.apl [option] [args]',⎕ucs 10
  ⎕←'options:',⎕ucs 10
  ⎕←'  equal distribution of all possible values using hadamard gates:',⎕ucs 10
  ⎕←'    h [number_of_qubits] [number_of_iterations]',⎕ucs 10
  ⎕←'  equal distribution of all possible values using rotation gates:',⎕ucs 10
  ⎕←'    r [number_of_qubits] [number_of_iterations]',⎕ucs 10
  ⎕←'  set the probability of getting a result:',⎕ucs 10
  ⎕←'    f [number_of_qubits] [number_of_iterations] [expected_probability] [expected_result]',⎕ucs 10
}

main←{
  1=≢⍵:print_usage⍬
  'h'=2⊃⍵:H apply_gate 2↓⍵
  'r'=2⊃⍵:(rx○.5)apply_gate 2↓⍵
  'f'=2⊃⍵:fixed_probability 2↓⍵
}

main 2⎕nq#'getcommandlineargs'
