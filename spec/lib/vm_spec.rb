require 'microplane'

RSpec.describe(Microplane::VM) do
  describe "+" do
    it "Adds two numbers" do
      subject.evaluate("1 2 +")
      expect(subject.pop).to eq(3)
    end
  end

  describe "-" do
    it "Subtracts two numbers" do
      subject.evaluate("2 1 -")
      expect(subject.pop).to eq(-1)
    end
  end

  describe "*" do
    it "Multiplies two numbers" do
      subject.evaluate("2 2 *")
      expect(subject.pop).to eq(4)
    end
  end

  describe "/" do
    it "Divides two numbers" do
      subject.evaluate("2 2 /")
      expect(subject.pop).to eq(1)
    end
  end

  describe "%" do
    it "Calculates modulo of two numbers" do
      subject.evaluate("5 15 %")
      expect(subject.pop).to eq(0)
    end
  end

  describe "<" do
    it "Calculates less than of two numbers" do
      subject.evaluate("2 1 <")
      expect(subject.pop).to eq(true)
    end
  end

  describe ">" do
    it "Calculates greater than of two numbers" do
      subject.evaluate("2 1 >")
      expect(subject.pop).to eq(false)
    end
  end

  describe "=" do
    it "Calculates equality of two numbers" do
      subject.evaluate("1 1 =")
      expect(subject.pop).to eq(true)
    end
  end
end