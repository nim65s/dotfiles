import {
  Chart,
  LineController,
  LineElement,
  PointElement,
  LinearScale,
  CategoryScale,
  Tooltip,
  Legend,
} from "chart.js";
import DragDataPlugin from 'chartjs-plugin-dragdata';

// Register chart.js components
Chart.register(LineController, LineElement, PointElement, LinearScale, CategoryScale, Tooltip, Legend, DragDataPlugin);

function minutesToHHMM(t) {
  const hours = Math.floor(t / 60);
  const minutes = t % 60;

  return `${String(hours).padStart(2, "0")}:${String(minutes).padStart(2, "0")}`;
}

function minutesToHHMMTooltip(l) {
  return minutesToHHMM(l[0].parsed.x);
}

class KalScheduleCard extends HTMLElement {
  setConfig(config) {
    if (!config.entity) throw new Error("You must define an entity");
    this.config = config;
  }

  set hass(hass) {
    const entity = hass.states[this.config.entity];
    if (!entity || !entity.attributes.points) {
      if (!this._initialized) {
        this._initialized = true;
        hass.callService("mqtt", "publish", {
          topic: "kal/cmnd/daemon/get",
          payload: "",
          qos: 0,
        });
      }
      return;
    }

    const points = Object.entries(entity.attributes.points).map(([min, temp]) => ({ x: parseInt(min), y: temp }));

    const canvas = document.createElement("canvas");
    canvas.style.width = "100%";
    canvas.style.height = "400px";

    const cfg = {
      type: "line",
      data: {
        datasets: [
          {
            label: "Temperature (°C)",
            data: points,
            borderColor: "red",
          },
        ],
      },
      options: {
        animation: false,
        animations: {
          colors: false,
          x: false,
        },
        transitions: {
          active: {
            animation: {
              duration: 0,
            },
          },
        },

        scales: {
          x: {
            type: "linear",
            max: 24 * 60,
            ticks: {
              callback: minutesToHHMM,
            },
          },
          y: {
            min: 12,
            max: 20,
          },
        },

        plugins: {
          legend: { display: false },
          tooltip: {
            callbacks: {
              title: minutesToHHMMTooltip,
            },
          },
          dragData: {
            round: 1,
            showTooltip: true,
          }
        },
      },
    };

    if (this.chart) {
      this.chart.destroy();
      this.innerHTML = "";
    }
    this.appendChild(canvas);
    this.chart = new Chart(canvas.getContext("2d"), cfg);
  }

  getCardSize() {
    return 3;
  }
}

customElements.define("kal-schedule-card", KalScheduleCard);
