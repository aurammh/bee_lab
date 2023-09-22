$(function() {
    // show reply form
    $("#reply-form").hide();
    $('.reply-btn, .discard-btn').click(function() {
        $("#reply-form, .reply-btn").fadeToggle("fast");
    });

    /*click submit check for form filed */
    $("#btn-communicaion").on("click", function(e) {
        var err_flag = false;
        $('#communication-form *').filter(':input.errors').not("input[type='hidden']").each(function() {
            if ($(this).val() == "") {
                err_flag = true;
                $(".error_" + $(this).attr("id")).addClass("field_with_errors");
                $(".err_" + $(this).attr("id")).removeClass("d-none");
            } else {
                $(".error_" + $(this).attr("id")).removeClass("field_with_errors");
                $(".err_" + $(this).attr("id")).addClass("d-none");
            }
        });
        if (document.querySelector("trix-editor").value == "") {
            err_flag = true;
            $(".error_content").addClass("field_with_errors");
            $(".err_content").removeClass("d-none");
        } else {
            $(".error_content").removeClass("field_with_errors");
            $(".err_content").addClass("d-none");
        }
        if (err_flag) {
            return false;
        } else {
            return true;
        }
    });
});