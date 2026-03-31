export default CopyCode = {
  mounted() {
    this.original = this.el.innerHTML;

    this.el.addEventListener("click", () => {
      const raw = document.getElementById("gist-raw");
      const text = raw?.innerText || raw?.textContent || "";

      navigator.clipboard.writeText(text).then(() => {
        this.el.innerHTML = `
          <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
          </svg>
          Copied!
        `;
        this.el.disabled = true;

        setTimeout(() => {
          this.el.innerHTML = this.original;
          this.el.disabled = false;
        }, 2000);
      }).catch(() => {
        this.el.innerHTML = `
          <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
          </svg>
          Failed
        `;
        setTimeout(() => {
          this.el.innerHTML = this.original;
          this.el.disabled = false;
        }, 2000);
      });
    });
  }
};
