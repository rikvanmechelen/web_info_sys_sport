class CreateInformation < ActiveRecord::Migration
  def change
    create_table :information do |t|
      t.string :media
      t.text :description
			t.references :exercise

      t.timestamps
    end
  end
end
