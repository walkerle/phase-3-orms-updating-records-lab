# require_relative "../config/environment.rb"

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  attr_accessor :id, :name, :grade

  def initialize id = nil, name, grade
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
      )
    SQL

    DB[:conn].execute(sql)
  end
  
  def self.drop_table
    sql = 'DROP TABLE IF EXISTS students'

    DB[:conn].execute(sql)
  end

  def save # instance method => converts and creates an instance to a SQL database record

    if self.id
      self.update
    else
      sql = <<-SQL
        INSERT INTO students (name, grade) VALUES (?, ?)
      SQL
  
      DB[:conn].execute(sql, self.name, self.grade)
  
      self.id = DB[:conn].execute('SELECT last_insert_rowid() FROM students')[0][0]
    end

    self
  end

  def self.create name, grade # class method
    student = self.new(name, grade) # creates an Ruby class instance
    student.save # converts and creates the class instance into a SQL database record
  end

  def self.new_from_db row # SQL => Ruby
    # This method DOES NOT FIND the specific database record => Another method will handle the SELECT query
    self.new(row[0], row[1], row[2])
  end

  def self.find_by_name name # SQL => Ruby
    sql = <<-SQL
      SELECT * FROM students WHERE name = ? LIMIT 1
    SQL

    # Take note of what datatype/data shape .execute method returns
    row = DB[:conn].execute(sql, name).first
    # Alternate code:
    # row = DB[:conn].execute(sql, name)[0]
    # .execute returns an array of arrays (DB records)

    # Record already exists in SQL, so only need to instantiate the record
    # self.new(row[0], row[1], row[2])
    self.new_from_db row
  end

  def update # instance method: Ruby => SQL
    sql = <<-SQL
      UPDATE students SET name = ?, grade = ? WHERE id = ?
    SQL

    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

end
