require 'rspec'
require 'fog'
require 'rackspace/images'

describe Skewer::Rackspace::Images do
  before(:each) do
    @images = Skewer::Rackspace::Images.new
  end

  it "should build out an object" do
    @images.nil?.should == false
  end

  it "should have a supported images hash associated with the hash" do
    @images.supported.class.should == Hash
  end

  it "should have valid image names and ids in the hash" do
    # Turn off Fog mocking.
    Fog.unmock!
    Fog.mock?.should == false

    rs = Fog::Compute.new(
      :provider => 'Rackspace',
      :rackspace_auth_url => "lon.auth.api.rackspacecloud.com"
    )

    # Store a local array of id + name hashes to match against.
    rs_images = []
    rs.images.each { |image|
      rs_images << {:id => image.id, :name => image.name}
    }

    # Test that what we've got exists in the Rackspace image list.
    @images.supported.each { |k, v|
      rs_images.include?(v).should == true
    }
  end
end
