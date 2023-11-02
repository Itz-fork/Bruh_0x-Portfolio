// Author: Hirusha Himath (https://github.com/Itz-fork)
// Repo: https://github.com/Itz-fork/itz-fork.github.io

// Vanta.js configuration
VANTA.HALO({
  el: "#halo",
  mouseControls: true,
  touchControls: true,
  gyroControls: false,
  minHeight: 200.0,
  minWidth: 200.0,
  baseColor: "#f11a7b",
  backgroundColor: "#191825",
  size: window.innerWidth > 768 ? 1.2 : 0.8,
});

// Github stats
async function getStats() {
  // Fetch basic user stats
  let ftd = await (await fetch("https://api.github.com/users/Itz-fork")).json();
  let totalRepos = ftd.public_repos;
  // Count total stars of a user
  let totalStars = 0;
  if (totalRepos > 100) {
    let nos = totalRepos;
    while (nos > 100) {
      (
        await (
          await fetch(
            "https://api.github.com/users/Itz-fork/repos?type=owner&per_page=100"
          )
        ).json()
      ).filter((obj) => (totalStars += obj.stargazers_count));
      nos = nos - 100;
    }
    (
      await (
        await fetch(
          "https://api.github.com/users/Itz-fork/repos?type=owner&per_page=100"
        )
      ).json()
    ).filter((obj) => (totalStars += obj.stargazers_count));
  } else {
    (
      await (
        await fetch(
          "https://api.github.com/users/Itz-fork/repos?type=owner&per_page=100"
        )
      ).json()
    ).filter((obj) => (totalStars += obj.stargazers_count));
  }
  // Assigning fetched data respective elements
  document.getElementById("gh_followers").innerHTML = ftd.followers;
  document.getElementById("gh_stars").innerHTML = totalStars;
  document.getElementById("gh_repos").innerHTML = totalRepos;
}

getStats();

// Read more and Read less functions
function readMore() {
  document.querySelector(".stats").style.display = "block";
  document.querySelector(".moar").style.display = "none";
}

function readLess() {
  document.querySelector(".stats").style.display = "none";
  document.querySelector(".moar").style.display = "table";
}
