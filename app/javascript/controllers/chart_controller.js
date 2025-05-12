import { Controller } from "@hotwired/stimulus"
import Chart from "chart.js/auto"

export default class extends Controller {
  static targets = ["canvas"]
  static values = {
    dataset: String
  }

  connect() {
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
