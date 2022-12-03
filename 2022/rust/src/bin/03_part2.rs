use std::collections::HashSet;

static INPUT: &str = if cfg!(debug_assertions) {
    include_str!("../../../03_example.txt")
} else {
    include_str!("../../../03.txt")
};

fn main() {
    let sets = INPUT
        .lines()
        .map(|line| line.chars().collect::<HashSet<char>>())
        .collect::<Vec<_>>();

    let sum: u32 = sets
        .chunks(3)
        .map(|group| {
            if group.len() != 3 {
                panic!("groups must be of len 3")
            }

            let common = {
                let firsttwo = group[0]
                    .intersection(&group[1])
                    .copied()
                    .collect::<HashSet<char>>();

                firsttwo
                    .intersection(&group[2])
                    .copied()
                    .collect::<Vec<char>>()
            }; // ugly hack for multiple set intersection

            if common.len() != 1 {
                panic!("common len is not 1");
            }

            char_to_priority(common[0])
        })
        .sum();

    println!("{sum}");
}

fn char_to_priority(c: char) -> u32 {
    match c {
        'a'..='z' => c as u32 - 'a' as u32 + 1,
        'A'..='Z' => c as u32 - 'A' as u32 + 27,
        _ => panic!("invalid char"),
    }
}
