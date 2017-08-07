# frozen_string_literal: true

module Microplane
  # Implements the basic Microplane VM
  class VM
    def self.run(code)
      new.evaluate(code).pop
    end

    attr_reader :stack

    def initialize
      @stack = []
      @skip = false
      @dictionary = {}
      @libraries = []
      add_library Lib::Std
    end

    def add_library(lib)
      lib.load_words(self)
    end

    def evaluate(code)
      tokens = code.split
      return define_new_word(tokens) if tokens.first == ':'
      tokens.each do |w|
        next if @skip == true && w != 'fi'
        parse(w)
      end
      self
    end

    def pop
      stack.pop
    end

    private

    def define_new_word(tokens)
      word = tokens[1]
      @dictionary[word] = tokens[2..-2].join(' ')
    end

    def push(obj)
      stack << obj
    end

    def parse(w)
      return push(w.to_i) if number?(w)
      word = @dictionary[w]
      raise "Unknown Word #{w}" unless word
      return word.call if word.is_a?(Proc)
      evaluate(word)
    end

    def number?(w)
      w.getbyte(0) >= 48 && w.getbyte(0) <= 57
    end
  end
end
