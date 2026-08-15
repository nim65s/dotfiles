from enum import Enum

import zenoh


class Mode(Enum):
    ON = "On"
    OFF = "Off"
    AUTO = "Auto"

    def __bool__(self):
        return self == Mode.ON

    @classmethod
    def from_nullable_bool(cls, value: None | bool):
        match value:
            case True:
                return cls.ON
            case False:
                return cls.OFF
            case None:
                return cls.AUTO

    @classmethod
    def from_str(cls, value: str):
        match value.lower():
            case "on" | "true" | "1":
                return cls.ON
            case "off" | "false" | "0":
                return cls.OFF
            case _:
                return cls.AUTO

    @classmethod
    def from_sample(cls, sample: zenoh.Sample):
        return cls.from_str(sample.payload.to_string())

    def to_string(self) -> str:
        return self.value
