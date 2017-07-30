def checkCommand command,permittedCommands
  return true if $SETTINGS["debug"]
  if permittedCommands.include?command
    return true
  else
    return false
  end
end

# File Functions #
# @return: false on fail, readed data from file on success
def readFile fileName
  begin
    f = File.new fileName, 'r'
    r = f.readlines.join ''
    f.close
    return r
  rescue
    return false
  end
end

# @return: true on successfully write, false on fail
def writeFile fileName,dataToWrite
  begin
    f = File.new fileName, 'w'
    f.write dataToWrite
    f.close
    return true
  rescue
    return false
  end
end

# @return: true on successfully write, false on fail
def appendFile fileName,dataToWrite,_EOL=true
  begin
    f = File.new fileName, 'a'
    f.write dataToWrite
    f.write "\n" if _EOL
    f.close
    return true
  rescue
    return false
  end
end

# @return: string on successfully generate, false on fail
def hashToJSON hash
  begin
    return JSON.generate(hash)
  rescue
    return false
  end
end

# @return: hash on successfully parse, false on fail
def JSONtoHash string
  begin
    return JSON.parse(string)
  rescue
    return false
  end
end

# JSON parse all data of file that splited with specific string
def parseAllData fileName,_sep="\n"
  content = readFile fileName
  if !content then return false
  else
    content = content.split(_sep)
    returnData = []
    for con in content
      returnData.push JSONtoHash con
    end

    return returnData
  end
end