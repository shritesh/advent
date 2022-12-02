use std::str::FromStr;

static INPUT: &str = if cfg!(debug_assertions) {
    include_str!("../../../02_example.txt")
} else {
    include_str!("../../../02.txt")
};

#[derive(PartialEq, Clone, Copy)]
enum Move {
    Rock,
    Paper,
    Scissor,
}

enum Outcome {
    Win,
    Loss,
    Draw,
}

struct Round {
    opponent: Move,
    outcome: Outcome,
}

impl Round {
    fn score(&self) -> u32 {
        let player = match (&self.outcome, self.opponent) {
            (Outcome::Win, Move::Rock) => Move::Paper,
            (Outcome::Win, Move::Paper) => Move::Scissor,
            (Outcome::Win, Move::Scissor) => Move::Rock,
            (Outcome::Loss, Move::Rock) => Move::Scissor,
            (Outcome::Loss, Move::Paper) => Move::Rock,
            (Outcome::Loss, Move::Scissor) => Move::Paper,
            (Outcome::Draw, m) => m,
        };

        let mut total = match player {
            Move::Rock => 1,
            Move::Paper => 2,
            Move::Scissor => 3,
        };

        total += match self.outcome {
            Outcome::Win => 6,
            Outcome::Loss => 0,
            Outcome::Draw => 3,
        };

        total
    }
}

impl FromStr for Round {
    type Err = &'static str;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let Some((opp, out)) = s.split_once(' ') else {
            return Err("invalid line format");
        };

        let opponent = match opp {
            "A" => Move::Rock,
            "B" => Move::Paper,
            "C" => Move::Scissor,
            _ => return Err("invalid opponent string"),
        };

        let outcome = match out {
            "X" => Outcome::Loss,
            "Y" => Outcome::Draw,
            "Z" => Outcome::Win,
            _ => return Err("invalid outcome string"),
        };

        Ok(Round { opponent, outcome })
    }
}

fn main() {
    let score: u32 = INPUT
        .lines()
        .map(|l| l.parse::<Round>().unwrap().score())
        .sum();
    println!("{score}");
}
