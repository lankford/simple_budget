require './members'

# This program calculates what someone/s make per month, per year,
# and what they can afford to pay monthly for a living space

def clear_the_screen
  Gem.win_platform? ? (system "cls") : (system "clear")
end

def get_input message
  print message
  gets.chomp
end

class Group

  attr_reader :number_of_people

  def initialize
    @number_of_people = get_input("How many people is this budget for? ").to_i
  end

  def create_members
    @number_of_people.times.reduce([]) do |members,user_number|
      member = Member.new user_number
      members.push member
    end
  end

  def members
    @members ||= create_members
  end

  def combined_monthly
    members.reduce(0) { |total,user| total += user.monthly_income }
  end

  def combined_annual
    members.reduce(0) { |total,user| total += user.annual_income }
  end

  def living
    combined_monthly * 0.3
  end

  def bills
    combined_monthly * 0.2
  end

  def gas
    combined_monthly * 0.2
  end

  def groceries
    combined_monthly * 0.18
  end

  def leftover
    combined_monthly - (living + bills + gas + groceries)
  end

  def individual_incomes
    members.reduce([]) { |incomes,user| incomes << "\n#{user.name} makes $#{sprintf('%.2f', user.monthly_income)} per month, and $#{sprintf('%.2f', user.annual_income)} per year." }
  end

end

clear_the_screen

group              = Group.new
members            = group.members

combined_monthly   = group.combined_monthly
combined_annual    = group.combined_annual

living             = group.living
bills              = group.bills
gas                = group.gas
groceries          = group.groceries
leftover           = group.leftover

individual_incomes = group.individual_incomes

file_name          = get_input "\n\nWhat would you like to name your budget? "
file_name          = "#{file_name}.txt"

output_file        = open(file_name, 'w')
output_file.write individual_incomes.join
output_file.write msg = <<MSG

Combined, this household makes $#{sprintf('%.2f', combined_monthly)} per month, and $#{sprintf('%.2f', combined_annual)} per year.

Here is a break down of your monthly budget:
  * You can afford a living expense of $#{sprintf('%.2f', living)}.
  * You can afford $#{sprintf('%.2f', bills)} in bills.
  * You can afford $#{sprintf('%.2f', gas)} in gas.
  * You can afford $#{sprintf('%.2f', groceries)} in groceries and food.

This leaves you with roughly $#{sprintf('%.2f', leftover)} left over
for spending and saving.
Keep in mind that these estimates are based on averages,
and provide room for flexibility.
Also remember to try and stay under budget so that
you have more left over each month.
MSG

clear_the_screen

puts info = <<INFO
Your budget can be found in the same folder as this program:

#{Dir.pwd}

Thank you for using Simple Budget!

INFO
