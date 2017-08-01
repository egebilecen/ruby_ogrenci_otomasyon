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

  def self.updateStudent student, _autoUpdateDB=true
    begin
      writeData = ""
      studentDatas = parseAllData DB::PATH["student"]
      studentDatas[student["index"]] = student
      memoryIndex = student["index"]

      for std in studentDatas
        std.delete("index")
        writeData += hashToJSON(std) + "\n"
      end

      if writeFile DB::PATH["student"],writeData
        if _autoUpdateDB
          $db.updateDB
          student["index"] = memoryIndex
          $db.setCurrentUser student
        end
        return true
      else
        return false
      end
    rescue Exception => err
      print "[[HATA]]: ",err.message,"\n",err.backtrace,"\n\n" if $SETTINGS["forceError"] || ($SETTINGS["debug"] && err.message != "debug")
      return false
    end
  end
end