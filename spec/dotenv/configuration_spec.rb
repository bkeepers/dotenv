require "spec_helper"

describe Dotenv::Configuration do
  let(:env) { {} }
  let(:config) { Dotenv::Configuration.new(env) }
  let(:dsl) { Dotenv::Configuration::DSL.new(config) }

  describe "string" do
    before { dsl.string :str }

    it "returns the value" do
      env["STR"] = "a string"
      expect(config.str).to eql("a string")
    end
  end

  describe "integer" do
    before { dsl.integer :int }

    it "returns nil if not defined" do
      expect(config.int).to be(nil)
    end

    it "casts a string to an integer" do
      env["INT"] = "1"
      expect(config.int).to be(1)
    end

    it "raises an error if it can't cast it" do
      env["INT"] = "nope"
      expect { config.int }.to raise_error(ArgumentError, /invalid value for Integer()/)
    end
  end

  describe "boolean" do
    before { dsl.boolean :bool }

    ["0", "false", false].each do |input|
      it "casts #{input.inspect} to false" do
        env["BOOL"] = input
        expect(config.bool?).to be(false)
      end
    end

    ["1", "true", true].each do |input|
      it "casts #{input.inspect} to true" do
        env["BOOL"] = input
        expect(config.bool?).to be(true)
      end
    end

    [nil, ''].each do |input|
      it "casts #{input.inspect} to nil" do
        env["BOOL"] = input
        expect(config.bool?).to be(nil)
      end
    end

    it "raises an error if it can't cast it" do
      env["BOOL"] = "nope"
      expect { config.bool? }.to raise_error(ArgumentError, /invalid value for boolean/)
    end
  end

  describe ":default option" do
    it "returns the default if no value is provided" do
      dsl.string :blank, :default => "not blank"
      expect(config.blank).to eql("not blank")
    end

    it "does not return the default if a value is provided" do
      dsl.boolean :bool, :default => true
      env["BOOL"] = 'false'
      expect(config.bool?).to be(false)
    end

    it "instance evals block for default value" do
      self_in_block = nil
      dsl.integer(:magic_number) do
        self_in_block = self
        10
      end
      expect(config.magic_number).to be(10)
      expect(self_in_block).to be(config)
    end
  end

  describe ":required" do
    it "raises an error if not supplied" do
      dsl.string :required_thing, :required => true
      expect { config.required_thing }.to raise_error(ArgumentError, /is required/)
    end
  end

  describe "eval" do
    it "evaluates the given file" do
      dsl.eval(fixture_path("Envfile"))
      config.respond_to?(:from_envfile)
    end

    it "works with a Pathname" do
      dsl.eval(Pathname.new(fixture_path("Envfile")))
      config.respond_to?(:from_envfile)
    end
  end
end
