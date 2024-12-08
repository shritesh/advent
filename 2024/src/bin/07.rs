type Input = Vec<(usize, Vec<usize>)>;

fn parse(input: &str) -> Option<Input> {
    input
        .lines()
        .map(|line| {
            let (i, rest) = line.split_once(": ")?;

            let numbers = rest
                .split_whitespace()
                .map(|s| s.parse().ok())
                .collect::<Option<Vec<usize>>>()?;

            Some((i.parse().ok()?, numbers))
        })
        .collect()
}

fn part_1(x: usize, n: usize) -> [usize; 2] {
    [x + n, x * n]
}

fn part_2(x: usize, n: usize) -> [usize; 3] {
    [x + n, x * n, x * 10usize.pow(n.ilog10() + 1) + n]
}

fn run<const N: usize>(input: &Input, operators: impl Fn(usize, usize) -> [usize; N]) -> usize {
    input
        .iter()
        .filter_map(|(expected, numbers)| {
            numbers
                .iter()
                .skip(1)
                .fold(vec![numbers[0]], |acc, n| {
                    acc.iter().flat_map(|x| operators(*x, *n)).collect()
                })
                .iter()
                .any(|x| x == expected)
                .then_some(expected)
        })
        .sum()
}
fn main() {
    let input = parse(include_str!("../../inputs/07.txt")).expect("unable to parse input");

    dbg!(run(&input, part_1));
    dbg!(run(&input, part_2));
}

#[cfg(test)]
mod test {
    use crate::*;

    #[test]
    fn test_day_2() {
        let input = parse(include_str!("../../inputs/07.example.txt")).unwrap();
        assert_eq!(3749, run(&input, part_1));
        assert_eq!(11387, run(&input, part_2));
    }
}
