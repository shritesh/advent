use std::collections::{HashMap, HashSet};

struct Map {
    width: i64,
    height: i64,
    nodes: Vec<Vec<(i64, i64)>>,
}

impl Map {
    fn new(input: &str) -> Self {
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

        Self {
            width,
            height,
            nodes: map.into_values().collect(),
        }
    }

    fn part_1(&self) -> usize {
        let mut antinodes = HashSet::new();

        for nodes in &self.nodes {
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
                            if (0..self.height).contains(&y) && (0..self.width).contains(&x) {
                                antinodes.insert((y, x));
                            }
                        }
                    }
                }
            }
        }

        antinodes.len()
    }

    fn part_2(&self) -> usize {
        let mut antinodes = HashSet::new();

        for nodes in &self.nodes {
            if nodes.len() == 1 {
                continue;
            }

            for i in &nodes[..] {
                for j in &nodes[1..] {
                    if i != j {
                        let (y1, x1) = i;
                        let (y2, x2) = j;
                        let (dy, dx) = (y2 - y1, x2 - x1);

                        let (mut y, mut x) = (*y1, *x1);
                        while (0..self.height).contains(&y) && (0..self.width).contains(&x) {
                            antinodes.insert((y, x));
                            y -= dy;
                            x -= dx;
                        }

                        (y, x) = (*y2, *x2);
                        while (0..self.height).contains(&y) && (0..self.width).contains(&x) {
                            antinodes.insert((y, x));
                            y += dy;
                            x += dx;
                        }
                    }
                }
            }
        }

        antinodes.len()
    }
}

pub fn main() {
    let map = Map::new(include_str!("../../inputs/08.txt"));

    dbg!(map.part_1());
    dbg!(map.part_2());
}

#[cfg(test)]
mod test {
    use crate::*;

    #[test]
    fn test_day_2() {
        let map = Map::new(include_str!("../../inputs/08.example.txt"));
        assert_eq!(14, map.part_1());
        assert_eq!(34, map.part_2());
    }
}
