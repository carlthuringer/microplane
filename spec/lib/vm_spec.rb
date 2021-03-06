# frozen_string_literal: true

require 'microplane'

RSpec.describe(Microplane::VM) do
  describe '+' do
    it 'Adds two numbers' do
      subject.evaluate('1 2 +')
      expect(subject.pop).to eq(3)
    end
  end

  describe '-' do
    it 'Subtracts two numbers' do
      subject.evaluate('2 1 -')
      expect(subject.pop).to eq(-1)
    end
  end

  describe '*' do
    it 'Multiplies two numbers' do
      subject.evaluate('2 2 *')
      expect(subject.pop).to eq(4)
    end
  end

  describe '/' do
    it 'Divides two numbers' do
      subject.evaluate('2 2 /')
      expect(subject.pop).to eq(1)
    end
  end

  describe '%' do
    it 'Calculates modulo of two numbers' do
      subject.evaluate('5 15 %')
      expect(subject.pop).to eq(0)
    end
  end

  describe '<' do
    it 'Calculates less than of two numbers' do
      subject.evaluate('2 1 <')
      expect(subject.pop).to eq(true)
    end
  end

  describe '>' do
    it 'Calculates greater than of two numbers' do
      subject.evaluate('2 1 >')
      expect(subject.pop).to eq(false)
    end
  end

  describe '=' do
    it 'Calculates equality of two numbers' do
      subject.evaluate('1 1 =')
      expect(subject.pop).to eq(true)
    end
  end

  describe '&' do
    it 'Calculates AND of two inputs' do
      subject.evaluate('true true =')
    end
  end

  describe 'true' do
    it 'Puts true on the stack' do
      subject.evaluate('true')
      expect(subject.pop).to eq(true)
    end
  end

  describe 'false' do
    it 'Puts false on the stack' do
      subject.evaluate('false')
      expect(subject.pop).to eq(false)
    end
  end

  describe '|' do
    it 'Calculates the OR of two inputs' do
      subject.evaluate('false false |')
      expect(subject.pop).to eq(false)
    end
  end

  describe 'not' do
    it 'Inverts the truthiness of the input' do
      subject.evaluate('false not')
      expect(subject.pop).to eq(true)
    end
  end

  describe 'neg' do
    it 'Negates the input' do
      subject.evaluate('1 neg')
      expect(subject.pop).to eq(-1)
    end
  end

  describe ': ... ;' do
    it 'Defines a new word' do
      subject.evaluate(': foo 123 ;')
      subject.evaluate('foo')
      expect(subject.pop).to eq(123)
    end

    it 'Defines a more complex new word' do
      subject.evaluate(': add2 2 + ;')
      subject.evaluate('3 add2')
      expect(subject.pop).to eq(5)
    end

    it 'Clears previous definitions' do
      subject.evaluate(': add2 2 + ;')
      subject.evaluate(': add5 5 + ;')
      subject.evaluate('3 add5')
      expect(subject.pop).to eq(8)
    end
  end

  describe 'pop' do
    it 'Pops something off the stack' do
      subject.evaluate('1 5 pop')
      expect(subject.pop).to eq(1)
    end
  end

  describe 'if' do
    it 'Skips over the section if the element on the stack is truthy' do
      subject.evaluate('true if 123 fi 456')
      expect(subject.pop).to eq(456)
    end
  end

  describe 'dup' do
    it 'Duplicates the top element of the stack' do
      subject.evaluate('2 dup *')
      expect(subject.pop).to eq(4)
    end
  end
end
