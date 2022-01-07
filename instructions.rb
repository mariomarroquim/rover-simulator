class Instructions
  attr_accessor :path, :instructions

  def initialize(path)
    self.path = path
  end

  def plateau_upper_right_position
    content.first.collect(&:to_i)
  end

  def directions
    content[1..-1].each_slice(2).to_a
  end

  def move_rovers
    directions.collect do |rover_directions|
      current_position = rover_directions.first
      next_position = current_position

      rover_directions.last.collect do |direction|
        if direction != 'M'
          new_direction ||= 'E' if next_position[2] == 'N' && direction == 'R'
          new_direction ||= 'S' if next_position[2] == 'E' && direction == 'R'
          new_direction ||= 'W' if next_position[2] == 'S' && direction == 'R'
          new_direction ||= 'N' if next_position[2] == 'W' && direction == 'R'

          new_direction ||= 'W' if next_position[2] == 'N' && direction == 'L'
          new_direction ||= 'S' if next_position[2] == 'W' && direction == 'L'
          new_direction ||= 'E' if next_position[2] == 'S' && direction == 'L'
          new_direction ||= 'N' if next_position[2] == 'E' && direction == 'L'

          next_position[2] = new_direction
        else
          next_position[1] = next_position[1].to_i + 1 if next_position[2] == 'N'
          next_position[1] = next_position[1].to_i - 1 if next_position[2] == 'S'
          next_position[0] = next_position[0].to_i + 1 if next_position[2] == 'E'
          next_position[0] = next_position[0].to_i - 1 if next_position[2] == 'W'
        end
      end

      next_position
    end
  end

  def position_valid?(new_position)
    return false if new_position[0].to_i > plateau_upper_right_position[1].to_i
    return false if new_position[1].to_i > plateau_upper_right_position[0].to_i

    true
  end

  def content
    return instructions unless instructions.nil?

    return unless valid?

    instructions = []

    File.readlines(path).each do |line|
      line = line.strip.delete(' ').upcase rescue nil
      next if line.nil? || line.empty?

      instructions << line.split('')
    end

    self.instructions = instructions
  end

  def valid?
    File.exist?(path) && !File.empty?(path)
  end
end
