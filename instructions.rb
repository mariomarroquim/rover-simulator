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
