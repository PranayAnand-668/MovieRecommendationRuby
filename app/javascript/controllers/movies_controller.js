import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["recommendations"];

  connect() {
    console.log("Movies controller connected");
  }

  fetchRecommendations() {
    const recommendationsDiv = this.recommendationsTarget;

    fetch("/movies/fetch_recommendations", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
      },
      body: JSON.stringify({ location: "New York" }), // Replace with dynamic location if needed
    })
      .then((response) => response.json())
      .then((data) => {
        if (data.error) {
          recommendationsDiv.innerHTML = `<p class="text-red-500">Error: ${data.error}</p>`;
        } else {
          recommendationsDiv.innerHTML = `
            <ul class="list-disc">
              ${data.recommendations.map((movie) => `<li>${movie}</li>`).join("")}
            </ul>
          `;
        }
      })
      .catch((error) => {
        recommendationsDiv.innerHTML = `<p class="text-red-500">Error: ${error.message}</p>`;
      });
  }
}
