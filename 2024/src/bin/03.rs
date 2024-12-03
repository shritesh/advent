use regex::Regex;

pub fn main() {
    let input = include_str!("../../inputs/03.txt");

    dbg!(part_1(&input));
    dbg!(part_2(&input));
}
fn part_1(input: &str) -> u32 {
    Regex::new(r"mul\((\d{1,3}),(\d{1,3})\)")
        .unwrap()
        .captures_iter(input)
        .map(|c| {
            c.iter()
                .skip(1) // skip `mul(*, *)`
                .map(|g| g.unwrap().as_str().parse::<u32>().unwrap()) // checked by regex above
                .product::<u32>()
        })
        .sum()
}

fn part_2(input: &str) -> u32 {
    let mut enabled = true;
    let mut total = 0;

    for cap in Regex::new(r"mul\((\d{1,3}),(\d{1,3})\)|do\(\)|don't\(\)")
        .unwrap()
        .captures_iter(input)
    {
        let mut iter = cap.iter();
        match iter.next().unwrap().unwrap().as_str() {
            "do()" => enabled = true,
            "don't()" => enabled = false,
            _ if enabled => {
                total += iter
                    .map(|g| g.unwrap().as_str().parse::<u32>().unwrap()) // checked by regex above
                    .product::<u32>()
            }
            _ => {}
        };
    }
    total
}

#[cfg(test)]
mod test {
    use crate::*;

    #[test]
    fn test_day_2() {
        assert_eq!(161, part_1(include_str!("../../inputs/03.example.1.txt")));
        assert_eq!(48, part_2(include_str!("../../inputs/03.example.2.txt")));
    }
}
