$(function(){
  /*file upload for student assessment*/
  $("#upload-assessemt").on("change", function(){
      $(".upload-assessemt-file").text(this.files[0].name);
  })

  /* self Eevaluation chart */
  var selfEvaluationChartData  =chartOne;
  var ctx = document.getElementById('selfEevaluationChart');

  var color = '#f4d01f';
  if($("#selfEevaluationChart").attr("name") == "detail"){
    color = '#204a9c';
  }
  var myChart = new Chart(ctx, {
      type: 'radar',
      data: {
          labels: ['A', 'B', 'C', 'D'],
          datasets:  [{
              label: '利き脳®診断簡易版アンケート',
              data: selfEvaluationChartData,
              fill: false,
              borderColor: color,
              pointBackgroundColor: color,
              pointBorderColor: '#fff',
              pointHoverBackgroundColor: '#fff',
              pointHoverBorderColor: color
            }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        animation: {
            animateScale: true,
            animateRotate: true
        },
        scale: {
            pointLabels: {
                fontSize: 20,
                 fontColor: "#212529"
            },
            ticks: {
                beginAtZero: true,
                min: 0,
                max: 100,
                stepSize: 20
            },
        },
        tooltips: {
          callbacks: {
            title: (tooltipItem, data) => data.labels[tooltipItem[0].index]
          }
        }
     }
  });

  /*potential desire chart */
  var potentialDesireChartData  =chartTwo;
  var ctx = document.getElementById('potentialDesireChart');
  if($("#potentialDesireChart").attr("name") == "detail"){
    color = '#204a9c';
  }
  var myChart = new Chart(ctx, {
      type: 'radar',
      data: {
          labels: ['A', 'B', 'C', 'D' , 'E'],
          datasets:  [{
              label: '潜在的欲求タイプチェックアンケート入力',
              data: potentialDesireChartData,
              fill: false,
              borderColor: color,
              pointBackgroundColor: color,
              pointBorderColor: '#fff',
              pointHoverBackgroundColor: '#fff',
              pointHoverBorderColor: color
            }],
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        animation: {
            animateScale: true,
            animateRotate: true
        },
        scale: {
            pointLabels: {
                fontSize: 20,
                fontColor: "#212529"
            },
            ticks: {
                beginAtZero: true,
                min: 0,
                max: 10,
                stepSize: 1
            },
        },
        tooltips: {
          callbacks: {
            title: (tooltipItem, data) => data.labels[tooltipItem[0].index]
          }
        }
     },
  });

  //* behavioral trait type chart  *// //
  getBehavioralChartBorder(chartThree[0] , "self_expression_chart");
  getBehavioralChartBorder(chartThree[1] , "self_assertion_chart");
  getBehavioralChartBorder(chartThree[2] , "self_flexibility_chart");

  //* behavioral trait type chart  *// //
  function getBehavioralChartBorder (val,chartID){
    $("#"+chartID+ " .col").removeClass( "graph-select" );

    if(val != "null"){
      if (val >= -10 && val <= -8 ) {
          $("#"+chartID+ " .bg-pink").addClass( "graph-select" );
      }
      else if (val >= -7 && val <= -3 ){
          $("#"+chartID+ " .bg-lightBlue").addClass( "graph-select" );
      }
      else if ( val >= -2 && val <= 2){
          $("#"+chartID+ " .bg-green").addClass( "graph-select" );
      }
      else if (val >= 3 && val <= 7){
          $("#"+chartID+ " .bg-blue").addClass( "graph-select" );
      }
      else { // (+8 ～ +10)
          $("#"+chartID+ " .bg-orange").addClass( "graph-select" );
      } 
    }
       
  }

})

