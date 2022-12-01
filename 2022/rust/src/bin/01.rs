static INPUT: &str = if cfg!(debug_assertions) {
    include_str!("../../../01_example.txt")
} else {
    include_str!("../../../01.txt")
};

fn main() {
    let mut calories = INPUT
        .split("\n\n")
        .map(|group| {
            group
                .split('\n')
                .map(|line| line.parse::<u32>().unwrap())
                .sum()
        })
        .collect::<Vec<u32>>();
    calories.sort_by(|a, b| b.cmp(a)); // descending sort

    println!("Part 1: {}", calories[0]);
    println!("Part 2: {}", calories[0] + calories[1] + calories[2]);
}
