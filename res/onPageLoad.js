async function copyCode(block, copyButton) {
  let text = block.innerText;
  await navigator.clipboard.writeText(text);
  let para = copyButton.querySelector("p");
  para.innerHTML = null;
  let icon = document.createElement("i");
  icon.classList = "nf nf-md-clipboard_check_outline";
  let message = document.createTextNode(" Copied!");
  para.appendChild(icon);
  para.appendChild(message);
  setTimeout(
    (copyButton) => {
      let para = copyButton.querySelector("p");
      let icon = document.createElement("i");
      icon.classList = "nf nf-md-clipboard_text_outline";
      para.innerHTML = null;
      para.appendChild(icon);
    },
    500,
    copyButton
  );
}

function addClipboardItems() {
  let blocks = document.getElementsByTagName("pre");
  for (var i = 0; i < blocks.length; i++) {
    if (navigator.clipboard) {
      let copyButton = document.createElement("div");
      copyButton.classList = "copyButton";
      let para = document.createElement("p");
      let icon = document.createElement("i");
      icon.classList = "nf nf-md-clipboard_text_outline";
      para.appendChild(icon);
      copyButton.appendChild(para);
      blocks[i].appendChild(copyButton);
      let block = blocks[i].querySelector("code");
      copyButton.addEventListener("click", async () => {
        await copyCode(block, copyButton);
      });
    }
  }
}

function addAnchorLinks() {
  let headings = document
    .querySelector("main article")
    .querySelectorAll("h2, h3, h4, h5, h6");
  for (let i = 0; i < headings.length; i++) {
    let link = document.createElement("a");
    link.classList = "heading-anchor-link";
    link.href = `#${headings[i].id}`;
    let icon = document.createElement("i");
    icon.classList = "nf nf-oct-link";
    link.appendChild(icon);
    headings[i].appendChild(document.createTextNode(" "));
    headings[i].appendChild(link);
  }
}

function addTOC() {
  let list = document.querySelector("main aside nav ul");
  let article = document.querySelector("main article");
  let headings = article.querySelectorAll("h2");
  if (headings.length === 0) {
    document.querySelector("main aside").style.display = "none";
    document.querySelector("main").style.display = "block";
    return;
  }
  for (let i = 0; i < headings.length; i++) {
    let newEntry = document.createElement("li");
    let newLink = document.createElement("a");
    newLink.href = headings[i].querySelector("a").href;
    newLink.innerText = headings[i].innerText;
    newEntry.appendChild(newLink);
    list.appendChild(newEntry);
  }
}

addClipboardItems();
addAnchorLinks();
addTOC();
