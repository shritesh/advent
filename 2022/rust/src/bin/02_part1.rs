use std::str::FromStr;

static INPUT: &str = if cfg!(debug_assertions) {
    include_str!("../../../02_example.txt")
} else {
    include_str!("../../../02.txt")
};

#[derive(PartialEq)]
enum Move {
    Rock,
    Paper,
    Scissor,
}

struct Round {
    opponent: Move,
    player: Move,
}

impl Round {
    fn score(&self) -> u32 {
        let mut total = match self.player {
            Move::Rock => 1,
            Move::Paper => 2,
            Move::Scissor => 3,
        };

        total += match (&self.player, &self.opponent) {
            (Move::Rock, Move::Scissor) => 6,
            (Move::Scissor, Move::Paper) => 6,
            (Move::Paper, Move::Rock) => 6,
            (p, o) if p == o => 3, // draw
            (_, _) => 0,           // loss
        };

        total
    }
}

impl FromStr for Round {
    type Err = &'static str;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let Some((o, p)) = s.split_once(' ') else {
            return Err("invalid line format");
        };

        let opponent = match o {
            "A" => Move::Rock,
            "B" => Move::Paper,
            "C" => Move::Scissor,
            _ => return Err("invalid opponent string"),
        };

        let player = match p {
            "X" => Move::Rock,
            "Y" => Move::Paper,
            "Z" => Move::Scissor,
            _ => return Err("invalid opponent string"),
        };

        Ok(Round { opponent, player })
    }
}

fn main() {
    let score: u32 = INPUT
        .lines()
        .map(|l| l.parse::<Round>().unwrap().score())
        .sum();
    println!("{score}");
}
