use std::collections::HashSet;

static INPUT: &str = if cfg!(debug_assertions) {
    include_str!("../../../03_example.txt")
} else {
    include_str!("../../../03.txt")
};

fn main() {
    let sum: u32 = INPUT
        .lines()
        .map(|line| {
            let (first, second) = line.split_at(line.len() / 2);

            let first_set: HashSet<char> = first.chars().collect();
            let second_set: HashSet<char> = second.chars().collect();

            first_set
                .intersection(&second_set)
                .map(char_to_priority)
                .sum::<u32>()
        })
        .sum();

    println!("{sum}");
}

fn char_to_priority(c: &char) -> u32 {
    match c {
        'a'..='z' => *c as u32 - 'a' as u32 + 1,
        'A'..='Z' => *c as u32 - 'A' as u32 + 27,
        _ => panic!("invalid char"),
    }
}
