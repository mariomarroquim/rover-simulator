require 'minitest/autorun'
require './instructions.rb'

class TestSendInstructions < Minitest::Test
  def test_if_minitest_works
    assert true
  end

  def test_instructions_validation
    assert Instructions.new('instructions.txt').valid?
    assert !Instructions.new('invalid_file.txt').valid?
    assert !Instructions.new('empty_file.txt').valid?
  end

  def test_instructions_initial_position
    assert_equal Instructions.new('instructions.txt').initial_position, [ 5, 5 ]
  end
end
