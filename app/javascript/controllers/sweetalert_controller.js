import { Controller } from "@hotwired/stimulus";
import swal from 'sweetalert';

// Connects to data-controller="sweetalert"
export default class extends Controller {
  validation() {
    swal({
      title: "Merci!",
      text: "Votre paiement à bien été accepté",
      icon: "success",
      buttons: ['réservation', 'planning soirée']
    }).then((value) => {
      switch (value) {
        case true:
          window.location.href = "";
          break;

        default:
          console.log('go reservation')
          break;
      }
    });
  }
}
