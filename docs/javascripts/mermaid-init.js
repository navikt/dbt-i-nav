document$.subscribe(async function () {
  if (typeof mermaid === "undefined") {
    return;
  }

  mermaid.initialize({
    startOnLoad: false,
    securityLevel: "loose",
    theme: "default"
  });

  const elements = document.querySelectorAll("pre.mermaid > code");

  for (const [index, element] of Array.from(elements).entries()) {
    const source = element.textContent;
    const container = element.closest("pre.mermaid");
    const renderTarget = document.createElement("div");
    const id = `mermaid-diagram-${index}`;

    renderTarget.className = "mermaid-diagram";
    renderTarget.id = id;
    container.replaceWith(renderTarget);

    mermaid.render(id + "-svg", source).then(({ svg, bindFunctions }) => {
      renderTarget.innerHTML = svg;
      if (bindFunctions) {
        bindFunctions(renderTarget);
      }
    });
  }
});