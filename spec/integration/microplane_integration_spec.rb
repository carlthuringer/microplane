# frozen_string_literal: true

require 'microplane'

RSpec.describe('Integration Specs') do
  it 'Puts the number 1 on the stack' do
    vm = Microplane::VM.new
    vm.evaluate('1')
    expect(vm.pop).to eq(1)
  end

  it 'Puts the number 2 on the stack' do
    vm = Microplane::VM.new
    vm.evaluate('2')
    expect(vm.pop).to eq(2)
  end

  it 'Puts the number 2, then number 1, on the stack together' do
    vm = Microplane::VM.new
    vm.evaluate('2 1')
    expect(vm.pop).to eq(1)
    expect(vm.pop).to eq(2)
  end

  it 'Adds the numbers 1 and 2 and puts 3 on the stack' do
    vm = Microplane::VM.new
    vm.evaluate('1 2 +')
    expect(vm.pop).to eq(3)
  end

  it 'Subtracts the number 2 from 3, resulting in 1' do
    vm = Microplane::VM.new
    vm.evaluate('2 3 -')
    expect(vm.pop).to eq(1)
  end
end
