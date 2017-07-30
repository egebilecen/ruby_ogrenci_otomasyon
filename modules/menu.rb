class Menu
  # classı oluştur ve gerekli işlemleri yap
  def initialize
    @permittedCommands = ["a","b","c","d","debug"]
  end

  # izin verilen komutların olduğu diziyi döndür
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

      if !checkCommand $command, @permittedCommands
        raise Exception, "Hatalı komut!"
      else
        if $SETTINGS["debug"]
          while 1
            print "[DEBUG] Komut >> "
            $command = gets.chomp
            case $command
              when "showdb"
                print "\n\n",$db.showDB,"\n\n"
              when "close"
                system "clear"
                $SETTINGS["debug"] = false
                raise Exception, "debug"
              else raise Exception, "Debug: Komut yok!"
            end
          end
        else
          case $command
            when @permittedCommands[0]
              showStudentLoginScreen
            when @permittedCommands[1]
              showTeacherLoginScreen
            when @permittedCommands[2]
              showStudentRegisterScreen
            when @permittedCommands[3]
              showTeacherRegisterScreen
            when @permittedCommands[4]
              $SETTINGS["debug"] = true
              raise Exception, "debug"
          end
        end
      end
    rescue Exception => err
      print "Doğru bir komut giriniz!\n\n" if err.message != "debug"
      print "[[HATA]]: ",err,"\n\n" if $SETTINGS["debug"] && err.message != "debug"
      retry
    end
  end

  def showStudentLoginScreen
    system "clear"
    print "== Öğrenci Giriş Sistemi ==\n"

    print "Kullanıcı Adı: "
    username = gets.chomp

    print "Şifre: "
    password = gets.chomp
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
end