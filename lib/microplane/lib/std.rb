# frozen_string_literal: true

module Microplane
  module Lib
    # Standard library of functions.
    class Std
      # DICTIONARY = .freeze

      def self.load_words(base)
        base.instance_eval do
          @dictionary.merge!(
            '+' => -> { push(pop + pop) },
            '-' => -> { push(pop - pop) },
            '*' => -> { push(pop * pop) },
            '/' => -> { push(pop / pop) },
            '%' => -> { push(pop % pop) },
            '<' => -> { push(pop < pop) },
            '<=' => -> { push(pop <= pop) },
            '=' => -> { push(pop == pop) },
            '>=' => -> { push(pop >= pop) },
            '>' => -> { push(pop > pop) },
            'true' => -> { push true },
            'false' => -> { push false },
            '|' => -> { push(pop || pop) },
            'not' => -> { push(!pop) },
            'neg' => -> { push(-pop) },
            'pop' => -> { pop },
            'if' => -> { @skip = true },
            'fi' => -> { @skip = false },
            'dup' => lambda do
              popped = pop
              push(popped)
              push(popped)
            end,
            'over' => lambda do
              first = pop
              second = pop
              push(first)
              push(second)
            end
          )
        end
      end
    end
  end
end