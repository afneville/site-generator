function enableStylesheet(node) {
  node.rel = "stylesheet";
}

function disableStylesheet(node) {
  node.rel = "stylesheet alternate";
}

function lightTheme() {
  preference.removeEventListener("change", toggleCodeBlockTheme);
  document.documentElement.classList.remove("system-theme");
  document.documentElement.classList.add("light-theme");
  document.documentElement.classList.remove("dark-theme");
  try {
    var light_stylesheet = document.getElementById("code-blocks-light");
    var dark_stylesheet = document.getElementById("code-blocks-dark");
    disableStylesheet(dark_stylesheet);
    enableStylesheet(light_stylesheet);
  } catch {}
  localStorage.setItem("theme", "light");
  try {
    let sectionIframe = document.querySelector("iframe");
    sectionIframe.contentWindow.document.documentElement.classList.remove(
      "system-theme"
    );
    sectionIframe.contentWindow.document.documentElement.classList.add(
      "light-theme"
    );
    sectionIframe.contentWindow.document.documentElement.classList.remove(
      "dark-theme"
    );
  } catch {}
}

function darkTheme() {
  preference.removeEventListener("change", toggleCodeBlockTheme);
  document.documentElement.classList.remove("system-theme");
  document.documentElement.classList.add("dark-theme");
  document.documentElement.classList.remove("light-theme");
  try {
    var light_stylesheet = document.getElementById("code-blocks-light");
    var dark_stylesheet = document.getElementById("code-blocks-dark");
    disableStylesheet(light_stylesheet);
    enableStylesheet(dark_stylesheet);
  } catch {}
  localStorage.setItem("theme", "dark");
  try {
    let sectionIframe = document.querySelector("iframe");
    sectionIframe.contentWindow.document.documentElement.classList.remove(
      "system-theme"
    );
    sectionIframe.contentWindow.document.documentElement.classList.add(
      "dark-theme"
    );
    sectionIframe.contentWindow.document.documentElement.classList.remove(
      "light-theme"
    );
  } catch {}
}

function systemTheme() {
  document.documentElement.classList.remove("light-theme");
  document.documentElement.classList.remove("system-theme");
  document.documentElement.classList.remove("dark-theme");
  document.documentElement.classList.add("system-theme");
  try {
    var light_stylesheet = document.getElementById("code-blocks-light");
    var dark_stylesheet = document.getElementById("code-blocks-dark");
    let preference = window.matchMedia("(prefers-color-scheme: dark)");
    if (preference.matches) {
      disableStylesheet(light_stylesheet);
      enableStylesheet(dark_stylesheet);
    } else {
      disableStylesheet(dark_stylesheet);
      enableStylesheet(light_stylesheet);
    }
  } catch {}
  localStorage.clear();
  preference.addEventListener("change", toggleCodeBlockTheme);
  try {
    let sectionIframe = document.querySelector("iframe");
    sectionIframe.contentWindow.document.documentElement.classList.remove(
      "light-theme"
    );
    sectionIframe.contentWindow.document.documentElement.classList.remove(
      "dark-theme"
    );
    sectionIframe.contentWindow.document.documentElement.classList.remove(
      "system-theme"
    );
    sectionIframe.contentWindow.document.documentElement.classList.add(
      "system-theme"
    );
  } catch {}
}

document.querySelectorAll(".light-theme-button").forEach((button) =>
  button.addEventListener("click", () => {
    lightTheme();
    if (
      window
        .getComputedStyle(document.querySelector("main"))
        .getPropertyValue("grid-template-areas") !== '"content"'
    ) {
      toggleThemeMenu();
    }
  })
);

document.querySelectorAll(".dark-theme-button").forEach((button) =>
  button.addEventListener("click", () => {
    darkTheme();
    if (
      window
        .getComputedStyle(document.querySelector("main"))
        .getPropertyValue("grid-template-areas") !== '"content"'
    ) {
      toggleThemeMenu();
    }
  })
);

document.querySelectorAll(".system-theme-button").forEach((button) =>
  button.addEventListener("click", () => {
    systemTheme();
    if (
      window
        .getComputedStyle(document.querySelector("main"))
        .getPropertyValue("grid-template-areas") !== '"content"'
    ) {
      toggleThemeMenu();
    }
  })
);

const toggleCodeBlockTheme = (setting) => {
  if (setting.matches) {
    try {
      var light_stylesheet = document.getElementById(
        "code-blocks-light"
      );
      var dark_stylesheet = document.getElementById("code-blocks-dark");
      disableStylesheet(light_stylesheet);
      enableStylesheet(dark_stylesheet);
    } catch {}
  } else {
    try {
      var light_stylesheet = document.getElementById(
        "code-blocks-light"
      );
      var dark_stylesheet = document.getElementById("code-blocks-dark");
      disableStylesheet(dark_stylesheet);
      enableStylesheet(light_stylesheet);
    } catch {}
  }
};

let preference = window.matchMedia("(prefers-color-scheme: dark)");
if (localStorage.getItem("theme") === "light") {
  lightTheme();
} else if (localStorage.getItem("theme") === "dark") {
  darkTheme();
} else {
  toggleCodeBlockTheme(preference);
  preference.addEventListener("change", toggleCodeBlockTheme);
}
