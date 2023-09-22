import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

 /*config jquery from node_module*/
var jQuery = require("jquery");
global.$ = global.jQuery = jQuery;
window.$ = window.jQuery = jQuery;

/*config bootstrap from node_module*/ 
require("popper.js")
require("bootstrap")

/*config fontawesome from node_module*/ 
import "@fortawesome/fontawesome-free/js/all";
/*config flatpickr (datetime picker) from node_module*/ 
import flatpickr from "flatpickr";
import "flatpickr/dist/flatpickr.min.css";
import "flatpickr/dist/plugins/monthSelect/style.css";

/*to use single and multiselect combo box*/ 
import "select2";
import "select2/dist/css/select2.css";
/*config chart from node_module*/ 
import Chart from "chart.js";
import "jquery-ui/themes/base/all.css";
/*config croppie image crop from node_module*/ 
require("croppie");
import 'croppie/croppie.css';
/*config bootstrap admin template from node_module*/ 
require("startbootstrap-sb-admin-2/js/sb-admin-2")

require("trix")
require("@rails/actiontext")