require 'spec_helper'
require File.dirname(__FILE__) + '/../lib/' + 'log_parser.rb'

RSpec.describe "LogParser" do
  context 'when non existing file given' do
    before do
      @parser = LogParser.new('non-existing.log')
      @parser.parse
    end

    it 'should fail when non existing file given' do
      expect(@parser.success?).to eq false
    end

    it 'has error message' do
      expect(@parser).to have_attributes(message: "ERROR: 'non-existing.log' do not exists")
    end
  end

  context 'when existing file given' do
    before do
      @parser = LogParser.new('spec/data/server.log')
      @result = @parser.parse
    end

    it 'should success' do
      expect(@parser.success?).to eq true
    end

    it 'has no error message' do
      expect(@parser).to have_attributes(message: nil)
    end

    it 'should have four records' do
      expect(@result.count).to eq 4
    end

    it 'should have highest total count on top' do
      expect(@result[0][:uri]).to eq '/help_page/1'
    end

    it 'should calculate unique count correctly' do
      expect(@result[0][:count]).to eq 3
      expect(@result[0][:unique_count]).to eq 2
    end

  end

end
