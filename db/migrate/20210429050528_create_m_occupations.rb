class CreateMOccupations < ActiveRecord::Migration[6.1]
  def change
    create_table :m_occupations do |t|
      t.string :occupation_name,comment: 'select the type of occupation name on screen'
      t.boolean :delete_flag ,:default => 'false', comment: ' default = false, deleted = true'
      t.timestamps
    end
  end
end
