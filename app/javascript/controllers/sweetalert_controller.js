import { Controller } from "@hotwired/stimulus";
import swal from 'sweetalert';

// Connects to data-controller="sweetalert"
export default class extends Controller {
  static values = {
    id: Number
  }
  validation() {
    swal({
      title: "Merci!",
      text: `Votre paiement a bien été accepté`,
      icon: "success",
      buttons: ["réservations", "plan d'observation"]
    }).then((value) => {
      switch (value) {
        case true:
          window.location.href = `/observation_plannings/${this.idValue}`;
          break;

        default:
          window.location.href = '/mes-réservations';
          break;
      }
    });
  }
}
