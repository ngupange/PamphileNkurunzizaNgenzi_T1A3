module ListMaker
  class ListDir
    
    @@dirname = 'lm_lists'

    def self.dirname
      @@dirname
    end
    
    attr_reader :files
    
    def initialize
      # Find directory or create if it doesn't exist
      # locate list directory in APP_ROOT
      @dirpath = File.join(APP_ROOT, @@dirname)
      if Dir.exists?(@dirpath)
        # confirm that it is readable and writable
        if !File.readable?(@dirpath)
          abort("List directory exists but is not readable.")
        end
        if !File.writable?(@dirpath)
          abort("List directory exists but is not writable.")
        end
      else
        # or create a new directory in APP_ROOT
        #   Use Dir.mkdir
        Dir.mkdir(@dirpath)
        if !Dir.exists?(@dirpath)
          abort("List directory does not exist and could not be created.")
        end
      end

      refresh_cached_files
      
      # if success, return self, otherwise exit program
      self
    end
    
    def choose_list
      # Display list of files with numbers
      puts "\nChoose list file\n\n".upcase
      puts "Type a file number you want to view from the list or type 'ADD' to add a new file on the List"
      list
      print "> "
      response = gets.chomp
      if response == 'add'
        filename = add
      else
        number = response.to_i
        # Default to first file if user data is invalid
        number = 1 unless (1..@files.length).include?(number)
        filename = @files[number-1]
      end
      system "clear"
      filename
    end
    
    def list
      puts "-" * 60
      @files.each_with_index do |filename, i|
        puts "#{i+1}: #{filename}"
      end
      puts "-" * 60
    end

    def fnbr
      @files.each_with_index do |filename, i|
        i
      end
    end
    
    def add
      system "clear"
      # Ask user to provide a new file name and create it
      puts "\nEnter the file name"
      print "> "
      response = gets.chomp
      name = response.downcase.strip
      # Ensure file name ends in '.txt'
      name << ".txt" unless name.end_with?('.txt')
      filepath = File.join(@@dirname, name)
      File.open(filepath, 'w')
      # Refresh cached files (or add filename to @files)
      refresh_cached_files
      # Return filename so it can be loaded by ListFile
      name
    end
    
    def refresh_cached_files
      # Store the list of the files in this directory in @files
      # Use Dir.entries or Dir.glob
      # Be sure not to include "." files or directories
      # Only return filenames, not absolute or relative paths
      @files = Dir.glob("#{@@dirname}/*.txt")
      @files.reject! {|f| f.start_with?('.') }
      @files.reject! {|f| File.directory?(f)}
      @files.map! {|f| File.basename(f) }
    end
    
  end
end

# print "Press Enter key to continue..."
# gets