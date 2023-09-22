$(function(){
    mergeFieldWithErrorsForTermsandConditions();
    mergeFieldWithErrorsForprivacyPolicy();
    
    function mergeFieldWithErrorsForTermsandConditions() {
        var fields = $('.terms-and-conditions .field_with_errors');
        fields.first().append(fields.not(':first').children())
        fields.not(":first").remove();
      }

      function mergeFieldWithErrorsForprivacyPolicy(){
        var fields = $('.privacy-policy .field_with_errors');
        fields.first().append(fields.not(':first').children())
        fields.not(":first").remove();
      }
     //  to check user name lenght or not email
      // $("#username")[0].oninvalid = function () {
      //     this.setCustomValidity("半角数字の情報を入力してください。");
      //     return;
      // };
  })