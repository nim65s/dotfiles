use chrono::Timelike;
use thiserror::Error;

#[derive(
    Debug,
    Copy,
    Clone,
    Eq,
    PartialEq,
    Ord,
    PartialOrd,
    derive_more::Add,
    derive_more::Sub,
    derive_more::Mul,
)]
pub struct Time(u32);

impl std::ops::Div for Time {
    type Output = f64;
    fn div(self, rhs: Time) -> Self::Output {
        (self.0 as f64) / (rhs.0 as f64)
    }
}

#[derive(Error, Debug)]
pub enum TimeError {
    #[error("Wrong time")]
    Wrong,
}

pub type TimeResult = Result<Time, TimeError>;

impl Time {
    pub const MIN: Self = Self(0);
    pub const MAX: Self = Self(24 * 60);

    pub fn now() -> Self {
        chrono::Local::now().into()
    }
    pub fn from_minutes(minutes: u32) -> TimeResult {
        if minutes <= 24 * 60 {
            Ok(Self(minutes))
        } else {
            Err(TimeError::Wrong)
        }
    }
    pub fn from_hours(hours: f64) -> TimeResult {
        if 0.0 <= hours && hours <= 24.0 {
            Ok(Self::from_hours_unchecked(hours))
        } else {
            Err(TimeError::Wrong)
        }
    }
    pub fn from_hours_unchecked(hours: f64) -> Time {
        Self((hours * 60.0) as u32)
    }
}

impl<T: Timelike> From<T> for Time {
    fn from(time: T) -> Self {
        Self(time.minute() + time.hour() * 60)
    }
}

impl std::fmt::Display for Time {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{:02}H{:02}", self.0 / 60, self.0 % 60)
    }
}
