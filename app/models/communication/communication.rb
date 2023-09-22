class Communication::Communication < ApplicationRecord
    has_many :communication_detail ,class_name: "Communication::CommunicationDetail",foreign_key: "communication_id", dependent: :destroy
    has_rich_text :content
    has_one :action_text_rich_text,class_name: 'ActionText::RichText',as: :record
    self.table_name = "communications"

    # get first/main conversation list
    def get_conversation_list(login_user_id)
        Communication::Communication.select('communications.id,communications.id as communication_id,communications.created_at,
        action_text_rich_texts.body as content,communications.sender_id,communications.receiver_id,
        communications.title,communications.category')
        .left_joins(:communication_detail)
        .joins(:action_text_rich_text)
        .where("communication_details.id IS NULL AND (communications.sender_id= #{login_user_id} OR communications.receiver_id= #{login_user_id})")
        .order('communications.id desc')
    end

    # get latest conversation list
    def get_conversation_details_list(login_user_id)
        Communication::CommunicationDetail.select('distinct on(communication_details.communication_id) communication_id,communication_details.id,communication_details.created_at,
        action_text_rich_texts.body as content,communications.sender_id,communications.receiver_id,
        communications.title,communications.category')
        .joins(:communication,:action_text_rich_text)
        .where("communication_details.sender_id= ? OR communication_details.receiver_id= ?", login_user_id, login_user_id)
        .order('communication_details.communication_id,communication_details.created_at desc')
    end
end
