import monthSelectPlugin from 'flatpickr/dist/plugins/monthSelect';
import "flatpickr/dist/plugins/monthSelect/style.css";
import { Japanese } from "flatpickr/dist/l10n/ja";
let stdRegisterMaps = new Map([
    ["name", " 名〔漢字〕が入ります"],
    ["name_kana", "名〔カナ〕が入ります"],
    ["birthday", "生年月日が入ります"],
    ["company_info", "プロフィールが入ります"],
    ["nick_name", " ニックネーム 〔半角英数〕が入ります"],
    ["email", "郵便番号が入ります"],
    ["email_two", "連絡先が入ります"],
    ["phone_no", " 電話番号が入ります"],
    ["postalcode", "現住所が入ります"],
    ["school_type", "学校種別が入ります"],
    ["school_name", "学校名が入ります"],
    ["department_name", "学部・学科名が入ります"],
    ["subject_system", "学科系統が入ります"],
    ["student_student_qualification_category_id", " 保有資格ジャンル〔複数選択可〕が入ります"],
    ["student_student_qualification_type_id", " 保有資格〔複数選択可〕が入ります"],
    ["graduation_date", "卒業予定年月 〔YYYY-MM〕が入ります"],
    ["student_student_desire_industry_type_id", "志望する業種〔複数選択可〕が入ります"],
    ["student_student_desire_job_type_id", "志望する職種〔複数選択可〕が入ります"],
    ["student_student_m_region_id", "志望勤務地エリアが入ります"],
    ["student_student_m_prefecture_id", "志望勤務地県〔複数選択可〕が入ります"],
    ["student_student_transfer", "転勤が入ります"],
    ["job_info", "その他の希望が入ります"],
    ["club_name", "部活・サークル名が入ります"],
    ["club_position", "部活・サークル役職が入ります"],
    ["club_detail_activity", "部活・サークル活動内容が入ります"],
    ["club_guide", "学校外活動の詳細が入ります"],
    ["outside_school_activity", "学校外の活動が入ります"],
    ["is_beelab_activity_participate", "「BeeLab.College」の活動が入ります"],
    ["beelab_college_achievements", "「BeeLab.College」の活動実績が入ります"],
    ["sns_blog_for_pr", " ブログ・SNSアカウント〔URL〕が入ります"],
    ["pando_info", "Pandoページアカウント〔URL〕が入ります"],
    ["upload", "交通機関が入ります"],
]);
let stdGenderMaps = new Map([
    ["male", "男"],
    ["female", "女"],
    ["other_gen", "その他"],
]);


$(function () {

    /*initialization Data*/ 
    $("input[type=text], input[type='radio'], textarea, select").each(inputAreaSelectRadio_perview);
    $("input[type=checkbox]").each(checkbox_perview);
    $(".email span").text($("#email").val());
    $(".email span").css("color", "#000");
    $(".email svg path").css("fill", "#f4d01f");
    $("input[type=text], input[type=text][readonly='readonly'], input[type='radio'], textarea, select").on("focus", previewScroll);

    /*Event for perview*/ 
    $("input[type=text], input[type='radio'], textarea, select").on("keyup change", inputAreaSelectRadio_perview);
    $("#address").on("keyup", postalCodeAndAddress_perview);
    $("input[type=checkbox]").on("click", checkbox_perview);

    /*create multi select box*/ 
    $("#student_student_qualification_category_id").select2();
    $("#student_student_qualification_type_id").select2();
    $("#student_student_desire_industry_type_id").select2();
    $("#student_student_desire_job_type_id").select2();
    $("#student_student_m_prefecture_id").select2();

    /*date of birth date picker*/  
    if (document.getElementById("birthday")) {
        if (document.getElementById("birthday").value) {
            flatpickr(".datepicker", {
                wrap: true,
                maxDate: "today",
                locale: Japanese,
                disableMobile: "true"
            });
        } else {
            flatpickr(".datepicker", {
                wrap: true,
                maxDate: "today",
                defaultDate: "1999-04-01",
                locale: Japanese,
                disableMobile: "true"
            });
        };
    }  
//*date of birth date picker*/
if (document.getElementById("createdDate")) {
    if (document.getElementById("createdDate").value) {
        flatpickr(".datepicker", {
            wrap: true,
            maxDate: "today",
            locale: Japanese
        });
    } else {
        flatpickr(".datepicker", {
            wrap: true,
            maxDate: "today",
            locale: Japanese
        });
    };
} 

    /*graduation date picker*/ 
    flatpickr("#graduation_date_picker", {
        wrap: true,
        minDate: "today",
        locale: Japanese,
        disableMobile: "true",
        plugins: [
            new monthSelectPlugin({
                shorthand: true, //defaults to false
                dateFormat: "Y-m", //defaults to "F Y"
                altFormat: "F Y", //defaults to "F Y"
                theme: "light" // defaults to "light"
            })]
    });

    /*set prefecture according region*/ 
    $(document).on("change", "#student_student_m_region_id", function (e) {
        var not_select = $("#not_select_label").val();
        var prefecture = $("#student_student_m_prefecture_id");
        $.ajax({
            url: "/student/prefecture_name/" + $(this).children(":selected").attr("value"),
            success: function (data) {
                var prefecture_option;
                if (data.length === 0) { } else {
                    data.forEach(function (i) {
                        prefecture_option += '<option value="' + i.id + '">' + i.prefecture_name + "</option>";
                    });
                    prefecture.html(prefecture_option);
                }
            },
        });
    });

     /*show/hide delete file icon*/  
    if ($("#upload").data("existed")) {
        $("#remove_file").show();
    } else {
        $("#remove_file").hide();
    }

    /*student PR file upload*/  
    var selectedFile;
    $("#upload").on("change", function (event) {
        $("#haveFileFlag").val(false);
        if(event.target.files[0]){
            selectedFile = event.target.files
        }
        else{
            $("#upload")[0].files = selectedFile
        }
        $(".file-chosen").text(this.files[0].name);
        $("#remove_file").show();
    });

    /*remove selected PR file*/ 
    $("#remove_file").on("click", function () {
        $("#upload").val("");
        $("#haveFileFlag").val(true);
        $(".file-chosen").text("ファイルを選択してください。");
        $("#remove_file").hide();
    });

    /*set favorite company icon*/
    $("#favourite_company").on("click", function () {
        $.ajax({
            url: "/student/favourite_company/" + $("#company_id").val(),
            error: function (error) { },
            success: function (data) {
                if (data.favourite_flag) {
                    $("#favourite_company").addClass("active").removeClass("inactive");
                } else {
                    $("#favourite_company").addClass("inactive").removeClass("active");
                }
            },
        });
    });

    /*set favorite vacancy icon*/
    $("#favourite_vacancy").on("click", function () {
        $.ajax({
            url: "/student/favourite_vacancy/" + $("#vacancy_id").val(),
            error: function (error) { },
            success: function (data) {
                if (data.favourite_flag) {
                    $("#favourite_vacancy").addClass("active").removeClass("inactive");
                } else {
                    $("#favourite_vacancy").addClass("inactive").removeClass("active");
                }
            },
        });
    });

    /*set favorite event icon*/
    $("#favourite_event").on("click", function () {
        $.ajax({
            url: "/student/favourite_event/" + $("#event_id").val(),
            error: function (error) { },
            success: function (data) {
                if (data.favourite_flag) {
                    $("#favourite_event").addClass("active").removeClass("inactive");
                } else {
                    $("#favourite_event").addClass("inactive").removeClass("active");
                }
            },
        });
    });

    /*set join event*/
    $("#join_event").on("click", function () {
        $.ajax({
            url: "/student/join_event/" + $("#event_id").val(),
            error: function (error) { },
            success: function (data) {
                if (data.join_flag) {
                    $("#join_event").addClass("active").removeClass("inactive");
                } else {
                    $("#join_event").addClass("inactive").removeClass("active");
                }
            },
        });
    });
  
})

function inputAreaSelectRadio_perview() {
    var idName = $(this).attr('id');
    var currentVal = $(this).val();
    var type = this.type;
    ////for Name
    if (idName == "first_name_kana" || idName == "last_name_kana") {
        if (($("#last_name_kana").val() + $("#first_name_kana").val())) {
            currentVal = ($("#last_name_kana").val() + "　" + $("#first_name_kana").val()).toUpperCase();
        }
        idName = "name_kana";
    } else if (idName == "first_name" || idName == "last_name") {
        if (($("#last_name").val() + $("#first_name").val())) {
            currentVal = ($("#last_name").val() + "　" + $("#first_name").val()).toUpperCase();
        }
        idName = "name";
    }



    ////for radio
    if (type == "radio") {
        currentVal = stdGenderMaps.get($("input[name='student_student[gender]']:checked").val());
        idName = "gender";
    } else if ($(this).is("select")) {
        //// for all select box
        if ($(this).children("option:selected").val() != "") {
            currentVal = $(this).children("option:selected").text();
        } else {
            currentVal = ""
        }
        if (type == "select-multiple") {
            currentVal = $("#" + idName + " option:selected").toArray().map((item) => item.text).join("、");
        }
    }

    /// for postalcode and address
    if (idName == "postalcode" || idName == "address") {
        postalCodeAndAddress_perview();
        return;
    }

    /// all value 
    if (currentVal) {
        $("." + idName + " span").text(currentVal);
        $("." + idName + " span").css("color", "#000");
        $("." + idName + " svg path").css("fill", "#f4d01f");
    } else {
        $("." + idName + " span").text(stdRegisterMaps.get(idName));
        $("." + idName + " span").css("color", "#6c757d");
        $("." + idName + " svg path").css("fill", "#6c757d");
    }
}

function checkbox_perview() {
    var currentVal = "";
    var idName = "outside_school_activity";
    $.each($("input[type=checkbox]:checked"), function () {
        var currentChkId = $(this).attr("id");
        if (currentVal) {
            currentVal = currentVal + "、" + $("label[for=" + currentChkId + "]").text()
        } else {
            currentVal = $("label[for=" + currentChkId + "]").text()
        }
    });
    if (currentVal) {
        $("." + idName + " span").text(currentVal);
        $("." + idName + " span").css("color", "#000");
        $("." + idName + " svg path").css("fill", "#f4d01f");
    } else {
        $("." + idName + " span").text(stdRegisterMaps.get(idName));
        $("." + idName + " span").css("color", "#6c757d");
        $("." + idName + " svg path").css("fill", "#6c757d");
    }
}

function previewScroll() {
    var idName = $(this).attr('id');
    var type = this.type;
    if (idName == "first_name_kana" || idName == "last_name_kana") {
        idName = "name_kana";
    } else if (idName == "first_name" || idName == "last_name") {
        idName = "name";
    }
    if (type == "radio") {
        idName = "gender";
    }
    if (idName == "address" || idName == "region" ||  idName == "prefecture" ||  idName == "city") {
        idName = "postalcode"
    }
    var container = $(".perview-container");
    container.animate({
        scrollTop: $("." + idName).offset().top - container.offset().top + container.scrollTop(),
        scrollLeft: 0,
    },
        800
    );
}

function postalCodeAndAddress_perview() {
    var idName = "postalcode"
    var currentVal = $("#postalcode").val();
    if (currentVal.length == 7) {
        $("." + idName + " span").text($("#display_address").val());
        $("." + idName + " span").css("color", "#000");
        $("." + idName + " svg path").css("fill", "#f4d01f");
    } else {
        $("." + idName + " span").text(stdRegisterMaps.get(idName));
        $("." + idName + " span").css("color", "#6c757d");
        $("." + idName + " svg path").css("fill", "#6c757d");
    }
}