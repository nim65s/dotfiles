use anyhow::Result;
use gpio_cdev::{Chip, LineRequestFlags};

use kal::Daemon;

#[tokio::main]
async fn main() -> Result<()> {
    env_logger::init();

    let mut chip = Chip::new("/dev/gpiochip0")?;
    let relay = chip
        .get_line(17)?
        .request(LineRequestFlags::OUTPUT, 0, "kal")?;

    println!("Hello, world!");

    let mut daemon = Daemon::init(relay).await;
    loop {
        daemon.select().await;
    }
}
