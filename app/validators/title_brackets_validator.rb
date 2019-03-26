class TitleBracketsValidator < ActiveModel::Validator
  BRACKETS = { "[" => "]", "{" => "}", "(" => ")" }.freeze

  def validate(record)
    stack = []
    left = BRACKETS.keys
    right = BRACKETS.values
    left_bracket_position = 0

    record.title.each_char.with_index do |char, i|
      if left.include? char
        stack << char
        left_bracket_position = i
      elsif right.include? char
        print_errors(record) if ((left_bracket_position + 1) == i) || (BRACKETS[stack.pop] != char)
      end
    end

    print_errors(record) unless stack.empty?
  end

  private

  def print_errors(record)
    record.errors[:title] << "Invalid title"
  end
end
