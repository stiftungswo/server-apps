RSpec.describe Server::Apps do
  it "has a version number" do
    expect(Server::Apps::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(false).to eq(true)
  end
end
