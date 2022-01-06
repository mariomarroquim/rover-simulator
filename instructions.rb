class Instructions
  attr_accessor :path, :instructions

  def initialize(path)
    self.path = path
  end

  def content
    return instructions unless instructions.nil?

    return unless valid?

    instructions = []

    File.readlines(path).each do |line|
      line = line.strip.gsub('  ', ' ').upcase rescue nil
      next if line.nil? || line.empty?

      instructions << line.split(' ')
    end

    self.instructions = instructions
  end

  def valid?
    File.exist?(path) && !File.empty?(path)
  end
end
