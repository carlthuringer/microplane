# frozen_string_literal: true

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
        'not' => binary_boolean { |a, _b| a == 0 },
        'neg' => binary(&:-@),
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
        'swap' => lambda {
          begin
            begin
              swap
            rescue
              raise(StackUnderflow)
            end
          end
        }
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
      stack.pop || raise(StackUnderflow)
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
      -> { push(yield pop ? 1 : 0) }
    end

    def binary_boolean
      -> { push(yield pop, pop ? 1 : 0) }
    end

    def swap
      stack[-2, 2] = stack[-2, 2].reverse
    end

    def new_word
      raise EmptyWord if word.empty?
      raise NestedDefinition if word.include? ':'
      name = word.shift
      expression = word.join(' ')
      dictionary[name] = -> { parse(expression) }
      self.word = nil
    end

    def parse(expression)
      begin
        expression.split.each do |statement|
          if dictionary.key?(statement)
            dictionary[statement].call
          else
            push statement.to_i
          end
        end
      rescue
        puts "Error: #{$ERROR_INFO}"
        puts "Backtrace: #{$ERROR_INFO.backtrace.join("\n")}"
      end
      self
    end
  end
end
