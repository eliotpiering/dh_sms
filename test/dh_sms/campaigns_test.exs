defmodule DhSms.CampaignsTest do
  use DhSms.DataCase

  alias DhSms.Campaigns

  describe "campaigns" do
    alias DhSms.Campaigns.Campaign

    @valid_attrs %{intro_message: "some intro_message", name: "some name", send_delay: 42}
    @update_attrs %{intro_message: "some updated intro_message", name: "some updated name", send_delay: 43}
    @invalid_attrs %{intro_message: nil, name: nil, send_delay: nil}

    def campaign_fixture(attrs \\ %{}) do
      {:ok, campaign} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Campaigns.create_campaign()

      campaign
    end

    test "list_campaigns/0 returns all campaigns" do
      campaign = campaign_fixture()
      assert Campaigns.list_campaigns() == [campaign]
    end

    test "get_campaign!/1 returns the campaign with given id" do
      campaign = campaign_fixture()
      assert Campaigns.get_campaign!(campaign.id) == campaign
    end

    test "create_campaign/1 with valid data creates a campaign" do
      assert {:ok, %Campaign{} = campaign} = Campaigns.create_campaign(@valid_attrs)
      assert campaign.intro_message == "some intro_message"
      assert campaign.name == "some name"
      assert campaign.send_delay == 42
    end

    test "create_campaign/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Campaigns.create_campaign(@invalid_attrs)
    end

    test "update_campaign/2 with valid data updates the campaign" do
      campaign = campaign_fixture()
      assert {:ok, %Campaign{} = campaign} = Campaigns.update_campaign(campaign, @update_attrs)
      assert campaign.intro_message == "some updated intro_message"
      assert campaign.name == "some updated name"
      assert campaign.send_delay == 43
    end

    test "update_campaign/2 with invalid data returns error changeset" do
      campaign = campaign_fixture()
      assert {:error, %Ecto.Changeset{}} = Campaigns.update_campaign(campaign, @invalid_attrs)
      assert campaign == Campaigns.get_campaign!(campaign.id)
    end

    test "delete_campaign/1 deletes the campaign" do
      campaign = campaign_fixture()
      assert {:ok, %Campaign{}} = Campaigns.delete_campaign(campaign)
      assert_raise Ecto.NoResultsError, fn -> Campaigns.get_campaign!(campaign.id) end
    end

    test "change_campaign/1 returns a campaign changeset" do
      campaign = campaign_fixture()
      assert %Ecto.Changeset{} = Campaigns.change_campaign(campaign)
    end
  end
end
