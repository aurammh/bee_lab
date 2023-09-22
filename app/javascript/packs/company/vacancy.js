import { Japanese } from "flatpickr/dist/l10n/ja";

let vanRegisterMaps = new Map([
    ["vacancy_title", " 求人タイトルが入ります"],
    ["vacancy_description", " 求人内容が入ります"],
    ["postalcode", " 現住所が入ります"],
    ["recruit_industry_type", " 業種 が入ります"],
    ["recruit_job_type", "職種が入ります"],
    ["required_applicants", "募集人数が入ります"],
    ["basic_salary", " 基本給〔半角数字ハイフンなしで入力〕が入ります"],
    ["model_salary", " モデル給与〔基本給・手当など〕が入ります"],
    ["allowance", " 諸手当が入ります"],
    ["bonus", " 賞与が入ります"],
    ["working_hours", " 勤務時間が入ります"],
    ["break_time", " 休憩時間が入ります"],
    ["holiday", "休日が入ります"],
    ["displayed_text", "福利厚生が入ります"],
    ["company_vacancy_other", "その他〔フリー〕が入ります"],
    ["company_vacancy_hiring_flow_data", "採用までのフローが入ります"],
    ["company_vacancy_other_skill", " その他が入ります"],
    ["display_from", "表示期限〔From〕が入ります"],
    ["display_to", "表示期限〔To〕が入ります"],
]);
let comRadioVal = new Map([
    ["0", "なし"],
    ["1", "あり"],
]);
$(function () {

    $("input[type=text], textarea, input[type='radio'], select").on("keyup change", previewVacancy);
    $("input[type=text], textarea, input[type='radio'], select").each(previewVacancy);
    $("input[type=text], textarea, input[type='radio'], select").on("focus", previewScroll);
    $("input[type=checkbox]").on("change", checkbox_perview).trigger("change");
    $(document).on('keyup', ".hire-btn input[type='text']", previewVacancy);
 
    /*initialization Data*/ 
    $('.display_address').hide();
     //show and hide area of hiring flow at initial state
     if ($("input[name='company_vacancy[over_time]']:checked").val() == 1) {
        $('.hire_info').show();
    } else {
        $('.hire_info').hide();
    }

    /*dateime picker [vacancy start date]*/
    flatpickr(".display-from",{
        minDate: "today",
        locale: Japanese,
        wrap: true,
        disableMobile: "true",
        onChange: function (selectedDates, dateStr, instance) {
            if (dateStr > $("#display_to").val()){
                $("#display_to").val('');
            }
            flatpickr(".display-to",{
                minDate: dateStr,
                locale: Japanese,
                wrap: true,
                disableMobile: "true"
            });
        }
    });

    /*dateime picker [vacancy start date]*/
    flatpickr(".display-to",{
        minDate: "today",
        locale: Japanese,
        wrap: true,
        disableMobile: "true",
        onChange: function (selectedDates, dateStr, instance) {
            if (dateStr < $("#display_from").val()){
                $("#display_from").val('');
            }
           flatpickr(".display-from",{
                minDate: "today",
                maxDate: dateStr,
                locale: Japanese,
                wrap: true,
                disableMobile: "true"
            });
        }
    });

    /*show and hide area of hiring flow according having overtime or not*/
    $("input[name='company_vacancy[over_time]").on("click", function () {
        if ($("input[name='company_vacancy[over_time]']:checked").val() == 1) {
            $('.hire_info').show();
        } else {
            $('.hire_info').hide();
        }
    });


    /*add text field for hire flow*/
    var max_fields = 10; //maximum input box allow
    var x = $('.plus_minus_icon').length; //initlal text box count
    $(".plus_icon").on("click", function (e) {
        e.preventDefault();
        if (x < max_fields) {
            x++; //text box increment
            var id = ($('.plus_minus_icon').length + 1).toString();
            $("#dynamic-inputs").append('<div class="hire-btn"><input type="text" class="mb-3 form-control shadow-none errors" name="company_vacancy[hiring_flow_data][]" id="company_vacancy_hiring_flow_data_'+ id + '"></input><span class="plus_minus_icon remove_icon" id="add_row' + id + '"><i class="fas fa-minus-circle"></i></span></div>');
            $(".add_vacancy").append('<div class="add_row'+ id + ' company_vacancy_hiring_flow_data_'+id+' row mr-0">'+
                                            '<div class="col-1 pr-0">' +
                                                '<i class="fas fa-check" style="color: #6c757d;"></i>' +
                                            '</div>' +
                                            '<div class="col-11 text-break">' +
                                                '<span style="color: #6c757d;">採用までのフローが入ります</span>' +
                                            '</div>' +
                                        '</div> ');
        }
    });

    /*remove text field for hire flow*/
    $('#dynamic-inputs,#original-inputs').on("click", ".remove_icon", function (e) { //user click on remove text
        e.preventDefault(); 
        $(this).parent('div').remove(); 
        var divId = $(this).attr('id');
        $(".add_vacancy ."+divId).remove();
        x--;
    });

    /*dynamically add and remove div for checked selected value*/
    $(".checkbox-click-enhancement").on("change", addAndRemoveEachCheckedSelectedVal).trigger("change");
    $(".checkbox-click-welfare").on("change", addAndRemoveEachCheckedSelectedVal).trigger("change");
    /* dynamically add and remove div for all checked condition*/
    $("#modal1CheckedAll").on("click", addAndRemoveAllCheckedSelectedVal);
    $("#modal2CheckedAll").on("click", addAndRemoveAllCheckedSelectedVal);
})

function previewVacancy() {
    var idName = $(this).attr('id');
    var currentVal = $(this).val();
    var type = $(this).is("select");    
    if (this.type == "radio") {
        var rdName = "input[name='" + $(this).attr("name") + "']:checked";
        currentVal = comRadioVal.get($(rdName).val());
    }
    if (type) {
        if($(this).children("option:selected").val()!=""){
            currentVal = $(this).children("option:selected").text();
        }else{
            currentVal = ""  
        }
    }
    /*for postalcode and address*/
    if (idName == "postalcode" || idName == "address") {
        postalCodeAndAddress_perview();
        return;
    }
    if (currentVal) {
        $("." + idName + " span").text(currentVal);
        $("." + idName + " span").css("color", "#000");
        $("." + idName + " svg path").css("fill", "#204a9c");
    } else {
        var nullText = vanRegisterMaps.get(idName);
        if(idName.indexOf("company_vacancy_hiring_flow_data") != -1){
            nullText = vanRegisterMaps.get("company_vacancy_hiring_flow_data")
        }
        $("." + idName + " span").text(nullText);
        $("." + idName + " span").css("color", "#6c757d");
        $("." + idName + " svg path").css("fill", "#6c757d");
    }
}

function previewScroll() {
    var idName = $(this).attr('id');
    var container = $(".perview-container");
    if (idName == "address") {
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
        $("." + idName + " span").text(vanRegisterMaps.get(idName));
        $("." + idName + " span").css("color", "#6c757d");
        $("." + idName + " svg path").css("fill", "#6c757d");
    }
}

function checkbox_perview() {
    var idName = "displayed_text";
    var currentVal = "";
    $.each($(".checkbox-click-enhancement:checked"), function () {
        var currentChkId = $(this).attr("id");
        if (currentVal) {
            currentVal = currentVal + "、" + $("label[for="+currentChkId+"]").text();
        } else {
            currentVal = $("label[for="+currentChkId+"]").text();
        }
    });
    $.each($(".checkbox-click-welfare:checked"), function () {
        var currentChkId = $(this).attr("id");
        if (currentVal) {
            currentVal = currentVal + "、" + $("label[for="+currentChkId+"]").text();
        } else {
            currentVal = $("label[for="+currentChkId+"]").text();
        }
    });
    if (currentVal) {
        $("." + idName + " span").text(currentVal);
        $("." + idName + " span").css("color", "#000");
        $("." + idName + " svg path").css("fill", "#204a9c");
    } else {
        $("." + idName + " span").text(vanRegisterMaps.get(idName));
        $("." + idName + " span").css("color", "#6c757d");
        $("." + idName + " svg path").css("fill", "#6c757d");
    }
}

 /*dynamically add and remove div for checked selected value*/ 
function addAndRemoveEachCheckedSelectedVal() {
    var modal1CheckedLength = $('.checkbox-click-enhancement:checked');
    var modal2CheckedLength = $('.checkbox-click-welfare:checked');

    if ($(this).attr('class') == 'checkbox-click-enhancement') {
        var currentChkId = $(this).attr("id");
        // checked/unchecked all enhancement check box
        if (modal1CheckedLength.length == $('#modal1 input:checkbox').length) {
            $("#modal1CheckedAll").prop("checked", true);
        } else {
            if (modal1CheckedLength.length == 0) {
                $("#displayed_text").show();
            }
            $("#modal1CheckedAll").prop('checked', false);
        }
    } else {
        var currentChkId = $(this).attr("id");
        // checked/unchecked all welfare check box
        if (modal2CheckedLength.length == $('#modal2 input:checkbox').length) {
            $("#modal2CheckedAll").prop("checked", true);
        } else {
            if (modal2CheckedLength.length == 0) {
                $("#displayed_text").show();
            }
            $("#modal2CheckedAll").prop('checked', false);
        }
    }
    var local_detail = $("#welfare");
    //show and hide original text area
    if (modal1CheckedLength.length == 0 && modal2CheckedLength.length == 0) {
        $("#displayed_text").show();
    } else {
        $("#displayed_text").hide();
    }

    if ($(this).prop('checked')) {
        var div = document.createElement('div');
        div.id = this.id;
        div.innerHTML = $("label[for="+currentChkId+"]").text();
        div.className = 'welfare ' + this.id;
        local_detail.append(div);
    }
    else {
        $("." + $(this).attr('id')).remove();
    }
}

/*dynamically add and remove div for all checked condition*/
function addAndRemoveAllCheckedSelectedVal() {
    //filter duplicate data
    var modal1InitLength = $('.checkbox-click-enhancement:checked');
    var modal2InitLength = $('.checkbox-click-welfare:checked');
    if ((modal1InitLength.length >= 1 && modal1InitLength.length < 5) || (modal2InitLength.length >= 1 && modal2InitLength < 61)) {
        $("#welfare").empty();
    }
    var id_val;
    if ($(this).attr('id') == 'modal1CheckedAll') {
        id_val = 'modal1';
    } else {
        id_val = 'modal2';
    }
    $("#" + id_val + " input[type=checkbox]").prop('checked', $(this).prop('checked'));
    $("#" + id_val + ' input[type=checkbox]').each(function () {
        var currentChkId = $(this).attr("id");
        var local_detail = $("#welfare");
        //show and hide original text area 
        var modal1CheckedLength = $('.checkbox-click-enhancement:checked');
        var modal2CheckedLength = $('.checkbox-click-welfare:checked');
        if (modal1CheckedLength.length == 0 && modal2CheckedLength.length == 0) {
            $("#displayed_text").show();
        } else {
            $("#displayed_text").hide();
        }

        if ($(this).prop('checked')) {
            var div = document.createElement('div');
            div.id = this.id;
            div.innerHTML = $("label[for="+currentChkId+"]").text();
            div.className = 'welfare ' + this.id;
            local_detail.append(div);
        }
        else {
            $("." + this.id).remove();
        }
    });
}