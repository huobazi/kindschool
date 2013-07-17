class CreateStaffs < ActiveRecord::Migration
  def change
    create_table :staffs do |t|
      t.integer   :user_id
      t.string   :card_code
      t.string    :education
      t.string   :attendance_code
      t.timestamp :come_in_at
      t.timestamp :birthday
      t.timestamp :deleted_at
      t.timestamps
    end
  end
end
