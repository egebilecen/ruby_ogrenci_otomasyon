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

  # @return student obj if username,password matches, false on error
  def studentLoginControl studentObj
    index = 0
    for student in @@STUDENT_LIST
      if student["username"] == studentObj["username"] && student["password"] == studentObj["password"]
        student["index"] = index
        return student
      else
        index += 1
      end
    end
    return false
  end
end