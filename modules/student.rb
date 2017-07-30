class Student
  # @return: false on file method fails, true on if successfully append, return hash of student if autoSave is false
  def createStudent student,autoSave=true
    if autoSave
      begin
        isTaken = false
        for obj in $db.showDB["student"]
          if obj["username"] == student["username"]
            isTaken = true
            break
          end
        end
        if !isTaken
          appendFile DB::PATH["student"],hashToJSON(student)
          $db.updateDB
          return true
        else
          return 2
        end
      rescue
        return false
      end
    else
      return student
    end
  end
end