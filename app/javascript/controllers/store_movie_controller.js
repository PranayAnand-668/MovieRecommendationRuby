document.addEventListener("DOMContentLoaded", () => {
  const movieElements = document.querySelectorAll(".movie-item"); // Add a class to your movie elements
  movieElements.forEach((movie) => {
    movie.addEventListener("click", () => {
      const movieTitle = movie.dataset.title; // Ensure you set data attributes in your HTML
      fetch("/movies/save", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
        },
        body: JSON.stringify({ title: movieTitle }),
      })
        .then((response) => response.json())
        .then((data) => {
          console.log(data.message); // Handle success response
        })
        .catch((error) => {
          console.error("Error saving movie:", error);
        });
    });
  });
});
