#![feature(iter_map_windows)]
use std::num::ParseIntError;

type Input = Vec<Vec<u32>>;

fn parse(input: &str) -> Result<Input, ParseIntError> {
    input
        .split("\n")
        .map(|line| line.split_whitespace().map(str::parse).collect())
        .collect()
}

fn is_safe(iter: impl Iterator<Item = u32>) -> bool {
    let (inc, dec, adj) = iter
        .map_windows(|[a, b]| (a < b, a > b, (1..=3).contains(&a.abs_diff(*b))))
        .fold((true, true, true), |(inc, dec, adj), (i, d, a)| {
            (inc && i, dec && d, adj && a)
        });

    (inc || dec) && adj
}

fn part_1(input: &Input) -> usize {
    input
        .iter()
        .filter(|row| is_safe(row.iter().copied()))
        .count()
}

fn part_2(input: &Input) -> usize {
    input
        .iter()
        .filter(|row| {
            if is_safe(row.iter().copied()) {
                true
            } else {
                (0..row.len()).any(|i| {
                    is_safe(row.iter().copied().enumerate().filter_map(|(j, x)| {
                        if i == j {
                            None
                        } else {
                            Some(x)
                        }
                    }))
                })
            }
        })
        .count()
}

pub fn main() -> Result<(), ParseIntError> {
    let input = parse(include_str!("../../inputs/02.txt"))?;

    dbg!(part_1(&input));
    dbg!(part_2(&input));

    Ok(())
}

#[cfg(test)]
mod test {
    use crate::*;
    use std::num::ParseIntError;

    #[test]
    fn test_day_2() -> Result<(), ParseIntError> {
        let input = parse(include_str!("../../inputs/02.example.txt"))?;

        assert_eq!(2, part_1(&input));
        assert_eq!(4, part_2(&input));

        Ok(())
    }
}
