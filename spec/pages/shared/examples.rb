shared_examples 'id and name properties' do
  it { expect(page.id).to be_a(String) }
  it { expect(page.name).to be_a(String) }
  it { expect(page.username).to be_a(String) }
end

shared_examples 'location properties' do
  it { expect(page.latitude).to be_a(Float) }
  it { expect(page.longitude).to be_a(Float) }
  it { expect(page.city).to be_a(String) }
  it { expect(page.state).to be_a(String) }
  it { expect(page.street).to be_a(String) }
  it { expect(page.country).to be_a(String) }
  it { expect(page.zip).to be_a(String) }
end
