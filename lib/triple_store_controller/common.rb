=begin rdoc
--------------------------------------------------------------------------------

Define some error types.
Create the bogus method, for debugging.
Establish the settings directory.
Arrange to store copies of stdout and stderr.

--------------------------------------------------------------------------------
=end

module TripleStoreController
  class UserInputError < StandardError
  end

  class SettingsError < StandardError
  end

  def bogus(message)
    puts(">>>>>>>>>>>>>BOGUS #{message}")
  end

  SETTINGS_DIR = ENV['HOME'] + '/triple_store_settings'
  Dir.mkdir(SETTINGS_DIR) unless Dir.exist?(SETTINGS_DIR)

  #
  # Record stdout and stderr, even while they are being displayed.
  #
  class MultiIO
    def initialize(*targets)
      @targets = targets
    end

    def write(*args)
      @targets.each {|t| t.write(*args)}
    end

    def flush()
      @targets.each(&:flush)
    end

    def close
      @targets.each(&:close)
    end
  end
end

$stdout = TripleStoreController::MultiIO.new(STDOUT, File.open(TripleStoreController::SETTINGS_DIR + '/most_recent_stdout', 'w'))
$stderr = TripleStoreController::MultiIO.new(STDERR, File.open(TripleStoreController::SETTINGS_DIR + '/most_recent_stderr', 'w'))
