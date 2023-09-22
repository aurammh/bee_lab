class CreateMRegions < ActiveRecord::Migration[6.1]
  def change
    create_table :m_regions do |t|
      t.string :region_name,comment: 'select the type of region on screen'
      t.boolean :delete_flag ,:default => 'false', comment: ' default = false, deleted = true'
      t.timestamps
    end
  end
end
