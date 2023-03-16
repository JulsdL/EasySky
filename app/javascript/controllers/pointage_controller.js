import { Controller } from "@hotwired/stimulus";
import Swal from "sweetalert2";

export default class extends Controller {
  pointTelescope(event) {
    const celestialBodyName = event.currentTarget.getAttribute('data-pointage-celestial-body-name');

    Swal.fire({
      title: `Pointer le télescope vers ${celestialBodyName}?`,
      icon: "question",
      showCancelButton: true,
      confirmButtonText: "Oui",
      cancelButtonText: "Annuler",
    }).then((result) => {
      if (result.isConfirmed) {
        // Si l'utilisateur confirme, affichez un message "Pointage en cours..."
        Swal.fire({
          title: `Transmission au télescope en cours...`,
          iconHtml: '<i class="fa-solid fa-satellite-dish"></i>',
          showConfirmButton: false,
          allowOutsideClick: true, // Autoriser la fermeture en cliquant en dehors de la fenêtre
          allowEscapeKey: false,
          allowEnterKey: false,
          timerProgressBar: true,
          timer: 4000, // Le message disparaîtra après 4 secondes (4000 ms)
        }).then((result) => {
          if (result.dismiss === Swal.DismissReason.timer) {
            console.log("Le pointage a été effectué.");
          }
        });
      }
    });
  }
}
