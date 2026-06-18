import { Controller } from "@hotwired/stimulus"
import Chart from "chart.js/auto"
import { Colors } from 'chart.js';
import annotationPlugin from 'chartjs-plugin-annotation';

export default class extends Controller {
  static targets = ["canvas"]
  static values = {
    dataset: String,
    emptychart: String,
    charttype: String
  }

  connect() {
    Chart.register(annotationPlugin);
    Chart.register(Colors);

    // Follow the active color mode: pull text/grid colors from the theme's
    // CSS variables so the chart stays readable in both light and dark mode.
    // Only set the text color globally — Chart.defaults.borderColor would also
    // recolor the dataset lines, so the grid color is applied per scale instead.
    const rootStyles = getComputedStyle(document.documentElement);
    const fontColor = rootStyles.getPropertyValue("--bs-body-color").trim();
    const gridColor = rootStyles.getPropertyValue("--bs-border-color").trim();
    Chart.defaults.color = fontColor;

    const ctx = this.canvasTarget.getContext("2d");
    const chartData = JSON.parse(this.datasetValue);

    const isEmpty = !chartData;

    const options = {
      responsive: true,
      scales: {
        y: {
          beginAtZero: true,
          grid: { color: gridColor }
        },
        x: {
          grid: { color: gridColor }
        }
      }
    };

    if (isEmpty) {
      options.plugins = {
        annotation: {
          annotations: {
            noData: {
              type: 'label',
              content: [ this.emptychartValue ],
              position: {
                x: '50%',
                y: '50%'
              },
              font: {
                size: 32,
                weight: 'bold'
              },
              color: fontColor,
              textAlign: 'center'
            }
          }
        }
      };
    }

    this.chart = new Chart(ctx, {
      type: this.charttypeValue.toLowerCase(),
      data: chartData,
      options: options
    });
  }

  disconnect() {
    this.chart?.destroy()
  }
}
