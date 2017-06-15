require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    new_student = self.new
    new_student.id, new_student.name, new_student.grade = row
    new_student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    DB[:conn].execute("SELECT * FROM students").map do |student|
      self.new_from_db(student)
    end
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    query = <<-SQL
      SELECT * FROM students WHERE name = ?
        SQL
    return_value = DB[:conn].execute(query, name)[0]
    new_student = self.new_from_db(return_value)
  end

  def self.count_all_students_in_grade_9
    query = <<-SQL
      SELECT * FROM students WHERE grade = 9
        SQL
    DB[:conn].execute(query)
  end

  def self.students_below_12th_grade
    query = <<-SQL
      SELECT * FROM students WHERE grade < 12
        SQL
    DB[:conn].execute(query)
  end

  def self.first_x_students_in_grade_10(num)
    query = <<-SQL
      SELECT * FROM students WHERE grade = 10 LIMIT ?
        SQL
    DB[:conn].execute(query, num)
  end

  def self.first_student_in_grade_10
    query = <<-SQL
      SELECT * FROM students WHERE grade = 10 LIMIT 1
        SQL
    student = self.new_from_db(DB[:conn].execute(query)[0])
  end

  def self.all_students_in_grade_x(grade)
    query = <<-SQL
      SELECT * FROM students WHERE grade = 10
        SQL
    DB[:conn].execute(query)
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
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
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
