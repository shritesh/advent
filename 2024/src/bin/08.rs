use std::collections::{HashMap, HashSet};

pub fn main() {
    let input = include_str!("../../inputs/08.txt");

    let mut width = 0;
    let mut height = 0;

    let mut map = HashMap::new();

    for (y, line) in input.lines().enumerate() {
        height += 1;
        width = line.len() as i64;

        for (x, c) in line.chars().enumerate() {
            if c != '.' {
                let coordinate = (y as i64, x as i64);
                map.entry(c)
                    .and_modify(|v: &mut Vec<(i64, i64)>| v.push(coordinate))
                    .or_insert(vec![coordinate]);
            }
        }
    }

    let mut antinodes = HashSet::new();

    for nodes in map.values() {
        if nodes.len() == 1 {
            continue;
        }

        for i in &nodes[..] {
            for j in &nodes[1..] {
                if i != j {
                    let (y1, x1) = i;
                    let (y2, x2) = j;
                    let (dy, dx) = (y2 - y1, x2 - x1);
                    for (y, x) in [(y1 - dy, x1 - dx), (y2 + dy, x2 + dx)] {
                        if (0..height).contains(&y) && (0..width).contains(&x) {
                            antinodes.insert((y, x));
                        }
                    }
                }
            }
        }
    }

    dbg!(antinodes.len());
}
