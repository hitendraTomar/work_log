class CreateWorkLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :work_logs do |t|

      t.references :user, foreign_key: true
      t.text       :worklog
      
      t.timestamps
    end
  end
end
