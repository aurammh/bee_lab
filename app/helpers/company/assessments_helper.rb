module Company::AssessmentsHelper
    def student_thinking_priority_order_options
        Company::Assessment.student_thinking_priority_orders.each.map{ |k,v| [t("priority_text.student_thinking_priority_order.#{k}"), v] }
    end
    def company_item_priority_order_options
        Company::Assessment.company_item_priority_orders.each.map{ |k,v| [t("priority_text.company_item_priority_order.#{k}"), v] }
    end
end
