# frozen_string_literal: true

# Represents the input file with the instructions to the rovers
class Instructions
  attr_accessor :path

  def initialize(path)
    self.path = path
  end

  def terrain_top_right_position
    !content.empty? ? content[0] : []
  end

  def rovers_current_position_and_commands
    !content.empty? ? content[1..].each_slice(2).to_a : []
  end

  def calculate_rovers_new_positions
    rovers_current_position_and_commands.collect do |information|
      current_position, commands = information

      commands.collect do |command|
        current_orientation = current_position[2]

        if command != 'M'
          new_orientation ||= 'E' if current_orientation == 'N' && command == 'R'
          new_orientation ||= 'S' if current_orientation == 'E' && command == 'R'
          new_orientation ||= 'W' if current_orientation == 'S' && command == 'R'
          new_orientation ||= 'N' if current_orientation == 'W' && command == 'R'

          new_orientation ||= 'W' if current_orientation == 'N' && command == 'L'
          new_orientation ||= 'S' if current_orientation == 'W' && command == 'L'
          new_orientation ||= 'E' if current_orientation == 'S' && command == 'L'
          new_orientation ||= 'N' if current_orientation == 'E' && command == 'L'

          current_position[2] = new_orientation
        else
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

  def content
    return @content unless @content.nil?

    lines = []

    return lines unless File.exist?(path) && !File.empty?(path)

    File.readlines(path).each do |line|
      line = line.strip.delete(' ').upcase unless line.nil? || line.empty?

      # Checks if the line still has a content after cleaning
      next if line.nil? || line.empty?

      lines << line.split('')
    end

    @content = lines
  end
end
