# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'BudgetBuddy' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  pod 'FirebaseAnalytics'
  pod 'FirebaseAuth'
  pod 'FirebaseFirestore'

end

post_install do |installer|
  Dir.glob("Pods/leveldb-library/**/*.h").each do |header|
    text = File.read(header)
    new_contents = text.gsub(/#include "leveldb\/export.h"/, '#include <leveldb/export.h>')
    File.open(header, "w") { |file| file.puts new_contents }
  end
end
