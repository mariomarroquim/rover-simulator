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

  def test_instructions_plateau_upper_right_position
    assert_equal Instructions.new('instructions.txt').plateau_upper_right_position, [ 5, 5 ]
  end

  def test_instructions_directions
    assert_equal Instructions.new('instructions.txt').directions, [[['1', '2', 'N'], ['L', 'M', 'L', 'M', 'L', 'M', 'L', 'M', 'M']], [['3', '3', 'E'], ['M', 'M', 'R', 'M', 'M', 'R', 'M', 'R', 'R', 'M']]]
  end

  def test_instructions_move_rovers
    pp Instructions.new('instructions.txt').plateau_upper_right_position
    pp Instructions.new('instructions.txt').move_rovers
    assert_equal Instructions.new('instructions.txt').move_rovers, [[1, 3, 'N'], [5, 1, 'E']]
  end
end
