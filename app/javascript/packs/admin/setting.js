
$(function() {
$(document).on("change", '.check_flg', function () {
    var id =  $(this).attr("id");
    let user_id = id.split('_')[2];
    let pers_type_id = $("#hid_"+id).val();
    // let user_id = $("#hid_"+id).val();
    // let flag_value = $(this).val();
    $.ajax({
        url: "/admin/set_permission/"+ pers_type_id+"/"+ user_id,
        success: function (data) {
            $("#liveToast").toast('show');
            // $(this).val(data.active_flag);
        },
    });
});
});