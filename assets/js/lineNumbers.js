export default LineNumbers = {
  mounted() {
    const isReadOnly = this.el.tagName === "PRE";
    this.gutter = document.getElementById("line-numbers");

    if (isReadOnly) {
      // Read-only <pre>: just render lines from text content
      this.syncFromPre();
    } else {
      // Editor <textarea>
      this.textarea = this.el.querySelector("textarea") || this.el;
      this.textarea.addEventListener("input", () => this.syncFromTextarea());
      this.textarea.addEventListener("click", () => this.updateCursor());
      this.textarea.addEventListener("keyup", () => this.updateCursor());
      this.textarea.addEventListener("scroll", () => {
        this.gutter.scrollTop = this.textarea.scrollTop;
      });
      this.syncFromTextarea();
    }
  },

  syncFromPre() {
    const text = this.el.innerText || this.el.textContent || "";
    const lines = text.split("\n");
    // Remove trailing empty line that browsers often add
    const count = lines[lines.length - 1].trim() === "" ? lines.length - 1 : lines.length;
    this.gutter.innerHTML = Array.from({ length: Math.max(count, 1) }, (_, i) =>
      `<div>${i + 1}</div>`
    ).join("");
    this.updateLang();
  },

  syncFromTextarea() {
    const lines = (this.textarea.value || "").split("\n").length;
    this.gutter.innerHTML = Array.from({ length: lines }, (_, i) =>
      `<div>${i + 1}</div>`
    ).join("");
    this.updateCursor();
    this.updateLang();
  },

  updateCursor() {
    const val = this.textarea?.value || "";
    const pos = this.textarea?.selectionStart || 0;
    const lines = val.slice(0, pos).split("\n");
    const ln = lines.length;
    const col = lines[lines.length - 1].length + 1;
    const bar = document.querySelector(".bg-primary .flex span:first-child");
    if (bar) bar.textContent = `Ln ${ln}, Col ${col}`;
  },

  updateLang() {
    const nameInput = document.querySelector("input[name*='name']")?.value;
    const nameAttr = this.el.dataset.filename;
    const name = nameInput || nameAttr || "";
    const ext = name.split(".").pop().toLowerCase();
    const langs = {
      ex: "Elixir", exs: "Elixir Script", js: "JavaScript",
      ts: "TypeScript", py: "Python", rb: "Ruby",
      rs: "Rust", go: "Go", html: "HTML", css: "CSS",
      json: "JSON", md: "Markdown", sh: "Shell",
    };
    const el = document.getElementById("lang-display");
    if (el) el.textContent = langs[ext] || "Plain Text";
  }
};
