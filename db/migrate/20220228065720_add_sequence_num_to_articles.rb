class AddSequenceNumToArticles < ActiveRecord::Migration[6.0]

  def self.up
    add_column :articles, :sequence_num, :integer, null: false
    update_sequence_num_values
    add_index :articles, [:sequence_num, :company_id], unique: true
  end

  def self.down
    remove_index  :articles, column: [:sequence_num, :company_id]
    remove_column :articles, :sequence_num
  end

  def self.update_sequence_num_values
    Company.all.each do |parent|
      cntr = 1
      parent.articles.reorder("id").all.each do |nested|
        nested.sequence_num = cntr
        cntr += 1
        nested.save
      end
    end
  end
end