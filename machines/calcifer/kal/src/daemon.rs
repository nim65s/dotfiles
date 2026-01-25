use crate::{Mode, Schedule, Time};
use log::{debug, info};
use std::str::FromStr;
use zenoh::{Result, Session, handlers::FifoChannelHandler, pubsub::Subscriber, sample::Sample};

pub struct Daemon {
    schedule: Schedule,
    mode: Mode,
    session: Session,
    daemon_sub: Subscriber<FifoChannelHandler<Sample>>,
    temperature_sub: Subscriber<FifoChannelHandler<Sample>>,
    relay: gpio_cdev::LineHandle,
}

impl Daemon {
    pub async fn init(relay: gpio_cdev::LineHandle) -> Self {
        let mut mode = Mode::default();
        let mut config = zenoh::Config::default();
        config
            .insert_json5("connect/endpoints", "[\"tcp/127.0.0.1:7447\"]")
            .unwrap();
        let session = zenoh::open(config).await.unwrap();
        let replies = session.get("kal/cmnd/daemon/mode").await.unwrap();
        while let Ok(reply) = replies.recv_async().await {
            if let Ok(payload) = reply.result().unwrap().payload().try_to_string() {
                mode = payload.as_ref().into();
                info!("mode {}", mode);
            }
        }
        let daemon_sub = session
            .declare_subscriber("kal/cmnd/daemon/*")
            .await
            .unwrap();
        let temperature_sub = session
            .declare_subscriber("kal/tele/tasmota_43D8FD/temperature")
            .await
            .unwrap();

        Self {
            schedule: Schedule::default(),
            mode: mode,
            session,
            daemon_sub,
            temperature_sub,
            relay,
        }
    }

    pub async fn select(&mut self) {
        tokio::select! {
            reply = self.daemon_sub.recv_async() => {
                self.daemon_rep(reply).await
            }
            reply = self.temperature_sub.recv_async() => {
                self.temperature_rep(reply).await
            }
        }
    }

    async fn daemon_rep(&mut self, reply: Result<Sample>) {
        if let Ok(sample) = reply {
            match sample.key_expr().as_str() {
                ke if ke.ends_with("/mode") => {
                    if let Ok(payload) = sample.payload().try_to_string() {
                        self.mode = payload.as_ref().into();
                        info!("mode {}", self.mode);
                        if self.mode != Mode::Auto {
                            self.set_relay(self.mode == Mode::On).await;
                        }
                    }
                }
                ke if ke.ends_with("/insert") => {
                    if let Ok(payload) = sample.payload().try_to_string() {
                        let data: Vec<&str> = payload.split("|").collect();
                        if data.len() == 2 {
                            if let Ok(time_str) = u32::from_str(data[0]) {
                                if let Ok(time) = Time::from_minutes(time_str) {
                                    if let Ok(temperature) = f64::from_str(data[1]) {
                                        self.schedule.insert(time, temperature.into());
                                    }
                                }
                            }
                        }
                    }
                }
                ke if ke.ends_with("/remove") => {
                    if let Ok(payload) = sample.payload().try_to_string() {
                        if let Ok(time_str) = u32::from_str(&payload) {
                            if let Ok(time) = Time::from_minutes(time_str) {
                                self.schedule.remove(time);
                            }
                        }
                    }
                }
                _ => unimplemented!(),
            }
        }
    }

    async fn temperature_rep(&mut self, reply: Result<Sample>) {
        if let Ok(sample) = reply {
            if let Ok(payload) = sample.payload().try_to_string() {
                if let Ok(v) = payload.parse::<f64>() {
                    let t = v.into();
                    debug!("received {t}");
                    let h = match self.mode {
                        Mode::Auto => self.schedule.auto(Time::now(), t),
                        Mode::On => true,
                        Mode::Off => false,
                    };
                    self.set_relay(h).await;
                };
            };
        }
    }

    async fn set_relay(&mut self, v: bool) {
        let p = if v { "On" } else { "Off" };
        debug!("relay {p}");
        self.session.put("kal/tele/daemon/relay", p).await.unwrap();
        if let Err(e) = self.relay.set_value(if v { 1 } else { 0 }) {
            log::error!("cant set relay: {}", e);
        };
    }
}
