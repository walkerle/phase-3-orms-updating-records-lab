require 'pry'
require 'sqlite3'
require_relative '../lib/student'

DB = {:conn => SQLite3::Database.new("db/students.db")}

def reset_database
  Student.drop_table
  Student.create_table
end

reset_database

# Student.create("Tonka", "9th")
# Student.create("Lola", "10th")
# Student.create("Lady Kay", "11th")

# binding.pry
# 0