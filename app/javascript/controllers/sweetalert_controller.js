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
      text: `Votre paiement pour la commande n° ${this.idValue} à bien été accepté`,
      icon: "success",
      buttons: ['réservation', 'mes plannings de soirée']
    }).then((value) => {
      switch (value) {
        case true:
          window.location.href = '/observation_plannings';
          break;

        default:
          window.location.href = '/mes-réservations';
          break;
      }
    });
  }
}
