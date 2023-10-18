let parse = input => {
  input
  ->String.split("\n\n")
  ->Array.map(group =>
    String.split(group, "\n")
    ->Array.map(Int.fromString(_))
    ->Array.map(Option.getExn)
  )
}

let sum = array => Array.reduce(array, 0, (a, b) => a + b)

let part1 = input => {
  input
  ->parse
  ->Array.map(sum)
  ->Math.Int.maxMany
}

let part2 = input => {
  input
  ->parse
  ->Array.map(sum)
  ->Array.toSorted(Int.compare)
  ->Array.sliceToEnd(~start=-3)
  ->sum
}

Console.log2(Inputs.day1->part1, Inputs.day1->part2)
