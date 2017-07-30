class DB
  PATH = {
      "student"=>"db/student.txt",
      "teacher"=>"db/teacher.txt"
  }

  def initialize
    @@STUDENT_LIST = nil
    @@TEACHER_LIST = nil
    @@CURRENT_USER = nil
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
    return
  end

  def showCurrentUser
    return @@CURRENT_USER
  end

  def setCurrentUser userObj
    @@CURRENT_USER = userObj
    return
  end

  # @return
  def studentLoginControl studentObj
    for student in @@STUDENT_LIST
      return student if student["username"] == studentObj["username"] && student["password"] == studentObj["password"]
    end

    return false
  end
end