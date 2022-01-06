require 'minitest/autorun'
require './instructions.rb'

class TestSendInstructions < Minitest::Test
  def test_if_minitest_works
    assert true
  end

  def test_instructions_validation
    assert !Instructions.new('invalid_file.txt').valid?
    assert !Instructions.new('empty_file.txt').valid?
  end
end
