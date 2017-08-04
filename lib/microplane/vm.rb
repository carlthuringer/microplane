# frozen_string_literal: true

module Microplane
  # Implements the basic Microplane VM
  class VM
    def self.run(code)
      new.evaluate(code).pop
    end

    attr_reader :stack, :dictionary

    def initialize
      @stack = []
      @dictionary = initial_dictionary
    end

    def evaluate(code)
      words = code.split
      parse(words)
      self
    end

    def pop
      stack.pop
    end

    private

    def initial_dictionary
      {
        '+' => -> { f_add },
        '-' => -> { f_sub },
        '*' => -> { f_mult },
        '/' => -> { f_div },
        '%' => -> { f_mod },
        '<' => -> { f_lt },
        '>' => -> { f_gt },
        '=' => -> { f_eq },
      }
    end

    def push(obj)
      stack << obj
    end

    def parse(words)
      words.each do |w|
        func = dictionary[w]
        if func
          push func.call
        else
          byte = w.getbyte(0)
          if byte >= 48 && byte <= 57
            push w.to_i
          else
            raise "Unknown Word #{w}"
          end
        end
      end
    end

    def f_add
      pop + pop
    end

    def f_sub
      pop - pop
    end

    def f_mult
      pop * pop
    end

    def f_div
      pop / pop
    end

    def f_mod
      pop % pop
    end

    def f_lt
      pop < pop
    end

    def f_gt
      pop > pop
    end

    def f_eq
      pop == pop
    end
  end
end
