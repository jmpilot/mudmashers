def osascript(script)
  system 'osascript', *script.split(/\n/).map { |line| ['-e', line] }.flatten
end

osascript <<-END
 tell application "Finder" to open location "http://www.google.com"
END