module Company::EventsHelper
    def event_category_options
        Company::Event.event_categories.map{ |k,v| [t("event.category.#{k}"),v] }
    end
end