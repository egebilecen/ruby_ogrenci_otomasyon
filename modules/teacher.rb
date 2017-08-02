class Teacher
  # @return: false on file method fails, true on if successfully append, return hash of student if autoSave is false
  def self.createTeacher teacher,autoSave=true
    if autoSave
      begin
        isTaken = false
        for obj in $db.showDB["teacher"]
          if obj["username"] == teacher["username"]
            isTaken = true
            break
          end
        end
        if !isTaken
          appendFile DB::PATH["teacher"],hashToJSON(teacher)
          $db.updateDB
          return true
        else
          return 2
        end
      rescue
        return false
      end
    else
      return teacher
    end
  end
end