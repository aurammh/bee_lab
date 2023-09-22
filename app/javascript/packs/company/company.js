let comRegisterMaps = new Map([
    ["company_name", "企業名が入ります"],
    ["company_name_kana", "企業名〔カナ〕が入ります"],
    ["industry", "業種が入ります"],
    ["company_info", "プロフィールが入ります"],
    ["job_info", "事業内容が入ります"],
    ["postalcode", "現住所が入ります"],
    ["website_url", "ウェブサイトのURLが入ります"],
    ["phone_no", "連絡先が入ります"],
    ["company_established", "設立が入ります"],
    ["capital_amount", "資本金等（円）が入ります"],
    ["employee_count_string", "従業員数が入ります"],
    ["sales_amount", "昨年の売上高（円）が入ります"],
    ["related_company", "関連会社が入ります"],
    ["main_bank", "主要取引先が入ります"],
    ["history", "沿革が入ります"],
    ["basic_idea", "基本理念が入ります"],
    ["representative", "代表者が入ります"],
    ["avg_service_year_string", "平均勤続勤務年数（年）が入ります"],
    ["avg_overtime_per_month", "月平均所定外労働時間〔前年度実績〕（時間）が入ります"],
    ["avg_paid_leaves", "平均有給休暇取得日数〔前年度実績〕（日）が入ります"],
    ["number_eligible_childcare_leaves_male", "前年度の育児休業取得対象者数〔男性〕（人）が入ります"],
    ["taken_childcare_leaves_male", "前年度の育児休業取得者数〔男性〕（人）が入ります"],
    ["childcare_leave_acquisition_rate_male", "前年度の育休取得率〔男性〕（率）が入ります"],
    ["number_eligible_childcare_leaves_female", "前年度の育児休業取得対象者数〔女性〕（人）が入ります"],
    ["taken_childcare_leaves_female", "前年度の育児休業取得者数〔女性〕（人）が入ります"],
    ["rate_taken_childcare_leaves_female", "前年度の育休取得率〔女性〕（率）が入ります"],
    ["percentage_female_ration", "役員・管理者の女性比率が入ります"],
    ["percentage_training", "研修が入ります"],
    ["in_house_certification_system", "社内検定等の制度が入ります"],
    ["contact", "お問い合わせ先〔ご担当者・部署名・電話番号・メールアドレス・受付時間など〕が入ります"],
    ["transportation_facilities", "交通機関が入ります"],
]);
let comRadioVal = new Map([
    ["0", "なし"],
    ["1", "あり"],
]);
$(function () {

    $("input[type=text], textarea, input[type='radio'], select").on("keyup change", perviewCompany);
    $("input[type=text], textarea, input[type='radio'], select").on("focus", previewScroll);
    $("input[type=text], textarea, input[type='radio'], select").each(perviewCompany);


    if ($(".chk_email").is(":checked")) {
        $('.edit_username').removeClass('show');
    } else {
        $('.edit_username').addClass('show');
    }

    if ($(".chk_pass").is(":checked")) {
        $('.edit_password').removeClass('show');
    } else {
        $('.edit_password').addClass('show');
    }

    $('.chk_email').on("click", function () {
        if ($('.edit_username').hasClass('show')) {
            $('.edit_username').removeClass('show');
        } else {
            $('.edit_username').addClass('show');
        }
    });

    $('.chk_pass').on("click", function () {
        if ($('.edit_password').hasClass('show')) {
            $('.edit_password').removeClass('show');
        } else {
            $('.edit_password').addClass('show');
        }
    });

    /*Student Searching By Company*/
    /*[Ajax for location details by location_id]*/
    $("#m_region_id").on("change", function () {
        get_location_detail_data(this.value)
    });
    $("#m_region_id").trigger("change");


    /*set favourite student from company*/ 
    $("#favourite-student").on("click", function () {
        $.ajax({
            url: "/company/favourite_student/" + $("#student_id").val(),
            success: function (data) {
                if (data.com_std_favourite) {
                    $("#favourite-student").addClass("active").removeClass("inactive");
                } else {
                    $("#favourite-student").addClass("inactive").removeClass("active");
                }

            },
            error: function (error) { },
        });
    });
});

function perviewCompany() {
    var idName = $(this).attr('id');
    var currentVal = $(this).val();
    var type = $(this).is("select");
    if (this.type == "radio") {
        var rdName = "input[name='" + $(this).attr("name") + "']:checked";
        currentVal = comRadioVal.get($(rdName).val());
    }
    if (type) {
        if ($(this).children("option:selected").val() != "") {
            currentVal = $(this).children("option:selected").text();
        } else {
            currentVal = ""
        }
    }

    /*for postalcode and address*/  
    if (idName == "postalcode" || idName == "address") {
        postalCodeAndAddress_perview();
        return;
    }

    if (idName != "postalcode") {
        if (currentVal) {
            $("." + idName + " span").text(currentVal);
            $("." + idName + " span").css("color", "#000");
            $("." + idName + " svg path").css("fill", "#204a9c");
        } else {
            $("." + idName + " span").text(comRegisterMaps.get(idName));
            $("." + idName + " span").css("color", "#6c757d");
            $("." + idName + " svg path").css("fill", "#6c757d");
        }
    }
}

function previewScroll() {
    var idName = $(this).attr('id');
    var container = $(".perview-container");
    if (idName == "address" || idName == "region" ||  idName == "prefecture" ||  idName == "city") {
        idName = "postalcode"
    }
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
        $("." + idName + " svg path").css("fill", "#204a9c");
    } else {
        $("." + idName + " span").text(comRegisterMaps.get(idName));
        $("." + idName + " span").css("color", "#6c757d");
        $("." + idName + " svg path").css("fill", "#6c757d");
    }
}


 /*to get location detail by region for search with ajax*/   
function get_location_detail_data(locationDetail_id) {
    let url = BASE_URL + "/company/getLocationDetails";
    $.ajax({
        url: url,
        data: {
            m_region_id: locationDetail_id,
        },
        dataType: "JSON",
        error: function (error) {
            $(".location-detail").empty();
        },
        success: function (data) {
            if (data.length == 0) {
                $(".locationdetail-main").hide();
            } else {
                $(".locationdetail-main").show();
                let location_detail_list = "";
                let params_locationDetails = [];
                if ($("#locationDetail_param").val() !== undefined) {
                    params_locationDetails = $("#locationDetail_param").val().split(" ");
                    const arrStr = params_locationDetails;
                    params_locationDetails = arrStr.map((i) => Number(i));
                }
                data.forEach((element) => {
                    if (params_locationDetails.length > 0) {
                        if (params_locationDetails.find((arr_value) => arr_value === element[1])) {
                            location_detail_list += `<div class="simple-chkbox com-chk">
                            <input type="checkbox" id="locationDetail_${element[1]}" name="locationDetail_id[]" checked="checked" value="${element[1]}"> <label for="locationDetail_${element[1]}">${element[0]}</label>
                            </div>`;
                        } else {
                            location_detail_list += `<div class="simple-chkbox com-chk">
                            <input type="checkbox" id="locationDetail_${element[1]}" name="locationDetail_id[]" value="${element[1]}">
                            <label for="locationDetail_${element[1]}">${element[0]}</label>
                            </div>`;
                        }
                    } else {
                        location_detail_list += `<div class="simple-chkbox com-chk"><input type="checkbox" id="locationDetail_${element[1]}" name="locationDetail_id[]" value="${element[1]}"><label for="locationDetail_${element[1]}">${element[0]}</label></div>`;
                    }
                });
                $(".location-detail").empty().append(location_detail_list);
            }
        },
    });
}