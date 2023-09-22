class Student::Assessment < ApplicationRecord
    belongs_to :student, class_name: "Student::Student"
    self.table_name = "student_assessments"

    
    enum priority_language: { japanese: 1, english: 2, mandarin: 3, cantonese: 4, taiwanese: 5, korean: 6, arabia: 7 , intalian:  8, indonesia:  9, uzbek: 10, khmer: 11, singhala: 12, swedish: 13, spainish: 14, thai: 15, tamil: 16, german: 17, turkish: 18, nepal: 19, burmese: 20, hindi: 21, filipino: 22, french: 23, vietnamese: 24, persian: 25, bengal: 26, portuguese: 27, malay: 28, mongolian: 29, lao: 30, russian: 31}
    enum english_qualification: { speaking_integrate: 1, speaking_independent: 2, writing_integrate: 3, writing_independent: 4, listening: 5, reading: 6 }
    enum toefl_test: { ibt106: 1, ibt101: 2, ibt96: 3, ibt88: 4, ibt81: 5, ibt74: 6, ibt68: 7, ibt62: 8, ibt57: 9, ibt51h: 10, ibt51l: 11 }
    enum toeic_test: { m945: 1, m895: 2, m845: 3, m795: 4, m745: 5, m695: 6, m645: 7, m595: 8, m545: 9, m495h: 10, m495l: 11 }

    enum logical_and_rational_thinkings: { logical_and_rational_A: 1, logical_and_rational_B: 2, logical_and_rational_C: 3, logical_and_rational_D: 4, logical_and_rational_E: 5, logical_and_rational_F:6, logical_and_rational_G: 7, logical_and_rational_H: 8, logical_and_rational_I:9, logical_and_rational_J: 10 }

    enum solid_and_planned_thinkings: {solid_and_planned_A: 1, solid_and_planned_B: 2, solid_and_planned_C: 3, solid_and_planned_D: 4, solid_and_planned_E: 5, solid_and_planned_F:6, solid_and_planned_G: 7, solid_and_planned_H: 8, solid_and_planned_I:9, solid_and_planned_J: 10}

    enum sensory_and_friendly_thinkings: {sensory_and_friendly_A: 1, sensory_and_friendly_B: 2, sensory_and_friendly_C: 3, sensory_and_friendly_D: 4, sensory_and_friendly_E: 5, sensory_and_friendly_F:6, sensory_and_friendly_G: 7, sensory_and_friendly_H: 8, sensory_and_friendly_I:9, sensory_and_friendly_J: 10}

    enum adventurous_and_original_thinkings: {adventurous_and_original_A: 1, adventurous_and_original_B: 2, adventurous_and_original_C: 3, adventurous_and_original_D: 4, adventurous_and_original_E: 5, adventurous_and_original_F:6, adventurous_and_original_G: 7, adventurous_and_original_H: 8, adventurous_and_original_I:9, adventurous_and_original_J: 10}

    enum love_and_desires_lists: {love_and_desire_A: 1,love_and_desire_B: 2,love_and_desire_C: 3, love_and_desire_D: 4, love_and_desire_E: 5, love_and_desire_F:6, love_and_desire_G: 7, love_and_desire_H: 8, love_and_desire_I:9, love_and_desire_J: 10}

    enum desire_for_power_and_values_lists: {desire_for_power_and_values_A: 1, desire_for_power_and_values_B: 2, desire_for_power_and_values_C: 3, desire_for_power_and_values_D: 4, desire_for_power_and_values_E: 5, desire_for_power_and_values_F:6, desire_for_power_and_values_G: 7, desire_for_power_and_values_H: 8, desire_for_power_and_values_I:9, desire_for_power_and_values_J: 10}

    enum desire_for_freedoms_lists: {desire_for_freedoms_A: 1, desire_for_freedoms_B: 2, desire_for_freedoms_C: 3, desire_for_freedoms_D: 4, desire_for_freedoms_E: 5, desire_for_freedoms_F:6, desire_for_freedoms_G: 7, desire_for_freedoms_H: 8, desire_for_freedoms_I:9, desire_for_freedoms_J: 10}

    enum desire_for_funs_lists: {desire_for_funs_A: 1, desire_for_funs_B: 2, desire_for_funs_C: 3, desire_for_funs_D: 4, desire_for_funs_E: 5, desire_for_funs_F:6, desire_for_funs_G: 7, desire_for_funs_H: 8, desire_for_funs_I:9, desire_for_funs_J: 10}

    enum desire_for_survivals_lists: {desire_for_survivals_A: 1, desire_for_survivals_B: 2, desire_for_survivals_C: 3, desire_for_survivals_D: 4, desire_for_survivals_E: 5, desire_for_survivals_F:6, desire_for_survivals_G: 7, desire_for_survivals_H: 8, desire_for_survivals_I:9, desire_for_survivals_J: 10}

    enum self_expression_lists: {self_expression_A:{A:1,B:2},self_expression_B:{A:1,B:2},self_expression_C:{A:1,B:2},self_expression_D:{A:1,B:2},self_expression_E:{A:1,B:2},self_expression_F:{A:1,B:2},self_expression_G:{A:1,B:2},self_expression_H:{A:1,B:2},self_expression_I:{A:1,B:2} }

    enum self_assertion_lists: {self_assertion_A:{A:1,B:2},self_assertion_B:{A:1,B:2},self_assertion_C:{A:1,B:2},self_assertion_D:{A:1,B:2},self_assertion_E:{A:1,B:2},self_assertion_F:{A:1,B:2},self_assertion_G:{A:1,B:2},self_assertion_H:{A:1,B:2},self_assertion_I:{A:1,B:2} }

    enum self_flexibility_lists: {self_flexibility_A:{A:1,B:2},self_flexibility_B:{A:1,B:2},self_flexibility_C:{A:1,B:2},self_flexibility_D:{A:1,B:2},self_flexibility_E:{A:1,B:2},self_flexibility_F:{A:1,B:2},self_flexibility_G:{A:1,B:2},self_flexibility_H:{A:1,B:2},self_flexibility_I:{A:1,B:2} }

  
end
