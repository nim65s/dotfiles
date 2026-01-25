#[derive(
    Debug,
    Copy,
    Clone,
    PartialEq,
    PartialOrd,
    derive_more::Add,
    derive_more::Sub,
    derive_more::Mul,
    derive_more::From,
)]
pub struct Temperature(f64);

impl std::fmt::Display for Temperature {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}°C", self.0)
    }
}
