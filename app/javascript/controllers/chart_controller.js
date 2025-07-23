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

    const ctx = this.canvasTarget.getContext("2d");
    const chartData = JSON.parse(this.datasetValue);

    const isEmpty = !chartData;

    const options = {
      responsive: true,
      scales: {
        y: {
          beginAtZero: true
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
              color: 'gray',
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
