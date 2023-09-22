$(function() {
    let check_genuine_password = false || $("#genuine_password").val();
    if (check_genuine_password) { $("#liveToast").toast('show'); }
    /*to type only number for Phone no.*/
    $('.only-num-stud').focusout(function() {
        this.value = this.value.replace(/[０-９]/g, s => String.fromCharCode(s.charCodeAt(0) - 65248)).replace(/\D/g, '');
    });

    /*number deleting commas seperators when focus out and enter key*/
    $(".number-with-delimeter").on("keypress focusout", function(event) {
        this.value = this.value.replace(/[０-９]/g, s => String.fromCharCode(s.charCodeAt(0) - 65248)).replace(/\D/g, '');
        if (this.value != "") {
            this.value = (parseFloat(this.value)).toLocaleString('en');
        } else {
            this.value = ""
        }
    });

    /*number deleting commas seperators when focus in*/
    $('.number-with-delimeter').focusin(function() {
        if (this.value != "") {
            this.value = parseFloat(this.value.replace(/,/g, ''));
        } else {
            this.value = ""
        }
    });

    /*to check image existed or not in initial state*/
    if ($("#image").data("existed") && $(".img-name").text()) {
        $("#img-remove").show();
    } else {
        $("#img-remove").hide();
    }

    /*Image Upload*/
    /*Crop Image [start]*/
    var image_crop = $('#image-demo').croppie({
        enableExif: true,
        viewport: { width: 300, height: 300, type: 'square' },
        boundary: { height: 500 },
        showZoomer: false,
        enableOrientation: true
    });

    /*to upload image file to modal*/
    $(".input-file").on("change", function(e) {
        $("#imageFlag").val(false);
        var files = e.target.files
        if (files && files.length > 0) {
            var reader = new FileReader();
            reader.onload = function(event) {
                image_crop.croppie('bind', {
                    url: event.target.result,
                    zoom: 0
                });
            }
            reader.readAsDataURL(this.files[0]);
            $('#uploadimageModal').modal('show');
        }
    });

    /*click image crop button*/
    $(".crop-image").click(function(event) {
        let preview = $(".upload-preview img");
        image_crop.croppie('result', {
            type: 'canvas',
            size: 'viewport', //resize file size (can use viewport size or original size)
            format: 'jpeg',
            quality: 1
        }).then(function(res) {
            var upload_img_name = $(".input-file")[0].value.replace(/^.*[\\\/]/, '');
            $("#image_data").val(upload_img_name + ',' + res);
            preview.attr('src', res);
            $('#uploadimageModal').modal('hide');
            if ($("#image_data").val() != "false") {
                $(".chosen-text").text(upload_img_name);
                $(".chosen-event-text").text(upload_img_name);
                $("#img-remove").show();
                $(".input-file")[0].value = ""; //for onChange not fire if select the same file
            } else {
                $(".chosen-text").text("顔写真をアップロードしてください。");
                $(".chosen-event-text").text("写真をアップロードしてください。");
                $("#img-remove").hide();
            }
        });
    });

    $(".vanilla-rotate").on("click", function() {
        image_crop.croppie('rotate', parseInt($(this).data('deg')))
    });

    /*to close crop modal*/
    $(".close-crop").click(function() {
        $(".input-file")[0].value = "";
    });
    /*Crop Image [end]*/

    /*to remove/delete image file*/
    $("#img-remove").on("click", function(event) {
        var preview = $(".upload-preview img");
        preview.attr("src", "/assets/avatar/preview.svg");
        $("#image").val("");
        $("#imageFlag").val(true);
        $("#image_data").val(false);
        $("#img-remove").hide();
        $(".chosen-text").text("顔写真をアップロードしてください。");
        $(".chosen-event-text").text("写真をアップロードしてください。");
    });

    /*hide concat address field */
    $(".display_address").hide();

    /*table row click*/
    $("tr[data-link]").click(function() {
        window.location = this.dataset.link;
    });
    /*div click*/
    $("div[data-link]").click(function() {
        window.location = this.dataset.link;
    });
    /*table column click*/
    $("td[data-link]").click(function() {
        window.location = this.dataset.link;
    });
    /*span click*/
    $("span[data-link]").click(function() {
        window.location = this.dataset.link;
    });

    /*set blank value when getting error*/
    let hasError = $("input[type=text], textarea").parent().hasClass('field_with_errors');
    if (hasError) {
        $(".field_with_errors input[type=text], .field_with_errors textarea").val("");
    }

    /*for dialog confrim from assessement [start] */
    var change_flag = false;
    var modal_data_link = "";

    /*click submit check for form empty or not */
    $("#btn-submit").on("click", function(e) {
        var formID = $(this).parents("form").attr("id");
        var selectedRadio = $(".student-assessment input[type='radio']:checked");
        if (selectedRadio.length == (formID == "brain-form" ? 40 : 27)) {
            return true;
        } else {
            $("#submit-modal").modal('show');
            return false;
        }
    });

    /*click on input and check from changed or not */
    $(".student-quiz :input ").change(function() {
        change_flag = true;
    });

    /*click on navigation link <a href> tag */
    $('.assessments_link').on("click", function(e) {
        if (change_flag) {
            e.preventDefault();
            e.stopPropagation();
            $("#confirm-modal").modal('show');
            var href = e.currentTarget.getAttribute('href')
            if (href.indexOf("sign_out") !== -1) {
                href = "/logout"
            }
            modal_data_link = href;
        }
    });

    /*click on modal yes button */
    $("#modal-btn-yes").on("click", function() {
        $("#confirm-modal").modal('hide');
        window.location = modal_data_link;
    });

    /*click on submit modal yes button */
    $("#modal-submit-yes").on("click", function() {
        var formID = $(this).parents("form").attr("id");
        var selectedRadio = $("#" + formID + " .student-assessment input[type='radio']:checked");
        if (selectedRadio.length != (formID == "brain-form" ? 40 : 27)) {
            window.location = "/student/assessments";
        }
    });
    /*for dialog confrim from assessement [end] */

    /*set mail setting to company */
    $("#mail_setting").on("change", function() {
        $.ajax({
            url: "/company/mail_settings/" + $("#mail_setting").val(),
            success: function(data) {
                 $("#mail_setting").val(data.mail_setting);
            },
            error: function(error) {},
        });
    });
});

/*for scroll of registration pages */
var myEle = document.getElementsByClassName("perview-container");
if (myEle.length > 0) {
    var top = $(".perview-container").offset().top;
    $(window).on("scroll", function(evt) {
        var footTop = $("footer").offset().top;
        var maxY = footTop - $(".perview-container").outerHeight();
        var y = $(this).scrollTop();
        if (y >= top - $(".navbar").height()) {
            if (y < maxY) {
                $(".perview-container").removeAttr("style");
            } else {
                $(".perview-container")
                    .css({
                        position: "absolute",
                        top: maxY - top + "px",
                    });
            }
        } else {
            $(".perview-container").removeClass("fixed");
        }
    });
}