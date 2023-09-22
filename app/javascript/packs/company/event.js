import { Japanese } from "flatpickr/dist/l10n/ja";
$(function () {
    /*to get muliselect*/  
    $("#event_category").select2();

    /* 開催期間のカレンダー [even start date]*/
    flatpickr("#e_start_date",{
        minDate: "today",
        locale: Japanese,
        wrap: true,
        disableMobile: "true",
        onChange: function (selectedDates, dateStr, instance) {
            if (dateStr>$("#event_end_date").val()){
                $("#event_end_date").val('');
            }
            flatpickr("#e_end_date",{
                minDate: dateStr,
                locale: Japanese,
                wrap: true,
                disableMobile: "true"
            });
        }
    });
   /*開催期間のカレンダー [even end date]*/ 
   flatpickr("#e_end_date",{
        minDate: "today",
        locale: Japanese,
        wrap: true,
        disableMobile: "true",
        onChange: function (selectedDates, dateStr, instance) {
            if (dateStr < $("#event_start_date").val()){
                $("#event_start_date").val('');
            }
            flatpickr("#e_start_date",{
                minDate: "today",
                maxDate: dateStr,
                locale: Japanese,
                wrap: true,
                disableMobile: "true"
            });
        }
    });

    /*掲載期間のカレンダー [post start date]*/ 
    flatpickr("#p_start_date",{
        minDate: "today",
        locale: Japanese,
        wrap: true,
        disableMobile: "true",
        onChange: function (selectedDates, dateStr, instance) {
            if (dateStr>$("#post_end_date").val()){
                $("#post_end_date").val('');
            }
            flatpickr("#p_end_date",{
                minDate: dateStr,
                locale: Japanese,
                wrap: true,
                disableMobile: "true"
            });
        }
    });

    /*掲載期間のカレンダー [post end date]*/
   flatpickr("#p_end_date",{
        minDate: "today",
        locale: Japanese,
        wrap: true,
        disableMobile: "true",
        onChange: function (selectedDates, dateStr, instance) {
            if (dateStr < $("#post_start_date").val()){
                $("#post_start_date").val('');
            }
           flatpickr("#p_start_date",{
                minDate: "today",
                maxDate: dateStr,
                locale: Japanese,
                wrap: true,
                disableMobile: "true"
            });
        }
    });
    /*申込締切日のカレンダー [application deadline date]*/
    flatpickr("#application_deadline_picker", {
        wrap: true,
        minDate: "today",
        locale: Japanese,
        disableMobile: "true"
    });
});