#[derive(Debug, Clone, Copy, PartialEq)]
pub enum Mode {
    Auto,
    On,
    Off,
}

impl Default for Mode {
    fn default() -> Self {
        Self::Auto
    }
}

impl From<Option<bool>> for Mode {
    fn from(value: Option<bool>) -> Self {
        match value {
            Some(true) => Self::On,
            Some(false) => Self::Off,
            None => Self::Auto,
        }
    }
}

impl From<&str> for Mode {
    fn from(value: &str) -> Self {
        match value {
            "ON" | "On" | "on" | "TRUE" | "True" | "true" | "1" => Self::On,
            "OFF" | "Off" | "off" | "FALSE" | "False" | "false" | "0" => Self::Off,
            _ => Self::Auto,
        }
    }
}

impl Mode {
    pub fn as_str(&self) -> &str {
        match self {
            Self::On => "On",
            Self::Off => "Off",
            Self::Auto => "Auto",
        }
    }
}

impl std::fmt::Display for Mode {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}", self.as_str())
    }
}
