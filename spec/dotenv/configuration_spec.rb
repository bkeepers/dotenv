require "spec_helper"

describe Dotenv::Configuration do
  let(:config) do
    Class.new(Dotenv::Configuration) do
      def env
        @env ||= {}
      end
    end
  end

  let(:instance) { config.new }

  describe "string" do
    before { config.string :str }

    it "returns the value" do
      instance.env["STR"] = "a string"
      expect(instance.str).to eql("a string")
    end
  end

  describe "integer" do
    before { config.integer :int }

    it "returns nil if not defined" do
      expect(instance.int).to be(nil)
    end

    it "casts a string to an integer" do
      instance.env["INT"] = "1"
      expect(instance.int).to be(1)
    end

    it "raises an error if it can't cast it" do
      instance.env["INT"] = "nope"
      expect { instance.int }.to raise_error(ArgumentError, /invalid value for Integer()/)
    end
  end

  describe "boolean" do
    before { config.boolean :bool }

    ["0", "false"].each do |input|
      it "casts #{input.inspect} to false" do
        instance.env["BOOL"] = input
        expect(instance.bool?).to be(false)
      end
    end

    ["1", "true"].each do |input|
      it "casts #{input.inspect} to true" do
        instance.env["BOOL"] = input
        expect(instance.bool?).to be(true)
      end
    end

    [nil, ''].each do |input|
      it "casts #{input.inspect} to nil" do
        instance.env["BOOL"] = input
        expect(instance.bool?).to be(nil)
      end
    end

    it "raises an error if it can't cast it" do
      instance.env["BOOL"] = "nope"
      expect { instance.bool? }.to raise_error(ArgumentError, /invalid value for boolean/)
    end
  end

  describe ":default option" do
    it "returns the default if no value is provided" do
      config.string :blank, :default => "not blank"
      expect(instance.blank).to eql("not blank")
    end

    it "does not return the default if a value is provided" do
      config.boolean :bool, :default => true
      instance.env["BOOL"] = 'false'
      expect(instance.bool?).to be(false)
    end

    it "instance evals block for default value" do
      self_in_block = nil
      config.integer(:magic_number) do
        self_in_block = self
        10
      end
      expect(instance.magic_number).to be(10)
      expect(self_in_block).to be(instance)
    end
  end

  describe ":required" do
    it "raises an error if not supplied" do
      config.string :required_thing, :required => true
      expect { instance.required_thing }.to raise_error(ArgumentError, /is required/)
    end
  end
end
