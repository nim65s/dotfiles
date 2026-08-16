use anyhow::Result;
use gpio_cdev::{Chip, LineRequestFlags};

use kal::Daemon;

#[tokio::main]
async fn main() -> Result<()> {
    env_logger::init();

    log::info!("Init...");

    let mut chip = Chip::new("/dev/gpiochip0")?;
    log::debug!("chip: {chip:?}");
    let relay = chip
        .get_line(17)?
        .request(LineRequestFlags::OUTPUT, 0, "kal")?;
    log::debug!("relay: {relay:?}");

    let mut config = zenoh::Config::default();
    config
        .insert_json5("connect/endpoints", "[\"tcp/127.0.0.1:7447\"]")
        .unwrap();
    let session = zenoh::open(config).await.unwrap();

    let mut daemon = Daemon::init(relay, session).await;
    log::info!("Start !");
    loop {
        daemon.select().await;
    }
}
