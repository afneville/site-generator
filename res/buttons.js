function hideMainMenuDropDownResizeScroll(event) {
  _toggleDropdownMainMenu();
}

function hideMainMenuDropDownCLick(event) {
  if (
    !document
      .querySelector("#menu-dropdown-container")
      .contains(event.target)
  ) {
    toggleMainMenu();
  }
}

function hideThemeMenuDropDownResizeScroll(event) {
  toggleThemeMenu();
}

function hideThemeMenuDropDownClick(event) {
  if (
    !document
      .querySelector("#theme-dropdown-container")
      .contains(event.target)
  ) {
    toggleThemeMenu();
  }
}

function closeCompactMenu(event) {
  toggleMainMenu();
  location.hash = event.target.href;
}

function _toggleCompactMainMenu() {
  let menuIcon = document
    .getElementById("menu-button")
    .querySelector("i");
  let menu = document.querySelector("aside");
  if (menu.style.display !== "block") {
    document
      .querySelectorAll("aside #article-contents a")
      .forEach((link) => {
        link.addEventListener("click", closeCompactMenu);
      });
    positionInArticle = window.scrollY;
    window.scrollTo({top: 0, behavior: "instant"});
    document.getElementById("page-footer").style.display = "none";
    window.removeEventListener("scroll", highlightCurrentSection);
    window.removeEventListener("scroll", scrollFunction);
    document
      .querySelectorAll(".page-start-button")
      .forEach((button) => (button.style.display = "none"));
    document.querySelector("article").style.display = "none";
    menu.style.display = "block";
    try {
      resizeIframe(document.querySelector("iframe"));
    } catch {}
    menuIcon.classList = "nf nf-md-close";
    menuIcon.style.color = "var(--fg-secondary)";
    window.scrollTo({top: 0, behavior: "instant"});
  } else {
    document
      .querySelectorAll("aside #article-contents a")
      .forEach((link) => {
        link.removeEventListener("click", closeCompactMenu);
      });
    menu.removeAttribute("style");
    menuIcon.removeAttribute("style");
    document.querySelector("article").removeAttribute("style");
    window.addEventListener("scroll", scrollFunction);
    window.scrollTo({
      top: positionInArticle,
      left: 0,
      behavior: "instant",
    });
    window.addEventListener("scroll", highlightCurrentSection);
    // highlightCurrentSection();
    menuIcon.classList = "nf nf-md-menu";
    document.getElementById("page-footer").removeAttribute("style");
  }
}

function _toggleDropdownMainMenu() {
  let menuIcon = document
    .getElementById("menu-button")
    .querySelector("i");
  let menu = document.querySelector(
    "#menu-dropdown-container .dropdown-menu"
  );
  if (menu.style.display !== "block") {
    // menuIcon.classList = "nf nf-md-close";
    menuIcon.style.color = "var(--fg-secondary)";
    menu.style.display = "block";
    window.addEventListener("click", hideMainMenuDropDownCLick);
    window.addEventListener("resize", hideMainMenuDropDownResizeScroll, {once: true});
    window.addEventListener("scroll", hideMainMenuDropDownResizeScroll, {once: true});
  } else {
    window.removeEventListener("click", hideMainMenuDropDownCLick);
    window.removeEventListener("resize", hideMainMenuDropDownResizeScroll);
    window.removeEventListener("scroll", hideMainMenuDropDownResizeScroll);
    menu.removeAttribute("style");
    // menuIcon.classList = "nf nf-md-menu";
    menuIcon.removeAttribute("style");
  }
}

function toggleMainMenu() {
  if (
    window.getComputedStyle(document.getElementById("theme-dropdown-container")).display === "none"
  ) {
    _toggleCompactMainMenu();
  } else {
    _toggleDropdownMainMenu();
  }
}

function _toggleThemeMenu() {
  let menuIcon = document
    .getElementById("theme-switch-button")
    .querySelector("i");
  let menu = document.querySelector(
    "#theme-dropdown-container .dropdown-menu"
  );
  if (menu.style.display !== "block") {
    menuIcon.style.color = "var(--fg-secondary)";
    menu.style.display = "block";
    window.addEventListener("click", hideThemeMenuDropDownClick);
    window.addEventListener("resize", hideThemeMenuDropDownResizeScroll);
    window.addEventListener("scroll", hideThemeMenuDropDownResizeScroll);
  } else {
    window.removeEventListener("click", hideThemeMenuDropDownClick);
    window.removeEventListener("resize", hideThemeMenuDropDownResizeScroll);
    window.removeEventListener("scroll", hideThemeMenuDropDownResizeScroll);
    menu.removeAttribute("style");
    menuIcon.removeAttribute("style");
  }
}

function toggleThemeMenu() {
  _toggleThemeMenu();
}

document
  .getElementById("menu-button")
  .addEventListener("click", toggleMainMenu);

document
  .getElementById("theme-switch-button")
  .addEventListener("click", toggleThemeMenu);
