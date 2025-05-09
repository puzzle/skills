import { Controller } from "@hotwired/stimulus"
import Chart from "chart.js/auto"

export default class extends Controller {
  static targets = ["canvas"]

  connect() {
    const ctx = this.canvasTarget.getContext("2d")

    this.chart = new Chart(ctx, {
      type: 'line',
      data: {
        labels: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
        datasets: [
          {
            label: 'Azubi',
            data: [5, 10, 7, 13, 16, 20, 6, 2, 13, 22, 25, 21],
            backgroundColor: 'red',
            borderColor: 'red',
            fill: false,
            tension: 0.1
          },
          {
            label: 'Junior',
            data: [10, 11, 12, 6, 14, 15, 16, 17, 18, 9, 8, 7],
            backgroundColor: 'blue',
            borderColor: 'blue',
            fill: false,
            tension: 0.1
          },
          {
            label: 'Senior',
            data: [13, 15, 19, 12, 22, 8, 4, 16, 7, 1, 18, 19],
            backgroundColor: 'green',
            borderColor: 'green',
            fill: false,
            tension: 0.1
          },
          {
            label: 'Professionell',
            data: [1, 2, 3, 8, 10, 10, 14, 9, 15, 22, 22, 25],
            backgroundColor: 'black',
            borderColor: 'black',
            fill: false,
            tension: 0.1
          },
          {
            label: 'Expert',
            data: [18, 22, 23, 20, 18, 25, 19, 15, 13, 14, 9, 5],
            backgroundColor: 'purple',
            borderColor: 'purple',
            fill: false,
            tension: 0.1
          }
        ]
      },
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
