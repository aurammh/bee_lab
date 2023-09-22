$(function() {
    $('#admin_backup_db_backup_schedule').on('change', function() {
        var destroy_select = $('#admin_backup_db_destroy_schedule')
        destroy_select.find(":disabled").prop("disabled", false).show();
        if (this.value == "2") {
            destroy_select.find("[value='" + 1 + "']").prop("disabled", true).hide();
        } else if (this.value == "3") {
            destroy_select.find("[value='" + 1 + "']").prop("disabled", true).hide();
            destroy_select.find("[value='" + 2 + "']").prop("disabled", true).hide();
        }
    });

    if ($('#from_to_date').length) {
        document.getElementById("from_to_date").flatpickr({
            maxDate: "today",
            mode: "range",
        });
    }

});