type Input = Vec<Vec<char>>;

fn parse(input: &str) -> Input {
    input.lines().map(|s| s.chars().collect()).collect()
}

fn safe_get(input: &Input, row: isize, col: isize) -> Option<char> {
    if row >= 0 && row < input.len() as isize {
        let line = &input[row as usize];
        if col >= 0 && col < line.len() as isize {
            return Some(line[col as usize]);
        }
    }

    None
}

fn part_1(input: &Input) -> usize {
    let mut count = 0;

    for (row, line) in input.iter().enumerate() {
        for (col, char) in line.iter().enumerate() {
            if *char == 'X' {
                for dr in -1isize..=1 {
                    'col: for dc in -1isize..=1 {
                        if dr == 0 && dc == 0 {
                            continue;
                        }

                        let (mut r, mut c) = (row as isize, col as isize);
                        for ch in ['M', 'A', 'S'] {
                            r += dr;
                            c += dc;

                            if safe_get(input, r, c) != Some(ch) {
                                continue 'col;
                            }
                        }

                        count += 1;
                    }
                }
            }
        }
    }

    count
}

fn part_2(input: &Input) -> usize {
    let mut count = 0;

    for (row, line) in input.iter().enumerate() {
        for (col, char) in line.iter().enumerate() {
            if *char == 'M' {
                for dr in [-1isize, 1] {
                    for dc in [-1isize, 1] {
                        let r = row as isize + dr;
                        let c = col as isize + dc;
                        if safe_get(&input, r, c) == Some('A')
                            && safe_get(&input, r + dr, c + dc) == Some('S')
                        {
                            let first = safe_get(&input, r + dr, c + (dc * -1));
                            let second = safe_get(&input, r + (-1 * dr), c + dc);
                            if (first == Some('M') && second == Some('S'))
                                || (first == Some('S') && second == Some('M'))
                            {
                                count += 1;
                            }
                        }
                    }
                }
            }
        }
    }

    count / 2
}
fn main() {
    let input = parse(include_str!("../../inputs/04.txt"));

    dbg!(part_1(&input));
    dbg!(part_2(&input));
}

#[cfg(test)]
mod test {
    use crate::*;

    #[test]
    fn test_day_2() {
        let input = parse(include_str!("../../inputs/04.example.txt"));
        assert_eq!(18, part_1(&input));
        assert_eq!(9, part_2(&input));
    }
}
