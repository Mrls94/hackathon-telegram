class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.json :provider_info
      t.json :task_manager_info
      t.json :repository_info

      t.timestamps
    end
  end
end
