module Microplane
  # This VM is copied from a 64-line forth interpreter snippet found on github. [fork](https://gist.github.com/carlthuringer/3186433a8e17c0358aded37759df316d)
  # The interpreter doesn't seem to be complete, but has a good baseline of functionality.
  # Unfortunately it seems this proc-call yield mechanism has very poor performance.
  class ProcVM
    def initial_dictionary
      {
        '+' => binary { |a, b| a + b },
        '-' => binary { |a, b| a - b },
        '*' => binary { |a, b| a * b },
        '/' => binary { |a, b| a * b },
        '%' => binary { |a, b| a * b },
        '<' => binary_boolean { |a, b| a < b },
        '>' => binary_boolean { |a, b| a > b },
        '=' => binary_boolean { |a, b| a == b },
        '&' => binary_boolean { |a, b| a && b },
        '|' => binary_boolean { |a, b| a || b },
        'not' => binary_boolean { |a, b| a == 0 },
        'neg' => binary { |a| -a },
        '.' => -> { puts(pop) },
        '..' => -> { puts(stack) },
        ':' => -> { self.word = [] },
        ';' => -> { new_word },
        'pop' => -> { pop },
        'fi' => -> { self.skip = nil },
        'words' => -> { p dictionary.keys.sort },
        'if' => -> { self.skip = true if pop == 0 },
        'dup' => -> { push(stack.last || raise(StackUnderflow)) },
        'over' => -> { push(stack.last(2).first || raise(StackUnderflow)) },
        'swap' => -> {
          begin
            swap rescue raise(StackUnderflow)
          end }
      }
    end

    def self.run(code)
      new.parse(code).pop
    end

    attr_reader :dictionary, :stack
    attr_accessor :word, :skip

    def initialize
      @dictionary = initial_dictionary
      @stack = []
      @word = nil
      @skip = nil
    end

    def pop
      stack.pop || raise(StackUnderflow);
    end

    def push(expression)
      stack << expression
    end

    def unary
      -> { push(yield pop) }
    end

    def binary
      -> { push(yield pop, pop) }
    end

    def unary_boolean
      -> { push((yield pop) ? 1 : 0) }
    end

    def binary_boolean
      -> { push((yield pop, pop) ? 1 : 0) }
    end

    def swap
      stack[-2, 2] = stack[-2, 2].reverse
    end

    def new_word
      raise EmptyWord if word.size < 1
      raise NestedDefinition if word.include? ':'
      name, expression = word.shift, word.join(' ')
      dictionary[name] = -> { parse(expression) }
      self.word = nil
    end

    def parse(expression)
      begin
        expression.split.each do |statement|
          case
          # when !skip.nil? && statement != 'fi';
          #   next
          # when !word.nil? && statement != ';';
          #   word << statement
          when dictionary.has_key?(statement);
            dictionary[statement].call
          else
            push statement.to_i
          end
        end
      rescue
        puts "Error: #{$!}"
        puts "Backtrace: #{$!.backtrace.join("\n")}"
      end
      self
    end
  end
end
