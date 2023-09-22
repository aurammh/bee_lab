module Admin::StudentManage::StudentHelper
    def student_school_activity(outside_school_activity)
        admin_school_activity = Array.new
        check_val =outside_school_activity.reject { |i| i.zero? }
        check_val.each_with_index do |v,i|
        admin_school_activity << t("student.outside_activity.#{Student::Student.outside_activities.key(i+1)}")
      end
      admin_school_activity.join (", ")
    end

    # Qualification Category Type for excel Download
    def get_qualification_category_type(qualification_category_id)
        category_name = Array.new
        category_id = qualification_category_id.select { |i|  i != nil }
        category_id.each do |data|
            category_name << @qualification_category_type[data]
        end
        category_name.join(', ')
    end

  # Qualification Type for excel Download
    def get_qualification_type(qualification_type_id)
        qualification_name = Array.new
        qualification_id = qualification_type_id.select { |i|  i != nil }
        qualification_id.each do |data|
          qualification_name << @qualification_type[data]
        end
        qualification_name.join(', ')
    end

  # Industry Type for excel Download
    def get_industry_type(desire_industry_type_id)
      industy_name = Array.new
      industry_id = desire_industry_type_id.select { |i|  i != nil }
      industry_id.each do |data|
        industy_name << @desire_industry_type[data]
      end
      industy_name.join(', ')
    end

# Occupation Type for excel Download
  def get_desire_job_type(desire_job_type_id)
      job_name = Array.new
      job_id = desire_job_type_id.select { |i|  i != nil }
      job_id.each do |data|
          job_name << @desire_job_type[data]
      end
      job_name.join(', ')
  end

# Region Type for excel Download
  def get_region_type(m_region_id)
      region_name = Array.new
      region_name << @region_type[m_region_id]
      region_name.join(', ')
  end

# Prefecture Type for excel Download
  def get_prefecture_type(m_prefecture_id)
      prefecture_name = Array.new
      qual = m_prefecture_id.select { |i|  i != nil }
      qual.each do |data|
          prefecture_name << @prefecture_type[data]
      end
      prefecture_name.join(', ')
  end

  def admin_gender_type_options
    Student::Student.genders.keys.map{ |k| [t("student.gender.#{k}"), k] }
  end

end