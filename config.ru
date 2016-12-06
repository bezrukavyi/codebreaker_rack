require_relative 'lib/codebreaker'
Dir['app/**/*.rb'].each {|file| require_relative file }

rack_config = File.read(File.absolute_path('rack_config.rb'))
eval "#{rack_config}"
