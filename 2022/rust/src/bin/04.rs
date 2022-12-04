static INPUT: &str = if cfg!(debug_assertions) {
    include_str!("../../../04_example.txt")
} else {
    include_str!("../../../04.txt")
};

fn main() {
    let mut full = 0;
    let mut partial = 0;
    for line in INPUT.lines() {
        let nums: [u32; 4] = line
            .split(|c| c == ',' || c == '-')
            .map(|s| s.parse())
            .collect::<Result<Vec<_>, _>>()
            .expect("invalid input")
            .try_into()
            .expect("expected to have 4 numbers in a line");

        let first = nums[0]..=nums[1];
        let second = nums[2]..=nums[3];

        if (second.contains(first.start()) && second.contains(first.end()))
            || (first.contains(second.start()) && first.contains(second.end()))
        {
            full += 1;
        }

        if second.contains(first.start())
            || second.contains(first.end())
            || first.contains(second.start())
            || first.contains(second.end())
        {
            partial += 1;
        }
    }

    println!("Part 1: {full}");
    println!("Part 2: {partial}");
}
