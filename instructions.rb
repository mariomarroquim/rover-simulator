# frozen_string_literal: true

# Represents the input file with the instructions to the rovers
class Instructions
  attr_accessor :path

  def initialize(path)
    self.path = path
  end

  def terrain_top_right_position
    !content.nil? && !content.empty? ? content[0] : []
  end

  def rovers_current_position_and_commands
    !content.nil? && !content.empty? ? content[1..].each_slice(2).to_a : []
  end

  # Bad smell here: method too long with a lot of magic strings
  # Applying the suggestion in line 67, this method would become more expressive
  def calculate_rovers_new_positions
    rovers_current_position_and_commands.collect do |information|
      current_position, commands = information

      commands.collect do |command|
        current_orientation = current_position[2]

        if command != 'M'
          current_position[2] = 'E' if current_orientation == 'N' && command == 'R'
          current_position[2] = 'S' if current_orientation == 'E' && command == 'R'
          current_position[2] = 'W' if current_orientation == 'S' && command == 'R'
          current_position[2] = 'N' if current_orientation == 'W' && command == 'R'

          current_position[2] = 'W' if current_orientation == 'N' && command == 'L'
          current_position[2] = 'S' if current_orientation == 'W' && command == 'L'
          current_position[2] = 'E' if current_orientation == 'S' && command == 'L'
          current_position[2] = 'N' if current_orientation == 'E' && command == 'L'
        else
          # Bad smell here: see line 67
          current_position[1] = current_position[1].to_i + 1 if current_orientation == 'N'
          current_position[1] = current_position[1].to_i - 1 if current_orientation == 'S'
          current_position[0] = current_position[0].to_i + 1 if current_orientation == 'E'
          current_position[0] = current_position[0].to_i - 1 if current_orientation == 'W'
        end
      end

      current_position
    end
  end

  def position_valid?(position)
    return false if position.nil? || position.size < 2

    x_coordinate_valid = position[0].to_i <= terrain_top_right_position[1].to_i
    y_coordinate_valid = position[1].to_i <= terrain_top_right_position[0].to_i

    (x_coordinate_valid && y_coordinate_valid)
  end

  # TODO: Persist somewhere if requested (maybe in the input file?)
  def move_rovers_to_new_positions!
    calculate_rovers_new_positions.reject { |position| position_valid?(position) }.empty?
  end

  private

  # TODO: Use a class to represent a instruction, cast the (x,y) coordinates
  # inside it and remove calls to String#to_i from this class
  def content
    return @content unless @content.nil?

    return unless File.exist?(path)

    lines = []

    File.readlines(path).each do |line|
      line = line.strip.delete(' ').upcase
      lines << line.split('') unless line.empty?
    end

    @content = lines
  end
end
