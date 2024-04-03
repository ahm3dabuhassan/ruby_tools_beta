class FindAllFolders
    @@data = {
     :allFiles => nil,
     :allDir => {}
    }
    def initialize(patt)
         @pattern = patt
         @allDirectories = nil
         self.findFolders()
         self.addFolder()
    end
    def findFolders() 
        puts "find_folders: #{Dir.getwd}" 
         Dir.chdir("#{self.pattern}")
         @@data[:allFiles] = Dir.glob("*")
         @@data[:allFiles].each { |f|       
                 s = File.stat("#{self.pattern}/#{f}")
                 if s.directory? 
                     @@data[:allDir][f] = []
                     @@data[:allDir][f] <<  "#{self.pattern}/#{f}"
                 end 
         }
    end
    def addFolder(index=nil) 
        counter = 0
        @@data[:allDir].each { |key,value|
             if index != nil
                 for i in @@data[:allDir][key][index]
                     Dir.chdir("#{i}")
                     @@data[:allFiles] = Dir.glob("*")
                     @@data[:allFiles].each { |b|
                         s = File.stat("#{Dir.getwd}/#{b}")
                         if s.directory?
                             @@data[:allDir][key] <<  "#{Dir.getwd}/#{b}"
                         end
                     }
                     counter += 1
                 end
             else 
                 for i in @@data[:allDir][key]
                     Dir.chdir("#{i}")
                     @@data[:allFiles] = Dir.glob("*")
                     @@data[:allFiles].each { |b|
                         s = File.stat("#{Dir.getwd}/#{b}")
                         if s.directory?
                             @@data[:allDir][key] <<  "#{Dir.getwd}/#{b}"
                         end
                     }
                     counter += 1
             end             
             end    
            if @@data[:allDir][key][counter] != nil
                 self.addFolder(counter)
            else
                @allDirectories =  @@data[:allDir]
            end
         }
         puts "\e[32m#{@@data[:allDir]}\n\e[0m"
         Dir.chdir("#{@pattern}")
         File.open("Folders.txt","w") {
             |content| 
             @@data[:allDir].each { |key,value|
                 content.write("USER:#{key}:\n")
                 for i in value
                     stix = File.stat("#{i}")
                     content.write("\tDIRECTORIES: #{i}, SIZE: #{stix.size} Byte, TIME: #{stix.atime.strftime("%m/%d/%Y at %I:%M %p")}\n")
                 end
             }
         }
    end
     attr :pattern, true
     attr :allDirectories 
 end