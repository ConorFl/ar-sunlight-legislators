require 'csv'
require_relative '../app/models/congress_member'
RELEVANT_FIELDS = [:id,:title,:first_name,:middle_name,:last_name,:name_suffix,:gender,:party,:state,:in_office,:phone,:fax,:website,:twitter_id,:birthdate]
class SunlightLegislatorsImporter
  def self.import(filename=File.dirname(__FILE__) + "/../db/data/legislators.csv")
    csv = CSV.new(File.open(filename), :headers => true, :header_converters => :symbol)
    csv.each do |row|
      attribute_hash = {}
      row.each do |field, value|
        value = value.gsub("-", "") if field == :phone || field == :fax
        attribute_hash[field] = value if RELEVANT_FIELDS.include? field
      end
      congress_member = CongressMember.create!(attribute_hash)
    end
  end
end

# begin
#   raise ArgumentError, "you must supply a filename argument" unless ARGV.length == 1
#   SunlightLegislatorsImporter.import(ARGV[0])
# rescue ArgumentError => e
#   $stderr.puts "Usage: ruby sunlight_legislators_importer.rb <filename>"
# rescue NotImplementedError => e
#   $stderr.puts "You shouldn't be running this until you've modified it with your implementation!"
# end
