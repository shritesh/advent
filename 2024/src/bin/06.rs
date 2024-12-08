use std::collections::HashSet;

#[derive(Debug, Clone, Copy)]
enum Direction {
    Up,
    Down,
    Left,
    Right,
}

type Coordinate = (usize, usize);
#[derive(Debug, Clone)]
struct Map {
    direction: Direction,
    position: Option<Coordinate>,
    obstructions: HashSet<Coordinate>,
    width: usize,
    height: usize,
}

impl Map {
    fn new(input: &str) -> Option<Self> {
        let mut direction = None;
        let mut position = None;
        let mut obstructions = HashSet::new();
        let mut width = 0;
        let mut height = 0;
        for (y, line) in input.lines().enumerate() {
            height += 1;
            width = line.len();
            for (x, c) in line.chars().enumerate() {
                let coordinate = (y, x);
                match c {
                    '.' => {}
                    '#' => {
                        obstructions.insert(coordinate);
                    }
                    '^' => {
                        direction = Some(Direction::Up);
                        position = Some(coordinate);
                    }
                    '>' => {
                        direction = Some(Direction::Right);
                        position = Some(coordinate);
                    }
                    'v' => {
                        direction = Some(Direction::Down);
                        position = Some(coordinate);
                    }
                    '<' => {
                        direction = Some(Direction::Left);
                        position = Some(coordinate);
                    }
                    _ => return None,
                }
            }
        }

        Some(Self {
            direction: direction?,
            position: position,
            obstructions,
            width,
            height,
        })
    }

    fn part_1(&self) -> usize {
        let positions: HashSet<_> = self.clone().collect();
        positions.len()
    }

    fn part_2(&self) -> usize {
        let mut count = 0;
        for y in 0..self.height {
            for x in 0..self.width {
                let pos = (y, x);
                if self.position == Some(pos) || self.obstructions.contains(&pos) {
                    continue;
                }

                let mut new_map = self.clone();
                new_map.obstructions.insert(pos);

                let mut positions = HashSet::new();
                let mut repeats = 0;
                for pos in new_map {
                    if positions.contains(&pos) {
                        repeats += 1;
                    } else {
                        repeats = 0;
                        positions.insert(pos);
                    }

                    // lol
                    if repeats == (self.width * self.height).isqrt() {
                        count += 1;
                        break;
                    }
                }
            }
        }

        count
    }
}

impl Iterator for Map {
    type Item = Coordinate;

    fn next(&mut self) -> Option<Self::Item> {
        let (y, x) = self.position?;

        let pos = match self.direction {
            Direction::Up => (y > 0).then(|| (y - 1, x)),
            Direction::Down => (y + 1 < self.height).then(|| (y + 1, x)),
            Direction::Left => (x > 0).then(|| (y, x - 1)),
            Direction::Right => (x + 1 < self.width).then(|| (y, x + 1)),
        };

        if let Some(forward) = pos {
            if self.obstructions.contains(&forward) {
                self.direction = match self.direction {
                    Direction::Up => Direction::Right,
                    Direction::Down => Direction::Left,
                    Direction::Left => Direction::Up,
                    Direction::Right => Direction::Down,
                };
            } else {
                self.position = Some(forward);
            }
        } else {
            self.position = None;
        }

        Some((y, x))
    }
}

pub fn main() {
    let map = Map::new(include_str!("../../inputs/06.txt")).expect("Invalid Input");
    dbg!(map.part_1());
    dbg!(map.part_2());
}

#[cfg(test)]
mod test {
    use crate::*;

    #[test]
    fn test_day_2() {
        let map = Map::new(include_str!("../../inputs/06.example.txt")).unwrap();
        assert_eq!(41, map.part_1());
        assert_eq!(6, map.part_2());
    }
}
