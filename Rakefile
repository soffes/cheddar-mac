class String
  def self.colorize(text, color_code)
    "\e[#{color_code}m#{text}\e[0m"
  end

  def cyan
    self.class.colorize(self, 36)
  end

  def green
    self.class.colorize(self, 32)
  end
end

desc 'Setup with example files and dummy fonts'
task :setup do
  # Update and initialize the submodules in case they forget
  puts 'Updating submodules...'.cyan
  `git submodule update --init --recursive`

  # Copy examples defines
  puts 'Copying example CDMDefines into place...'.cyan
  `cp Other\\ Sources/CDMDefinesExample.h Other\\ Sources/CDMDefines.h`
  `cp Other\\ Sources/CDMDefinesExample.m Other\\ Sources/CDMDefines.m`

  # Make placeholder fonts
  puts 'Creating dummy fonts...'.cyan
  `mkdir -p Resources/Fonts`
  `touch Resources/Fonts/Gotham-Bold.otf`
  `touch Resources/Fonts/Gotham-BoldItalic.otf`
  `touch Resources/Fonts/Gotham-Book.otf`
  `touch Resources/Fonts/Gotham-BookItalic.otf`

  # Done!
  puts 'Done! You\'re ready to get started!'.green
end

# Run setup by default
task :default => :setup


# Tasks only for Nothing Magical
namespace :private do
  desc 'Setup with private files'
  task :'setup' do
    # Update and initialize the submodules in case they forget
    puts 'Updating submodules...'.cyan
    `git submodule update --init --recursive`

    # Copy defines
    puts 'Copying example CDMDefines into place...'.cyan
    `cp ../cheddar-private/Mac/CDMDefines.* Other\\ Sources/`

    # Make placeholder fonts
    puts 'Coping Gotham...'.cyan
    `cp -R ../cheddar-private/Resources/Fonts Resources/`

    # Done!
    puts 'Done! You\'re ready to get started!'.green
  end


  desc 'Sign update'
  task :sign_update do
    archive_path = ENV['archive_path']
    unless archive_path and archive_path.length > 0
      puts "Usage: rake sign_update archive_path=PATH_TO_ARCHIVE"
      exit
    end

    openssl = '/usr/bin/openssl'
    private_key = '../cheddar-private/Mac/dsa_priv.pem'
    puts
    puts `#{openssl} dgst -sha1 -binary < "#{archive_path}" | #{openssl} dgst -dss1 -sign "#{private_key}" | #{openssl} enc -base64`.green
  end
end
