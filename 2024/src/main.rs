#![feature(iter_array_chunks)]
use std::{collections::BTreeMap, num::ParseIntError};

fn parse_input(input: &str) -> Result<(Vec<i64>, Vec<i64>), ParseIntError> {
    input
        .split_ascii_whitespace()
        .map(str::parse::<i64>)
        .array_chunks()
        .map(|[l, r]| Ok((l?, r?)))
        .collect()
}

fn part_1(left: &[i64], right: &[i64]) -> u64 {
    left.iter().zip(right).map(|(l, r)| l.abs_diff(*r)).sum()
}

fn part_2(left: &[i64], right: &[i64]) -> i64 {
    let mut index = BTreeMap::new();
    for n in right {
        index.entry(n).and_modify(|count| *count += 1).or_insert(1);
    }

    left.iter()
        .map(|n| n * index.get(n).copied().unwrap_or_default())
        .sum()
}

fn main() -> Result<(), ParseIntError> {
    let (left, right) = parse_input(include_str!("../inputs/01.txt"))?;

    dbg!(part_1(&left, &right));
    dbg!(part_2(&left, &right));

    Ok(())
}
