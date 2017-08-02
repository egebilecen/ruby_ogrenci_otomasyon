class Menu
  def initialize
    @permittedCommands = {
        "mainMenu"    => ["a","b","c","d","debug"], # permitted commands of main menu
        "studentMenu" => ["a","b","c","d","debug"]
    }
  end

  def showPermittedCommands
    return @permittedCommands
  end

  def showMainMenu text=""
    system "clear"
    print "=== Öğrenci Otomasyonu ===\n\n",
          "|== Giriş Yap ==|\n",
          "a)Öğrenci Girişi\n",
          "b)Öğretmen Girişi\n\n",
          "|== Kayıt Bölümü ==|\n",
          "c)Öğrenci Kayıt Ol\n",
          "d)Öğretmen Kayıt Ol\n\n"
    print text if text != ""
    begin
      if !$SETTINGS["debug"]
        print "Komut >> "
        $command = gets.chomp
      end

      if !checkCommand $command, @permittedCommands["mainMenu"]
        raise Exception, "Hatalı komut!"
      else
        if $SETTINGS["debug"]
          while 1
            print "[DEBUG] Komut >> "
            $command = gets.chomp
            case $command
              when "showdb"
                print "\n\n",$db.showDB,"\n\n"
              when "updatedb"
                $db.updateDB
                print "DB güncellendi!\n\n"
              when "show_current_user"
                print "\n\n",$db.showCurrentUser,"\n\n"
              when "close"
                system "clear"
                $SETTINGS["debug"] = false
                raise Exception, "debug"
              else raise Exception, "Debug: Komut yok!"
            end
          end
        else
          case $command
            when @permittedCommands["mainMenu"][0]
              showStudentLoginScreen
            when @permittedCommands["mainMenu"][1]
              showTeacherLoginScreen
            when @permittedCommands["mainMenu"][2]
              showStudentRegisterScreen
            when @permittedCommands["mainMenu"][3]
              showTeacherRegisterScreen
            when @permittedCommands["mainMenu"][4]
              $SETTINGS["debug"] = true
              raise Exception, "debug"
          end
        end
      end
    rescue Exception => err
      print "Doğru bir komut giriniz!\n\n" if err.message != "debug"
      print "[[HATA]]: ",err.message,"\n",err.backtrace,"\n\n" if $SETTINGS["forceError"] || ($SETTINGS["debug"] && err.message != "debug")
      retry
    end
  end

  def showStudentLoginScreen
    system "clear"
    print "== Öğrenci Giriş Sistemi ==\n"

    student = {}
    print "Kullanıcı Adı: "
    student["username"] = gets.chomp

    print "Şifre: "
    student["password"] = gets.chomp

    loginResponse = $db.studentLoginControl student
    if loginResponse
      $db.setCurrentUser loginResponse
      showStudentMenu "[?]Başarıyla giriş yaptınız.\n\n"
    else
      showMainMenu "[!]Kullanıcı adı veya şifre yanlış!\n\n"
    end
  end

  def showTeacherLoginScreen
    system "clear"
    print "== Öğretmen Giriş Sistemi ==\n"

    print "Kullanıcı Adı: "
    username = gets.chomp

    print "Şifre: "
    password = gets.chomp
  end

  def showStudentRegisterScreen
    system "clear"
    print "=== Öğrenci Kayıt Sistemi ===\n"

    student = {}
    print "Kullanıcı adı: "
    student["username"] = gets.chomp

    print "Parola: "
    student["password"] = gets.chomp

    print "Ad: "
    student["name"] = gets.chomp

    print "Soyad: "
    student["surname"] = gets.chomp

    print "Okul: "
    student["school"] = gets.chomp

    print "Bölüm: "
    student["section"] = gets.chomp

    student["lessons"] = []

    registerResponse = Student::createStudent student
    if registerResponse == true
      showMainMenu "[?]Başarıyla kayıt oldunuz.\n\n"
    elsif registerResponse == 2
      showMainMenu "[!]Bu kullanıcı adı kullanımda.\n\n"
    else
      showMainMenu "[!]Kayıt esnasında bir hata oluştu!\n\n"
    end
  end

  def showTeacherRegisterScreen
    system "clear"
    print "=== Öğretmen Kayıt Sistemi ===\n"

    teacher = {}
    print "Kullanıcı adı: "
    teacher["username"] = gets.chomp

    print "Şifre: "
    teacher["password"] = gets.chomp

    print "Ad: "
    teacher["name"] = gets.chomp

    print "Soyad: "
    teacher["surname"] = gets.chomp

    print "Okul: "
    teacher["school"] = gets.chomp

    registerResponse = Teacher.new.createTeacher teacher
    if registerResponse == true
      showMainMenu "[?]Başarıyla kayıt oldunuz.\n\n"
    elsif registerResponse == 2
      showMainMenu "[!]Bu kullanıcı adı kullanımda.\n\n"
    else
      showMainMenu "[!]Kayıt esnasında bir hata oluştu!\n\n"
    end
  end

  def showStudentMenu text=""
    system "clear"
    print "=== Öğrenci İşlemleri ===\n",
          "a)Dersleri ve notları Gör\n",
          "b)Ders Ekle\n",
          "c)Ders Sil\n",
          "d)Ders Notu Güncelle\n\n"
    print text if text != ""

    begin
      if !$SETTINGS["debug"]
        print "[Öğrenci] Komut >> "
        $command = gets.chomp
      end

      if !checkCommand $command, @permittedCommands["studentMenu"]
        raise Exception, "[Öğrenci] Hatalı komut!"
      else
        if $SETTINGS["debug"]
          while 1
            print "[DEBUG] Komut >> "
            $command = gets.chomp
            case $command
              when "close"
                system "clear"
                $SETTINGS["debug"] = false
                raise Exception, "debug"
              else raise Exception, "[Öğrenci] Debug: Komut yok!"
            end
          end
        else
          case $command
            when @permittedCommands["studentMenu"][0] # ders ve notları gör
              system "clear"
              currentUser = $db.showCurrentUser
              print "=== Dersleriniz ===\n"
              if currentUser["lessons"].length < 1
                print "Henüz ders eklememişsiniz.\n\n"
              else
                for lesson in currentUser["lessons"]
                  print "Ders Adı: #{lesson["name"]}\n","Ders Notları: #{lesson["notes"].join " - "}\n\n"
                end
              end
              returnToMenu "Öğrenci menüsüne dönmek ister misiniz?",method(:showStudentMenu),studentExitMessage
            when @permittedCommands["studentMenu"][1] # ders ekle
              system "clear"
              student = $db.showCurrentUser
              begin
                print "Kaç ders ekliceksiniz? "
                lessonCount = Integer gets.chomp

                for i in 0...lessonCount
                  lesson = {}
                  print "\nDers adı: "
                  lesson["name"] = gets.chomp

                  print "Ders Notları(virgül ile ayırınız): "
                  lesson["notes"] = (gets.chomp).split(",")

                  student["lessons"].push lesson
                end
                if Student::updateStudent student
                  $db.setCurrentUser student
                  print "Öğrenci verileri başarıyla güncellendi.\n\n"
                  returnToMenu studentReturnMessage,method(:showStudentMenu),studentExitMessage
                else
                  print "Öğrenci verisi güncellenirken bir hata oluştu!\n\n"
                  returnToMenu studentReturnMessage,method(:showStudentMenu),studentExitMessage
                end
              rescue Exception => err
                if err.message != "hidden"
                  print "Lütfen geçerli bir şey giriniz.\n\n" if err.message != "debug"
                  print "[Öğrenci] [[HATA]]: ",err.message,"\n",err.backtrace,"\n\n" if $SETTINGS["forceError"] || ($SETTINGS["debug"] && err.message != "debug")
                  retry
                end
              end
            when @permittedCommands["studentMenu"][2] # ders sil
              system "clear"
              print "=== Ders Sil ===\n"
              index = 0
              for lesson in $db.showCurrentUser["lessons"]
                print "##{index} #{lesson["name"]}\n"
                index += 1
              end
              begin
                print "\nSilinicek ders id'sini giriniz: "
                lessonID = Integer gets.chomp

                if lessonID > index - 1 || lessonID < 0
                  print "Lütfen doğru bir id giriniz!\n"
                  raise Exception,"hidden"
                else
                  $db.showCurrentUser["lessons"].delete_at lessonID
                  if Student::updateStudent $db.showCurrentUser
                    print "Seçtiğiniz ders başarıyla silindi!\n\n"
                    returnToMenu studentReturnMessage,method(:showStudentMenu),studentExitMessage
                  else
                    print "Öğrenci verisi güncellenirken bir hata oluştu!\n\n"
                    returnToMenu studentReturnMessage,method(:showStudentMenu),studentExitMessage
                  end
                end
              rescue Exception => err
                if err.message != "hidden"
                  print "Lütfen bir sayı giriniz!\n\n"
                  print "[Öğrenci] [[HATA]]: ",err.message,"\n",err.backtrace,"\n\n" if $SETTINGS["forceError"] || ($SETTINGS["debug"] && err.message != "debug")
                end
                retry
              end
            when @permittedCommands["studentMenu"][3] # ders notu güncelle
              system "clear"
              print "=== Ders Notu Güncelle ===\n"
              index = 0
              for lesson in $db.showCurrentUser["lessons"]
                print "##{index} #{lesson["name"]}\n"
                index += 1
              end
              begin
                print "Düzenlenecek ders id'sini giriniz: "
                lessonID = Integer gets.chomp

                if lessonID < 0 || lessonID > index - 1
                  print "Lütfen doğru bir ID giriniz!"
                  raise Exception, "hidden"
                else
                  print "\n"
                  modeName = "[Düzenleme Modu]"
                  editedLesson = {}

                  print modeName," Ders Adı: "
                  editedLesson["name"] = gets.chomp

                  print modeName," Ders Notları(virgül ile ayırınız): "
                  editedLesson["notes"] = (gets.chomp).split(",")

                  $db.showCurrentUser["lessons"][lessonID] = editedLesson
                  if Student::updateStudent $db.showCurrentUser
                    print "Seçtiğiniz ders başarıyla güncellendi!\n\n"
                    returnToMenu studentReturnMessage, method(:showStudentMenu), studentExitMessage
                  else
                    print "Seçtiğiniz ders güncellenirken bir hata oluştu!\n\n"
                  end
                end
              rescue Exception => err
                if err.message != "hidden"
                  print "Lütfen bir sayı giriniz!\n\n"
                  print "[Öğrenci] [[HATA]]: ",err.message,"\n",err.backtrace,"\n\n" if $SETTINGS["forceError"] || ($SETTINGS["debug"] && err.message != "debug")
                end
                retry
              end
            when @permittedCommands["studentMenu"][4]
              $SETTINGS["debug"] = true
              raise Exception, "debug"
          end
        end
      end
    rescue Exception => err
      if err.message != "hidden"
        print "[Öğrenci] Doğru bir komut giriniz!\n\n" if err.message != "debug"
        print "[Öğrenci] [[HATA]]: ",err.message,"\n",err.backtrace,"\n\n" if $SETTINGS["forceError"] || ($SETTINGS["debug"] && err.message != "debug")
        retry
      end
    end
  end

  def returnToMenu displayText, functionToRun, exitMessage
    print displayText," [E/H] "
    @command = gets.chomp
    if @command == "e" then functionToRun.call
    else print exitMessage end
  end

  def studentReturnMessage
    return "Öğrenci menüsüne dönmek ister misiniz?"
  end

  def studentExitMessage
    return "\nSistemden başarıyla çıkış yaptınız.\n"
  end
end