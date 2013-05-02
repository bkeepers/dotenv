require 'spec_helper'
require 'dotenv/configuration'

describe Dotenv::Configuration do

  subject { Dotenv::Configuration.new({'FOO_BAR' => '1'}) }

  describe 'accessors' do
    it 'fetches env variables' do
      expect(subject.foo_bar).to eql('1')
    end

    it 'raises error for undefined option' do
      expect { subject.undefined }.to raise_error(Dotenv::UndefinedVariable)
    end
  end

  describe 'predicate' do
    it 'returns true if env is defined' do
      expect(subject.foo_bar?).to eql(true)
    end

    it 'returns false if env is not defined' do
      expect(subject.undefined?).to eql(false)
    end
  end

  describe 'respond_to?' do
    it 'returns true for defined variable' do
      expect(subject.respond_to?(:foo_bar)).to eql(true)
    end

    it 'returns true for predicate method' do
      expect(subject.respond_to?(:foo_bar?)).to eql(true)
    end

    it 'returns false for undefined variable' do
      expect(subject.respond_to?(:undefined)).to eql(false)
    end
  end

end
