module CommonHelper
    def permission_check_box(type_id,user_id)
        @permissions.each do |data|
         if data.admin_permission_type_id == type_id &&  data.user_id == user_id
            return true
         end
        end
        return false
    end
    
    #get data for select box
    def industry_type_options
        MIndustry.all
    end
    
    def region_options
        MRegion.select(:id,:region_name).order(id: :asc)
    end
    
    def prefecture_options
        MPrefecture.all
    end

    def qualification_options
        MQualification.select(:id,:qualification_category).order(id: :asc)
    end

    def qualification_details_options
        MQualificationDetail.select(:id,:qualification_type).order(id: :asc)
    end

    def occupation_options
        MOccupation.select(:id,:occupation_name).order(id: :asc)
    end

    def welfare_options
        MWelfare.select(:id,:welfare_category).order(id: :asc)
    end

    def welfare_detail_options
        MWelfareDetail.select(:id,:welfare_type).order(id: :asc)
    end

    #get prefecture according region
    def prefecture_name_list
        region_id = params[:id]
        prefecture_name_list = MPrefecture.select(:id, :prefecture_name).where(m_region_id: region_id).order("id asc")
        render json: prefecture_name_list
    end

    #get value from json object
    def getJsonKey (hashArray)
        keyVal = [] 
        unless hashArray.nil?  
        hashArray.each {|k, v| keyVal << v }
        end
        keyVal
    end
    
    # get qualification category name
    def get_qualification_category(qualification_category)
        if qualification_category.any?
            qualification_category_name = qualification_category.select { |item| nil != item }
            MQualification.where("id IN (#{qualification_category_name.join(',')})").map { |qc| [qc.qualification_category]}.join(', ')
        end
    end

    # get qualification detail
    def get_qualificaion_type(qualification_type)
        if qualification_type.any?
            qualification_type_name = qualification_type.select { |item| nil != item }
            MQualificationDetail.where("id IN (#{qualification_type_name.join(',')})").map { |qt| [qt.qualification_type]}.join(', ')
        end
    end

    # get selected MPrefecture name by id
    def get_MPrefecture_by_id(postal_prefecture_id)
        if postal_prefecture_id.present?
            MPrefecture.find(postal_prefecture_id).prefecture_name
        end
    end

    # get selected industry name
    def get_industry_name(industry_id)
        if industry_id.any?
            industryType = industry_id.select { |item| nil != item }
            MIndustry.where("id IN (#{industryType.join(',')})").map { |ind| [ind.industry_name]}.join(', ')
        end
    end

    # get selected occupation name
    def get_occupation_name(job_id)
        if job_id.any?
            jobType = job_id.select { |item| nil != item }
            MOccupation.where("id IN (#{jobType.join(',')})").map { |jt| [jt.occupation_name]}.join(', ')
        end
    end

    # get selected location name
    def get_region_name(region_id)
        if region_id.present?
            MRegion.find(region_id).region_name
        end
    end

    # get selected prefecture name
    def get_prefecture_name(prefecture_id)
        if prefecture_id.any?
            prefecture_name = prefecture_id.select { |item| nil != item }
            MPrefecture.where("id IN (#{prefecture_name.join(',')})").map { |p| [p.prefecture_name]}.join(', ')
        end
    end

    # get selected industry name by ID
    def get_industry_name_by_ID(industry_id)
        if industry_id.present?
            MIndustry.find(industry_id).industry_name
        end
    end

    # create data with hash
    def get_hash_value(obj)
        @count = Hash.new
        obj.each do |e|
            @count[e.id] = e.join_count
        end
    end

    # convert image base64 type to blob
    def convert_Base64_imgData(b64_params)
        filename = b64_params.split(",")[0];
        blob = ActiveStorage::Blob.create_after_upload!(
        io: StringIO.new((Base64.decode64(b64_params.split(",")[2]))),
        filename: filename,
        content_type: "image/jpeg",
        )
    end

    # get speaker name for communication tool
    def get_speaker_name(speaker_id)
        if current_user.user_type == 1 
            if current_user.id == speaker_id
                @speaker_name = Company::Company.find_by(:user_id => speaker_id).company_name
            else
                student_info = Student::Student.find_by(:user_id => speaker_id)
                @speaker_name = student_info.last_name+" "+student_info.first_name
            end
        else
            if current_user.id == speaker_id
                student_info = Student::Student.find_by(:user_id => speaker_id)
                @speaker_name = student_info.last_name+" "+student_info.first_name
            else
                @speaker_name = Company::Company.find_by(:user_id => speaker_id).company_name
            end
        end
    end

    # get unread conversation
    def new_communication_array
        @new_communication_arr = []
        new_communication = Communication::Notification.where(receiver_id: current_user.id)
        @new_communication_arr = new_communication.map{|data| data.record_id} unless @new_communication.present?
    end

    #get date and time for communication tools
    def time_date(date)
        if date.year > Time.now.year
          date.strftime('%d/%m/%y')
        else 
          date.to_date == Time.now.to_date ? "Today "+date.strftime('%l:%M %P') : date.strftime('%b %d')
        end
      end
end