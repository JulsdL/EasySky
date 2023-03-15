import { Controller } from "stimulus";
import Swal from "sweetalert2";

export default class PointageController extends Controller {
  // ...

  pointTelescope(event) {
    const celestialBodyName = event.currentTarget.dataset.celestialBodyName;

    Swal.fire({
      title: `Pointer le télescope vers ${celestialBodyName}?`,
      icon: "question",
      showCancelButton: true,
      confirmButtonText: "Oui",
      cancelButtonText: "Annuler",
    }).then((result) => {
      if (result.isConfirmed) {
        // Vous pouvez ajouter ici des actions à effectuer si l'utilisateur confirme
      }
    });
  }
}
