class CreateMPrefectures < ActiveRecord::Migration[6.1]
  def change
    create_table :m_prefectures do |t|
      t.belongs_to :m_region
      t.string :prefecture_name,comment: 'select the type of List of prefecture denpen on region'
      t.boolean :delete_flag ,:default => 'false', comment: ' default = false, deleted = true'
      t.timestamps
    end
  end
end
