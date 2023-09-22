class Communication::CommunicationDetail < ApplicationRecord
    belongs_to :communication, class_name: "Communication::Communication"
    self.table_name = "communication_details"
    has_rich_text :content
    has_one :action_text_rich_text,class_name: 'ActionText::RichText',as: :record
end
