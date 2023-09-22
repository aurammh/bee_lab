module Student::AssessmentsHelper
    #call enum function for priority language
    def priority_language_options
        Student::Assessment.priority_languages.each.map{ |k,v| [t("student_assessment.priority_language.#{k}"), v] }
    end

    #call enum function for eng qualification
    def english_qualification_options
        Student::Assessment.english_qualifications.keys.map{ |k| [t("student_assessment.english_qualification.#{k}"), k] }
    end

    #call enum function for toefl_test
    def toefl_test_options
        Student::Assessment.toefl_tests.keys.map{ |k| [t("student_assessment.toefl_test.#{k}"), k] }
    end

    #call enum function for toeic_test
    def toeic_test_options
        Student::Assessment.toeic_tests.keys.map{ |k| [t("student_assessment.toeic_test.#{k}"), k] }
    end

    #for radar chart one
    def selfEevaluationChart_rank(student_assessment) 
        selfEevaluation_A , selfEevaluation_B , selfEevaluation_C , selfEevaluation_D = 0
        replaceArray = [0, 0, 0, 0]
    
          if student_assessment.nil? 
            @chartOne  = [0,0,0,0]
                  
          elsif  student_assessment.logical_and_rational.nil? or student_assessment.solid_and_planned.nil?
            @chartOne  = [0,0,0,0]    
    
          else        
            selfEevaluation_A  = sumValue(student_assessment.logical_and_rational) 
            selfEevaluation_B =  sumValue(student_assessment.solid_and_planned) 
            selfEevaluation_C =  sumValue(student_assessment.sensory_and_friendly)     
            selfEevaluation_D =  sumValue(student_assessment.adventurous_and_original)
            totalSum =  selfEevaluation_A + selfEevaluation_B + selfEevaluation_C + selfEevaluation_D
            selfEevaluation_A = calEachSum(totalSum.to_f,selfEevaluation_A.to_f)
            selfEevaluation_B = calEachSum(totalSum.to_f,selfEevaluation_B.to_f)
            selfEevaluation_C = calEachSum(totalSum.to_f,selfEevaluation_C.to_f)
            selfEevaluation_D = calEachSum(totalSum.to_f,selfEevaluation_D.to_f)
            @chartOne  = [selfEevaluation_A,selfEevaluation_B,selfEevaluation_C,selfEevaluation_D]
          end
          result = @chartOne.zip(replaceArray).map{ |x,y| x || y }
          rankArray = result.map{|value| result.select{|item| item > value }.size + 1 }
          rankedMap = {A: rankArray[0], B: rankArray[1] , C: rankArray[2], D: rankArray[3]}
          @rankedChartOne = rankedMap.sort_by {|k, v| v}    
    end

    #for radar chart two
    def potentialDesireType(student_assessment)
      love_and_desire_to_belong,desire_for_power_and_value,desire_for_freedom,desire_for_fun,desire_for_survival = 0
      @chartTwo = []
        if student_assessment.nil?
          @chartTwo = [0,0,0,0,0]
  
        elsif student_assessment.love_and_desire_to_belong.nil?  or student_assessment.desire_for_power_and_value.nil?
          @chartTwo = [0,0,0,0,0] 
  
        else  
        love_and_desire_to_belong = sumValue(student_assessment.love_and_desire_to_belong)
        desire_for_power_and_value = sumValue(student_assessment.desire_for_power_and_value) 
        desire_for_freedom = sumValue(student_assessment.desire_for_freedom)
        desire_for_fun = sumValue(student_assessment.desire_for_fun)
        desire_for_survival = sumValue(student_assessment.desire_for_survival)
        @chartTwo = [love_and_desire_to_belong,desire_for_power_and_value,desire_for_freedom,desire_for_fun,desire_for_survival]
        end
        rankArray = @chartTwo.map{|value| @chartTwo.select{|item| item > value }.size + 1 }
        rankedMap = {A: rankArray[0], B: rankArray[1] , C: rankArray[2], D: rankArray[3], E: rankArray[4]}
        @rankedChartTwo = rankedMap.sort_by {|k, v| v}
    end

    def behavioralTraitTypeChart_rank(student_assessment)
      self_expression , self_assertion , self_flexibility = 0
      if student_assessment.nil? 
        @chartThree = ["null","null","null"]
              
      elsif  student_assessment.self_expression.nil? or student_assessment.self_assertion.nil?
        @chartThree = ["null","null","null"]    
  
      else        
        self_expression = calBehavioralType(student_assessment.self_expression)
        self_assertion = calBehavioralType(student_assessment.self_assertion)
        self_flexibility = calBehavioralType(student_assessment.self_flexibility)
        @chartThree = [self_expression,self_assertion,self_flexibility]
      end
    end

    def sumValue(arrVal) 
      sum = arrVal.inject(0){|sum,x| sum + x } 
      sum
    end
  
    def calEachSum(totalSum,val) 
      dev = sprintf("%3.2f", (val/totalSum)*2).to_f
      total = (dev*100).to_i 
      total
    end

    def calBehavioralType (arrVal)

      countAtimes = 0
      countBtimes = 0

      # make the hash default to 0 so that += will work correctly
      b = Hash.new(0)

      # iterate over the array, counting duplicate entries
      arrVal.each do |v|
        b[v] += 1
      end

      b.each do |k, v|
        if k == 1
          countAtimes = v 
        else
          countBtimes = v
        end
      end
      total = countBtimes - countAtimes
      total
    end
end