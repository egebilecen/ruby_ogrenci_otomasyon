class Menu
  def initialize
    @permittedCommands = {
        "mainMenu"    => ["a","b","c","d","debug"], # permitted commands of main menu
        "studentMenu" => ["a","b","c","d","e","debug"]
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

    registerResponse = Student.new.createStudent student
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

  def showStudentMenu text
    system "clear"
    print "=== Öğrenci İşlemleri ===\n",
          "a)Dersleri Gör\n",
          "b)Ders Notlarını Gör\n",
          "c)Ders Ekle\n",
          "d)Ders Sil\n",
          "e)Ders Notu Güncelle\n\n"
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
            when @permittedCommands["studentMenu"][0]
              nil
            when @permittedCommands["studentMenu"][1]
              nil
            when @permittedCommands["studentMenu"][2]
              nil
            when @permittedCommands["studentMenu"][3]
              nil
            when @permittedCommands["studentMenu"][4]
              nil
            when @permittedCommands["studentMenu"][5]
              $SETTINGS["debug"] = true
              raise Exception, "debug"
          end
        end
      end
    rescue Exception => err
      print "[Öğrenci] Doğru bir komut giriniz!\n\n" if err.message != "debug"
      print "[Öğrenci] [[HATA]]: ",err.message,"\n",err.backtrace,"\n\n" if $SETTINGS["forceError"] || ($SETTINGS["debug"] && err.message != "debug")
      retry
    end
  end
end