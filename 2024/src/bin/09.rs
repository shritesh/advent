type Input = Vec<Option<usize>>;
fn parse(input: &str) -> Input {
    input
        .chars()
        .map(|c| c as usize - '0' as usize)
        .enumerate()
        .flat_map(|(i, n)| vec![(i % 2 == 0).then_some(i / 2); n])
        .collect()
}

fn part_1(input: &Input) -> usize {
    let mut blocks = input.to_vec();

    let mut j = blocks.len();
    for i in 0..blocks.len() {
        if blocks[i].is_some() {
            continue;
        }

        if let Some(n) = (i + 1..j).rev().find(|n| blocks[*n].is_some()) {
            j = n;
            blocks.swap(i, j);
        }
    }

    blocks
        .iter()
        .enumerate()
        .filter_map(|(i, n)| n.map(|x| x * i))
        .sum()
}

fn part_2(input: &Input) -> usize {
    let mut blocks = input.to_vec();

    let mut i = blocks.len();
    while i > 0 {
        if let Some(id) = blocks[i - 1] {
            let n = (0..i).rev().take_while(|j| blocks[*j] == Some(id)).count();
            let j = i - n;

            let mut k = 0;
            while k < j {
                if blocks[k].is_some() {
                    k += 1;
                } else {
                    let m = (k..j).take_while(|l| blocks[*l].is_none()).count();

                    if m >= n {
                        for c in 0..n {
                            blocks[k + c] = Some(id);
                            blocks[j + c] = None;
                        }
                        break;
                    }

                    k += m;
                }
            }

            i = j;
        } else {
            i -= 1;
        }
    }

    blocks
        .iter()
        .enumerate()
        .filter_map(|(i, n)| n.map(|x| x * i))
        .sum()
}

pub fn main() {
    let input = parse(include_str!("../../inputs/09.txt"));

    dbg!(part_1(&input));
    dbg!(part_2(&input));
}

#[cfg(test)]
mod test {
    use crate::*;

    #[test]
    fn test_day_2() {
        let input = parse(include_str!("../../inputs/09.example.txt"));
        assert_eq!(1928, part_1(&input));
        assert_eq!(2858, part_2(&input));
    }
}
