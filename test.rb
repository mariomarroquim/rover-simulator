require 'minitest/autorun'
require './instructions.rb'

class Test < Minitest::Test
  def setup
    @valid_instructions = Instructions.new('fixtures/instructions.txt')
  end

  def test_terrain_top_right_position
    assert_equal @valid_instructions.terrain_top_right_position, ['5', '5']
  end

  def test_rovers_current_position_and_commands
    assert_equal @valid_instructions.rovers_current_position_and_commands, [[['1', '2', 'N'], ['L', 'M', 'L', 'M', 'L', 'M', 'L', 'M', 'M']], [['3', '3', 'E'], ['M', 'M', 'R', 'M', 'M', 'R', 'M', 'R', 'R', 'M']]]
  end

  def test_calculate_rovers_new_positions
    assert_equal @valid_instructions.calculate_rovers_new_positions, [[1, 3, 'N'], [5, 1, 'E']]
  end

  def test_position_valid
    assert @valid_instructions.position_valid?(['1', '2', 'N'])
    assert !@valid_instructions.position_valid?(['10', '2', 'N'])
    assert !@valid_instructions.position_valid?(['1', '20', 'N'])
  end

  def test_move_rovers_to_new_positions
    assert @valid_instructions.move_rovers_to_new_positions!
  end
end
