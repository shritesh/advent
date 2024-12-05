#![feature(array_windows)]

use std::{cmp::Ordering, ops::Not};

type Input = (Vec<(u32, u32)>, Vec<Vec<u32>>);

pub fn parse(input: &str) -> Option<Input> {
    let (orderings, updates) = input.split_once("\n\n")?;

    let orderings = orderings
        .lines()
        .map(|s| {
            let (page, dep) = s.split_once("|")?;
            Some((page.parse().ok()?, dep.parse().ok()?))
        })
        .collect::<Option<Vec<(u32, u32)>>>()?;

    let updates = updates
        .lines()
        .map(|line| line.split(",").map(|s| s.parse().ok()).collect())
        .collect::<Option<Vec<Vec<u32>>>>()?;

    Some((orderings, updates))
}

pub fn part_1((orderings, updates): &Input) -> u32 {
    updates
        .iter()
        .filter_map(|u| {
            u.array_windows()
                .all(|[a, b]| !orderings.contains(&(*b, *a)))
                .then(|| u[u.len() / 2])
        })
        .sum()
}
pub fn part_2((orderings, updates): &Input) -> u32 {
    updates
        .iter()
        .filter_map(|u| {
            u.array_windows()
                .all(|[a, b]| !orderings.contains(&(*b, *a)))
                .not()
                .then(|| {
                    let mut v = u.clone();
                    v.sort_by(|a, b| {
                        if orderings.contains(&(*b, *a)) {
                            Ordering::Greater
                        } else {
                            Ordering::Less
                        }
                    });
                    v[v.len() / 2]
                })
        })
        .sum()
}

pub fn main() {
    let input = parse(include_str!("../../inputs/05.txt")).expect("unable to parse input");

    dbg!(part_1(&input));
    dbg!(part_2(&input));
}

#[cfg(test)]
mod test {
    use crate::*;

    #[test]
    fn test_day_2() {
        let input = parse(include_str!("../../inputs/05.example.txt")).unwrap();
        assert_eq!(143, part_1(&input));
        assert_eq!(123, part_2(&input));
    }
}
