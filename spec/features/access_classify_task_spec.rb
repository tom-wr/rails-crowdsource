require "bacon"

RSpec.describe Bacon do
  it "is edible" do
    expect(Bacon.edible?).to be(true)
  end
end
