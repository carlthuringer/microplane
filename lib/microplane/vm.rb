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
      @new_word = false
      @skip = false
      @word_definition = []
      @dictionary = {}
    end

    def evaluate(code)
      code.split.each do |w|
        next if @skip == true && w != 'fi'
        next parse(w) unless @new_word
        next commit_new_word if w == ';'
        @word_definition.push(w)
      end
      self
    end

    def pop
      stack.pop
    end

    private

    def commit_new_word
      word = @word_definition.shift
      @dictionary[word] = @word_definition.join(' ')
      @word_definition = []
      @new_word = false
    end

    def push(obj)
      stack << obj
    end

    def parse(w)
      case w
      when '+'
        push(pop + pop)
      when '-'
        push(pop - pop)
      when '*'
        push(pop * pop)
      when '/'
        push(pop / pop)
      when '%'
        push(pop % pop)
      when '<'
        push(pop < pop)
      when '>'
        push(pop > pop)
      when '='
        push(pop == pop)
      when 'true'
        push(true)
      when 'false'
        push(false)
      when '|'
        push(pop || pop)
      when 'not'
        push(!pop)
      when 'neg'
        push(-pop)
      when ':'
        @new_word = true
      when 'pop'
        pop
      when 'if'
        @skip = true
      when 'fi'
        @skip = false
      when 'dup'
        popped = pop
        push(popped)
        push(popped)
      when 'over'
        first = pop
        second = pop
        push first
        push second
      else
        if w.getbyte(0) >= 48 && w.getbyte(0) <= 57
          push w.to_i
        elsif @dictionary.key?(w)
          evaluate(@dictionary[w])
        else
          raise "Unknown Word #{w}"
        end
      end
    end
  end
end
