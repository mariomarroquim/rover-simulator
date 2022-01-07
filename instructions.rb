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

      rover_directions.last.collect do |direction|
        if direction != 'M'
          new_direction ||= 'E' if current_position[2] == 'N' && direction == 'R'
          new_direction ||= 'S' if current_position[2] == 'E' && direction == 'R'
          new_direction ||= 'W' if current_position[2] == 'S' && direction == 'R'
          new_direction ||= 'N' if current_position[2] == 'W' && direction == 'R'

          new_direction ||= 'W' if current_position[2] == 'N' && direction == 'L'
          new_direction ||= 'S' if current_position[2] == 'W' && direction == 'L'
          new_direction ||= 'E' if current_position[2] == 'S' && direction == 'L'
          new_direction ||= 'N' if current_position[2] == 'E' && direction == 'L'

          current_position[2] = new_direction
        else
          current_position[1] = current_position[1].to_i + 1 if current_position[2] == 'N'
          current_position[1] = current_position[1].to_i - 1 if current_position[2] == 'S'
          current_position[0] = current_position[0].to_i + 1 if current_position[2] == 'E'
          current_position[0] = current_position[0].to_i - 1 if current_position[2] == 'W'
        end
      end

      current_position
    end
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
