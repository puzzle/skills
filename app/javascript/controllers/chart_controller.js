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

    this.chartData = JSON.parse(this.datasetValue);
    this.buildChart();

    // The theme controller resolves the color mode client-side, so a chart built
    // under one theme keeps its old colors when the user toggles. Rebuild it with
    // the new theme colors instead of requiring a page reload.
    this.themeListener = () => this.buildChart();
    document.addEventListener("theme:changed", this.themeListener);
  }

  disconnect() {
    document.removeEventListener("theme:changed", this.themeListener);
    this.chart?.destroy()
  }

  // Build (or rebuild) the chart using the active color mode: pull text/grid
  // colors from the theme's CSS variables so it stays readable in light and dark.
  // Only the text color is set globally — Chart.defaults.borderColor would also
  // recolor the dataset lines, so the grid color is applied per scale instead.
  buildChart() {
    this.chart?.destroy();

    const rootStyles = getComputedStyle(document.documentElement);
    const fontColor = rootStyles.getPropertyValue("--bs-body-color").trim();
    const gridColor = rootStyles.getPropertyValue("--bs-border-color").trim();
    Chart.defaults.color = fontColor;

    const ctx = this.canvasTarget.getContext("2d");
    const isEmpty = !this.chartData;

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
      data: this.chartData,
      options: options
    });
  }
}
