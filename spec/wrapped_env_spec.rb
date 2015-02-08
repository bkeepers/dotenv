require 'spec_helper'

require 'tempfile'
def env(text)
  file = Tempfile.new('dotenv')
  file.write text
  file.close
  env = Dotenv::Environment.new(file.path)
  file.unlink
  env
end

describe WrappedEnv do
  subject { described_class }

  before { env("OPTION_A=1\nOPTION_B=2").apply }

  describe 'fetch' do
    it 'reads the correct value' do
      expect(subject.fetch('OPTION_A')).to eq '1'
    end

    it 'raises an error' do
      expect { subject.fetch('OPTION_C') }.to(
        raise_error described_class::KeyError
      )
    end
  end

  describe 'override' do
    it 'rewrites the value' do
      subject.override('OPTION_A' => '3')
      expect(subject['OPTION_A']).to eq '3'
    end
  end

  describe 'reset' do
    it 'goes back to the original value' do
      subject.override('OPTION_A' => '3')
      subject.reset
      expect(subject['OPTION_A']).to eq '1'
    end
  end

  describe 'cast' do
    before { env("INT=1\nFLOAT=1.01\nBOOL=true\nBLANK=\nSTRING=abc").apply }

    it 'casts common values' do
      expect(subject.cast('INT')).to eq 1
      expect(subject.cast('FLOAT')).to eq 1.01
      expect(subject.cast('BOOL')).to eq true
      expect(subject.cast('BLANK')).to eq nil
      expect(subject.cast('STRING')).to eq 'abc'
    end

    describe 'error raising version' do
      it 'raises an error' do
        expect { subject.cast!('FAKE') }.to(
          raise_error described_class::KeyError
        )
      end
    end
  end
end
