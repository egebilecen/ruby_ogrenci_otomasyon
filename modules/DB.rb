class DB
  PATH = {
      "student"=>"db/student.txt",
      "teacher"=>"db/teacher.txt"
  }
  def initialize
    @@STUDENT_LIST = nil
    @@TEACHER_LIST = nil

    updateDB
  end

  def showDBPaths
    return PATH
  end

  def showDB
    return {
        "student" => @@STUDENT_LIST,
        "teacher" => @@TEACHER_LIST
    }
  end

  def updateDB
    @@STUDENT_LIST = parseAllData PATH['student']
    @@TEACHER_LIST = parseAllData PATH['teacher']
  end
end