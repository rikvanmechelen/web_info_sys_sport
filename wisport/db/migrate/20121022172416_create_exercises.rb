class CreateExercises < ActiveRecord::Migration
  def change
    create_table :exercises do |t|
      t.string :name
      t.integer :user_id
      t.string  :visibility
      t.string :type
      t.float :distance, :default => 0 #in km
			t.string :unit
      t.integer :reps, :default => 0
      t.integer :hours, :default => 0
      t.integer :minutes, :default => 0
      t.integer :seconds, :default => 0

      t.references :owner
      t.references :information

      t.timestamps
    end
  end
end
