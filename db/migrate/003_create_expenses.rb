class CreateExpenses < ActiveRecord::Migration[5.2]
  def change
    create_table :expenses do |t|
      t.integer :project_id,                :null => false
      t.date :date
      t.float :amount,       :default => 0, :null => false
      t.integer :paid_by,                   :null => false
      t.integer :payer_type,                :null => false # 0: user, 1: group
      t.text :description,   :default => ""
    end
   end
end
