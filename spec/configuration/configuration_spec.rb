require 'spec_helper'

describe 'Funky.configure' do
  after :all do
    Funky.configure do |config|
      config.app_id = ENV['FB_APP_ID']
      config.app_secret = ENV['FB_APP_SECRET']
    end
  end

  it 'should return nil if no block is given' do
    expect(Funky.configure).to be(nil)
  end

  describe "given a block with: { |config| config.app_id = '123' }" do
    before do
      Funky.configure { |config| config.app_id = '123' }
    end
    it 'should change the Configuration#app_id to 123' do
      expect(Funky.configuration.app_id).to eq('123')
    end
  end

  describe "given a block with: { |config| config.app_secret = 'abc' }" do
    before do
      Funky.configure { |config| config.app_secret = 'abc' }
    end
    it 'should change the Configuration#app_secret to abc' do
      expect(Funky.configuration.app_secret).to eq('abc')
    end
  end
end
