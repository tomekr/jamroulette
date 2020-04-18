require "rails_helper"

RSpec.describe Groups::GroupMembershipsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/groups/group_memberships").to route_to("groups/group_memberships#index")
    end

    it "routes to #new" do
      expect(get: "/groups/group_memberships/new").to route_to("groups/group_memberships#new")
    end

    it "routes to #show" do
      expect(get: "/groups/group_memberships/1").to route_to("groups/group_memberships#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/groups/group_memberships/1/edit").to route_to("groups/group_memberships#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/groups/group_memberships").to route_to("groups/group_memberships#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/groups/group_memberships/1").to route_to("groups/group_memberships#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/groups/group_memberships/1").to route_to("groups/group_memberships#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/groups/group_memberships/1").to route_to("groups/group_memberships#destroy", id: "1")
    end
  end
end
