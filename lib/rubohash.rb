require 'rubohash/version'

require 'securerandom'
require 'digest'
require 'logger'
require 'mini_magick'

require 'rubohash/factory'
require 'rubohash/robot'
MiniMagick.logger.level = Logger::WARN

# Rubohash namespace
module Rubohash
  @default_extensions = %w[.png .gif .jpg .bmp .jpeg .ppm .datauri]
  @default_set        = 'set1'
  @use_default_set    = false
  @robot_output_path  = File.expand_path('output', Dir.pwd)
  @default_format     = 'png'
  @default_bg_set     = 'bg1'
  @use_default_bg_set = false
  @use_background     = true
  @mounted            = false

  def self.inspect
    %i[
      default_extensions
      default_set
      use_default_set
      robot_output_path
      default_format
      default_bg_set
      use_default_bg_set
      use_background
      mounted
    ].each_with_object({}) do |k, obj|
      obj[k] = Rubohash.instance_variable_get("@#{k}")
    end
  end

  # Set the default extensions to strip out
  def self.default_extensions=(my_default_extensions)
    @default_extensions = my_default_extensions
  end

  # The default extensions to strip out
  def self.default_extensions
    @default_extensions
  end

  # Se the default image set to use
  def self.default_set=(my_default_set)
    @default_set = my_default_set
  end

  # Get the default image set to use
  def self.default_set
    @default_set
  end

  # Set whether we should use the default set?
  def self.use_default_set=(my_use_default_set)
    @use_default_set = my_use_default_set
  end

  # Are we using the default image set?
  def self.use_default_set
    @use_default_set
  end

  # Set where is the robot image going to be written to
  def self.robot_output_path=(my_robot_output_path)
    @robot_output_path = my_robot_output_path
  end

  # Where is the robot image going to be written to
  def self.robot_output_path
    @robot_output_path
  end

  # Set the default image output format
  def self.default_format=(my_default_format)
    @default_format = my_default_format
  end

  # Get the default image output format
  def self.default_format
    @default_format
  end

  # Set the default background set
  def self.default_bg_set=(my_default_bg_set)
    @default_bg_set = my_default_bg_set
  end

  # Get the default background set
  def self.default_bg_set
    @default_bg_set
  end

  # Set whether we should use the default background set
  def self.use_default_bg_set=(my_use_default_bg_set)
    @use_default_bg_set = my_use_default_bg_set
  end

  # Get whether we are using the default background set
  def self.use_default_bg_set
    @use_default_bg_set
  end

  # Set whether we should composite a background
  def self.use_background=(my_use_background)
    @use_background = my_use_background
  end

  # Get whether we should composite a background
  def self.use_background
    @use_background
  end

  # Set mounted to rails engine
  def self.mounted=(my_mounted)
    @mounted = my_mounted
  end

  # Get Mounted to rails engine
  def self.mounted
    @mounted
  end

  # Assemble a new robot based on string
  def self.assemble!(string)
    Rubohash::Factory.new(string).assemble
  end

  # Yield to a block to configure the gem
  def self.configure
    yield self
  end
end
