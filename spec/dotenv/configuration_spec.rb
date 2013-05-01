require 'spec_helper'
require 'dotenv/configuration'

describe Dotenv::Configuration do

  def config(hash)
    Dotenv::Configuration.new(hash)
  end

  it 'fetches env variables' do
    expect(config('FOO' => 'bar').foo).to eql('bar')
  end

  it 'works with underscores' do
    expect(config('UNDER_SCORE' => '1').under_score).to eql('1')
  end

  it 'returns nil for unknown options' do
    expect(config({}).undefined).to eql(nil)
  end

end
