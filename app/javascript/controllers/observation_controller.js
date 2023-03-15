import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["description"];

  toggleDescription(event) {
    console.log("Hello from observation controller")
    const description = event.currentTarget.closest(".observation-plan-card").querySelector(".observation-plan-card-infos .description");
    console.log(description)
    description.classList.toggle("expanded");
  }
}
