class ChangeNumberTypeInChecks < ActiveRecord::Migration[8.0]

  def up
    change_column :checks, :number, 'bigint USING number::bigint'
  end

  def down
    change_column :checks, :number, :string
  end
end
