import { Japanese } from "flatpickr/dist/l10n/ja";
$(function() {
    document.getElementById("start_date").flatpickr({
        minDate: "",
        locale: Japanese,
        disableMobile: "true",
        onChange: function(selectedDates, dateStr, instance) {
            if (dateStr > $("#end_date").val()) {
                $("#end_date").val('');
            }
            document.getElementById("end_date").flatpickr({
                minDate: dateStr,
                locale: Japanese,
                disableMobile: "true"
            });
        }
    });
    document.getElementById("end_date").flatpickr({
        minDate: $("#start_date").val(),
        locale: Japanese,
        disableMobile: "true",
        onChange: function(selectedDates, dateStr, instance) {
            document.getElementById("start_date").flatpickr({
                locale: Japanese,
                disableMobile: "true"
            });
        }
    });
});