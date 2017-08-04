# frozen_string_literal: true

module Microplane
  # Implements the basic Microplane VM
  class VM
    def self.run(code)
      new.evaluate(code).pop
    end

    attr_reader :stack
    def initialize(inj_stack = [])
      @stack = inj_stack
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

    def push(obj)
      stack << obj
    end

    def parse(words)
      words.each do |w|
        case w
        when '+'
          f_add
        when '-'
          f_sub
        when '*'
          f_mult
        when '/'
          f_div
        when '%'
          f_mod
        when '<'
          f_lt
        when '>'
          f_gt
        when '='
          f_eq
        else
          byte = '0'.getbyte(0)
          if byte >= 48 && byte <= 57
            push w.to_i
          else
            raise "Unknown Word #{w}"
          end
        end
      end
    end

    def f_add
      push(pop + pop)
    end

    def f_sub
      push(pop - pop)
    end

    def f_mult
      push(pop * pop)
    end

    def f_div
      push(pop / pop)
    end

    def f_mod
      push(pop % pop)
    end

    def f_lt
      push(pop < pop)
    end

    def f_gt
      push(pop > pop)
    end

    def f_eq
      push(pop == pop)
    end
  end
end
