class Admin::BackupDetail < ApplicationRecord
    self.table_name = "backup_details"
    has_one_attached :file_type
        # ActiveStorage::Blob.class_eval do
        #     before_create :generate_key_with_prefix
        
        #     def generate_key_with_prefix
        #       self.key = if prefix
        #         File.join prefix, self.class.generate_unique_secure_token
        #       else
        #         self.class.generate_unique_secure_token
        #       end
        #     end
        
        #     def prefix
        #       return 'dev-db-backup'
        #     end
        #   end

    def self.search_backupdetail(_search_query)
        _search_query = _search_query.delete_if { |_query| _query.empty? }
        _search_query = _search_query.join(' AND ')
        Admin::BackupDetail.select('backup_details.*').where(_search_query)
    end
end