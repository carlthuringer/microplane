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
      code.split.each do |w|
        push parse(w)
      end
      self
    end

    def pop
      stack.pop
    end

    private

    def push(obj)
      stack << obj
    end

    def parse(w)
      case w
      when '+'
        pop + pop
      when '-'
        pop - pop
      when '*'
        pop * pop
      when '/'
        pop / pop
      when '%'
        pop % pop
      when '<'
        pop < pop
      when '>'
        pop > pop
      when '='
        pop == pop
      when 'true'
        true
      when 'false'
        false
      when '|'
        pop || pop
      else
        byte = w.getbyte(0)
        raise "Unknown Word #{w}" unless byte >= 48 && byte <= 57
        w.to_i
      end
    end
  end
end
