require 'spec_helper'

require 'tmpdir'

describe 'dotenv binary' do
  let(:bin)     { 'bundle exec ' + File.expand_path('../../../bin/dotenv', __FILE__)}
  let(:special) { rand.to_s }
  let(:tmpdir)  { Dir.mktmpdir 'dotenv' }

  before do
    @last_dir = Dir.pwd
    Dir.chdir tmpdir
    IO.write('Gemfile.tmp', "source 'https://rubygems.org'\ngemspec :name => 'dotenv', :path => '#{File.expand_path('../../..', __FILE__)}'")
    ENV['BUNDLE_GEMFILE'] = 'Gemfile.tmp'
  end

  after do
    Dir.chdir @last_dir
  end

  it "won't have a special env var without dotenv" do
    expect(`env`).not_to include(special)
  end

  it "dies if no .env" do
    expect(`#{bin} 2>&1`).to match(/no such file/i)
    expect($?.success?).to be_falsy
  end

  it "loads from .env by default" do
    IO.write('.env', "SPECIAL=#{special}")
    expect(`#{bin} env`).to include("SPECIAL=#{special}")
  end

  it "loads from file specified by -f" do
    other_env = ".env.#{rand.to_s}"
    IO.write(other_env, "SPECIAL=#{special}")
    expect(`#{bin} -f #{other_env} env`).to include("SPECIAL=#{special}")
  end

  it "dies if file specified by -f doesn't exist" do
    expect(`#{bin} -f #{rand.to_s} 2>&1`).to match(/no such file/i)
    expect($?.success?).to be_falsy
  end

  it "loads from multiple files specified by -f" do
    other_env = ".env.#{rand.to_s}"
    other_env_2 = ".env.#{rand.to_s}"
    IO.write(other_env, "SPECIAL=#{special}")
    IO.write(other_env_2, "SPECIAL2=#{special}")
    out = `#{bin} -f #{other_env},#{other_env_2} env`
    expect(out).to include("SPECIAL=#{special}")
    expect(out).to include("SPECIAL2=#{special}")
  end

end
