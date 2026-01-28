use itertools::Itertools;
use log::debug;
use std::collections::BTreeMap;

use crate::{Temperature, Time};

#[derive(Debug)]
pub struct Schedule {
    points: BTreeMap<Time, Temperature>,
}

impl Default for Schedule {
    fn default() -> Self {
        Self {
            points: BTreeMap::from([
                (Time::from_hours_unchecked(0.0), 14.0.into()),
                (Time::from_hours_unchecked(5.0), 15.5.into()),
                (Time::from_hours_unchecked(7.0), 17.0.into()),
                (Time::from_hours_unchecked(22.0), 17.0.into()),
                (Time::from_hours_unchecked(24.0), 14.0.into()),
            ]),
        }
    }
}

impl Schedule {
    pub fn new(temperature: Temperature) -> Self {
        Self {
            points: BTreeMap::from([
                (Time::from_hours_unchecked(0.), temperature),
                (Time::from_hours_unchecked(24.), temperature),
            ]),
        }
    }
    pub fn insert(&mut self, time: Time, temperature: Temperature) {
        self.points.insert(time, temperature);
    }
    pub fn remove(&mut self, time: Time) {
        // can't remove 0:00 and 24:00
        if Time::MIN < time && time < Time::MAX {
            self.points.remove(&time);
        }
    }

    pub fn auto(&self, t: Time, v: Temperature) -> bool {
        debug!("current: {v} @ {t}");
        for ((t1, v1), (t2, v2)) in self.points.iter().tuple_windows() {
            if *t1 <= t && t <= *t2 {
                debug!("segment: {v1} @ {t1} -> {v2} @ {t2}");
                let ratio = (t - *t1) / (*t2 - *t1);
                return v < *v1 + (*v2 - *v1) * ratio;
            }
        }
        unreachable!()
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_schedule() {
        env_logger::init();
        let s = Schedule::default();
        assert!(s.auto(Time::from_hours_unchecked(0.0), 13.0.into()));
        assert!(!s.auto(Time::from_hours_unchecked(0.0), 15.0.into()));
        assert!(s.auto(Time::from_hours_unchecked(5.0), 15.0.into()));
        assert!(!s.auto(Time::from_hours_unchecked(5.0), 16.0.into()));
        assert!(!s.auto(Time::from_hours_unchecked(5.1), 16.0.into()));
        assert!(s.auto(Time::from_hours_unchecked(7.9), 16.0.into()));
        assert!(s.auto(Time::from_hours_unchecked(24.0), 13.0.into()));
        assert!(!s.auto(Time::from_hours_unchecked(24.0), 15.0.into()));
    }
}
