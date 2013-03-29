require_relative '../../db/config'
require_relative 'congress_member'

class Main < ActiveRecord::Base

  def  self.legislators_from_state(state)
    senator_results = CongressMember.where("state = ? AND title = ?", state, 'Sen')
    rep_results = CongressMember.where("state = ? AND title = ?", state, 'Rep')
    print_congress_members(senator_results, 'Senators:')
    print_congress_members(rep_results, 'Representatives:')
  end
#NOTE: I did not sort by last name, as the csv is already sorted by last name ;)
  def self.print_congress_members(results, type_of_member)
    if results.any?
      puts type_of_member
      results.each do |congress_member|
        puts "\t #{congress_member.first_name} #{congress_member.last_name} (#{congress_member.party})"
      end
    end
  end

  def self.gender_counts(gender)
    all_senators = count_query("title = 'Sen' AND in_office = 1")
    gender_senators = count_query("title = 'Sen' AND gender = '#{gender}' AND in_office = 1")
    all_reps = count_query("title = 'Rep' AND in_office = 1")
    gender_reps = count_query("title = 'Rep' AND gender = '#{gender}' AND in_office = 1")
    print_gender_stats(all_senators, gender_senators, all_reps, gender_reps, gender)
  end

  def self.print_gender_stats(all_senators, gender_senators, all_reps, gender_reps, gender)
    gender_name = ""
    gender_name = 'Male' if gender == 'M'
    gender_name = 'Female' if gender == 'F'
    puts "#{gender_name} Senators: #{gender_senators} (#{gender_senators/all_senators.to_f*100}%)"
    puts "#{gender_name} Representatives: #{gender_reps} (#{gender_reps/all_reps.to_f*100}%)"
  end

  def self.count_query(query_string)
    CongressMember.count(:conditions => query_string)
  end

  def self.legislators_count_by_state
    raw_data = CongressMember.find(:all, :select => "state, title, count(*) as total_count", :group => "title, state")
    states = CongressMember.find(:all, :select => "state", :group => "state")
    hashed_data = {}
    states.each do |x|
      hashed_data[x.state] = [nil,nil] unless ['AS', 'DC', 'GU', 'MP', 'PR', 'VI'].include?(x.state)
    end
    raw_data.each do |x|
      if x.title == 'Sen'
        hashed_data[x.state][0] = x.total_count
      elsif x.title == 'Rep'
        hashed_data[x.state][1] = x.total_count
      end
    end
    hashed_data.each do |state_key, value|
      puts "#{state_key}: #{value[0]} Senators, #{value[1]} Representatives"
    end
  end
  #The totals method answers questions 4 AND 5 using the optional condition as 
  # => demonstrated on line 84.
  def self.totals(condition = "")
    puts count_query("title = 'Sen'#{condition}").to_s + "Senators"
    puts count_query("title = 'Rep'#{condition}").to_s + "Reps"
  end

  def active?(id)
    self.in_office == 1
  end

  def name(id)
    self.first_name + " " + self.middle_name + " " + self.last_name
  end
  # def self.find_yoder
  #   results = CongressMember.where("last_name = ?", 'Yoder')
  #   p results
  # end
end
Main.gender_counts('M')
Main.gender_counts('F')
Main.legislators_count_by_state
# Main.legislators_from_state('NJ')
Main.totals
Main.totals(" AND in_office = 1")
