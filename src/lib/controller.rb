require_relative 'list_dir'
require_relative 'list_file'
require "colorize"
require 'colorized_string'

require "tty-prompt"
$prompt = TTY::Prompt.new

module ListMaker
  class Controller
    
    def initialize
      @list_dir = ListMaker::ListDir.new
    end

    def select_options
      answer = $prompt.select("What do you want to do?", ['View contents', 'Add New Record', 'Edit File Content ', 'Load Another File to Manipulate', 'Quit'])
    return answer
    end

    def launch!
      introduction
      
      do_action('load', [])

      # input/action loop
      loop do
        action, args = get_action
        break if action == 'quit'
        result = do_action(action,args)
      end
      system "clear"
      conclusion
    end
    
    private
    
      def introduction
        puts "-" * 100
        puts "Directories Maker".upcase.center(80)
        puts "-" * 100
        puts "This is an interactive program helps users to create and manage lists."
      end

      def conclusion
        puts
        puts "-" * 100
        puts "Goodbye!".upcase.center(80)
        puts "-" * 100
        puts
      end
    
      def get_action
        action = nil
        @con = ListMaker::ListDir.new
        response = select_options.chomp
        args = response.downcase.strip.split(' ')
        action = args.shift
        if action == "edit"
          args = nil
          while args == nil         
            # system "clear"
            lim = @con.fnbr.length
            puts "choose number from list".colorize(:yellow)
            print "> "
            results = gets.chomp.to_i
            if (results <= lim + 1) && (results > 0)
              args = results.to_s
              args = args.split()
            else
              puts "Wrong answer, please pick right list number".colorize(:color => :white, :background => :red)
            end
          end
        end
        [action, args]
      end
        
      def do_action(action, args)
        case action
        when 'view'
          system "clear"
          @list_file.view
          puts "\n \n"
        when 'add'
          system "clear"
          puts "\n"
          @list_file.view
          @list_file.add
        when 'edit'
          system "clear"
          @list_file.view
          @list_file.edit(args)
          puts "\n \n"
        when 'load'
          system "clear"
          new_file = @list_dir.choose_list
          @list_file = ListMaker::ListFile.new(new_file)
          @list_file.view
          puts "\n \n"
        else
          puts "\nI don't understand that command.\n\n".colorize(:color => :white, :background => :red)
        end
      end
      
  end
  
end
