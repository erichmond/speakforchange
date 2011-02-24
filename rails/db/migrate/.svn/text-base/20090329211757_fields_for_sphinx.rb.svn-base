class FieldsForSphinx < ActiveRecord::Migration
  def self.up
    add_column :messages, :legislator_name, :text
    add_column :messages, :issue_name, :text
    Message.reset_column_information
    Message.all.each do |x|
      if x.is_a?(MessageToLegislator)
        x.legislator_name = x.legislator_names
      elsif x.issue
        x.issue_name = x.issue.title
      end
      x.save
    end
  end

  def self.down
    remove_column :messages, :issue_name
    remove_column :messages, :legislator_name
  end
end
