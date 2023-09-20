let pageStartButtons = document.querySelectorAll(".page-start-button");
pageStartButtons.forEach(function (button) {
  button.addEventListener("click", function () {
    scrollToTop();
  });
});

function scrollToTop() {
  window.scrollTo(0, 0);
}

function scrollFunction() {
  if (
    document.body.scrollTop > 1 ||
    document.documentElement.scrollTop > 1
  ) {
    document
      .querySelectorAll(".page-start-button")
      .forEach((button) => (button.style.display = "block"));
  } else {
    document
      .querySelectorAll(".page-start-button")
      .forEach((button) => (button.style.display = "none"));
  }
}

function highlightCurrentSection() {
  if (
    typeof anchors != "undefined" &&
    anchors != null &&
    typeof links != "undefined" &&
    links != null
  ) {
    let scrollTop = window.scrollY;
    links.forEach((link, index) => {
      link.classList.remove("active");
    });
    for (var i = anchors.length - 1; i >= 0; i--) {
      if (scrollTop > anchors[i].offsetTop - 100) {
        links[i].classList.add("active");
        break;
      }
    }
  }
}

function highlightCurrentDocument() {
  let pages =
    window.frames[
      "section-contents-iframe"
    ].contentDocument.querySelectorAll("li");
  for (let i = 0; i < pages.length; i++) {
    if (
      pages[i].querySelector("a").href.split("/").reverse()[0] ===
      location.pathname.split("/").reverse()[0]
    ) {
      pages[i].classList.add("active");
      break;
    }
  }
}

const anchors = document
  .querySelector("article")
  .querySelectorAll("h2");
const links = document
  .querySelector("aside")
  .querySelectorAll("nav > ul > li");

window.addEventListener("scroll", highlightCurrentSection);
window.addEventListener("scroll", scrollFunction);

let resizedIframe = false;

if (window.getComputedStyle(document.getElementById("theme-dropdown-container")).display === "block") {
  resizedIframe = true;
}

window.addEventListener(
  "resize",
  function (event) {
    if (
      document.getElementById("theme-switch-button").checkVisibility()
    ) {
      if (resizedIframe === false) {
        try {
          resizeIframe(document.querySelector("iframe"));
          resizedIframe = true;
        } catch {}
      }
      if (document.querySelector("article").style.display === "none") {
        _toggleCompactMainMenu();
      }
    }
  },
  true
);

let positionInArticle = window.scrollY;
