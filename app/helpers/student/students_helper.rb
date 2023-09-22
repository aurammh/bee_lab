module Student::StudentsHelper

    def school_type_options
        Student::Student.school_types.keys.map{ |k| [t("student.school_type.#{k}"), k] }
    end

    def subject_system_options
        Student::Student.subject_systems.keys.map{ |k| [t("student.subject_system.#{k}"), k] }
    end

    def is_beelab_activity_participate_options
        Student::Student.is_beelab_activity_participates.keys.map{ |k| [t("student.is_beelab_activity_participate.#{k}"), k] }
    end

    def gender_options
        Student::Student.genders.map { |k,v| [k, t("student.gender.#{k}")] }
    end
end