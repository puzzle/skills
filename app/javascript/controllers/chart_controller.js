import { Controller } from "@hotwired/stimulus"
import Chart from "chart.js/auto"
import { Colors } from 'chart.js';

export default class extends Controller {
  static targets = ["canvas"]
  static values = {
    dataset: String
  }

  connect() {
    Chart.register(Colors);

    const ctx = this.canvasTarget.getContext("2d")

    const chartData = JSON.parse(this.datasetValue)

    this.chart = new Chart(ctx, {
      type: 'line',
      data: chartData,
      options: {
        responsive: true,
        scales: {
          y: {
            beginAtZero: true
          }
        }
      }
    })
  }

  disconnect() {
    this.chart?.destroy()
  }
}
