require "spec_helper"

describe Dotenv::Diff do
  let(:before) { {} }
  let(:after) { {} }
  subject { Dotenv::Diff.new(before, after) }

  context "no changes" do
    let(:before) { {"A" => 1} }
    let(:after) { {"A" => 1} }

    it { expect(subject.added).to eq({}) }
    it { expect(subject.removed).to eq({}) }
    it { expect(subject.changed).to eq({}) }
  end

  context "key added" do
    let(:after) { {"A" => 1} }

    it { expect(subject.added).to eq("A" => 1) }
    it { expect(subject.removed).to eq({}) }
    it { expect(subject.changed).to eq({}) }
  end

  context "key removed" do
    let(:before) { {"A" => 1} }

    it { expect(subject.added).to eq({}) }
    it { expect(subject.removed).to eq("A" => 1) }
    it { expect(subject.changed).to eq({}) }
  end

  context "key changed" do
    let(:before) { {"A" => 1} }
    let(:after) { {"A" => 2} }

    it { expect(subject.added).to eq({}) }
    it { expect(subject.removed).to eq({}) }
    it { expect(subject.changed).to eq("A" => [1, 2]) }
  end
end
