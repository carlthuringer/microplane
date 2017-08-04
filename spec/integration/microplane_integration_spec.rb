# frozen_string_literal: true

# require "spec_helper"

RSpec.describe('Integration Specs') do
  it 'Does something' do
    vm = Microplane::VM.new
    vm.evaluate('1')
    expect(vm.pop).to eq(1)
  end
end
