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
    1000,
    copyButton,
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

const nth = (d) => {
  if (d > 3 && d < 21) return "th";
  switch (d % 10) {
    case 1:
      return "st";
    case 2:
      return "nd";
    case 3:
      return "rd";
    default:
      return "th";
  }
};

function formatDates() {
  let publishDate = document.querySelector('.date').innerText.slice(1).split('-');
  let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
  let prettyDate = ` ${Number(publishDate[2])}${nth(Number(publishDate[2]))} ${months[Number(publishDate[1])-1]} ${publishDate[0]}`;
  console.log(prettyDate);
  document.querySelector('.date').innerHTML = null;
  let icon = document.createElement("i");
  icon.classList = "nf nf-oct-pencil";
  // icon.style.setProperty("font-size", "0.75rem");
  document.querySelector('.date').append(icon, prettyDate);
}

formatDates();
addClipboardItems();
addAnchorLinks();
