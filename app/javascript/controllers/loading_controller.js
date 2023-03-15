import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="loading"
export default class extends Controller {
  static targets = ["page"]
  launchAnimation() {
    setTimeout(() => {
      this.pageTarget.innerHTML = "";
      this.pageTarget.insertAdjacentHTML('beforeend', "<p>Nous calculons le planning idéal</p>")
      this.pageTarget.classList.add("loader-container");
    }, 250);
  }
}
