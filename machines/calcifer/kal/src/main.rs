use std::{thread, time};

use anyhow::Result;
use gpio_cdev::{Chip, LineRequestFlags};

#[tokio::main]
async fn main() -> Result<()> {
    let mut chip = Chip::new("/dev/gpiochip0")?;
    let output = chip
        .get_line(17)?
        .request(LineRequestFlags::OUTPUT, 0, "kal")?;

    println!("Hello, world!");

    loop {
        output.set_value(1)?;
        thread::sleep(time::Duration::from_secs(1));
        output.set_value(0)?;
        thread::sleep(time::Duration::from_secs(1));
    }
}
