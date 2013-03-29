require_relative '../config'

# this is where you should use an ActiveRecord migration to 

class CreateCongressMembers < ActiveRecord::Migration
  def change
    create_table(:congress_members) do |congress_member|
      congress_member.column :id, :integer
      congress_member.column :title, :string
      congress_member.column :first_name, :string
      congress_member.column :middle_name, :string
      congress_member.column :last_name, :string
      congress_member.column :name_suffix, :string
      congress_member.column :gender, :string
      congress_member.column :party, :string
      congress_member.column :state, :string
      congress_member.column :in_office, :integer
      congress_member.column :phone, :string
      congress_member.column :fax, :string
      congress_member.column :website, :string
      congress_member.column :twitter_id, :string
      congress_member.column :birthdate, :string
    end
  end 
end
      
