defmodule Raffley.CharitiesTest do
  use Raffley.DataCase

  alias Raffley.Charities

  describe "charities" do
    alias Raffley.Charities.Charity

    import Raffley.CharitiesFixtures

    @invalid_attrs %{name: nil, slugh: nil}

    test "list_charities/0 returns all charities" do
      charity = charity_fixture()
      assert Charities.list_charities() == [charity]
    end

    test "get_charity!/1 returns the charity with given id" do
      charity = charity_fixture()
      assert Charities.get_charity!(charity.id) == charity
    end

    test "create_charity/1 with valid data creates a charity" do
      valid_attrs = %{name: "some name", slugh: "some slugh"}

      assert {:ok, %Charity{} = charity} = Charities.create_charity(valid_attrs)
      assert charity.name == "some name"
      assert charity.slugh == "some slugh"
    end

    test "create_charity/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Charities.create_charity(@invalid_attrs)
    end

    test "update_charity/2 with valid data updates the charity" do
      charity = charity_fixture()
      update_attrs = %{name: "some updated name", slugh: "some updated slugh"}

      assert {:ok, %Charity{} = charity} = Charities.update_charity(charity, update_attrs)
      assert charity.name == "some updated name"
      assert charity.slugh == "some updated slugh"
    end

    test "update_charity/2 with invalid data returns error changeset" do
      charity = charity_fixture()
      assert {:error, %Ecto.Changeset{}} = Charities.update_charity(charity, @invalid_attrs)
      assert charity == Charities.get_charity!(charity.id)
    end

    test "delete_charity/1 deletes the charity" do
      charity = charity_fixture()
      assert {:ok, %Charity{}} = Charities.delete_charity(charity)
      assert_raise Ecto.NoResultsError, fn -> Charities.get_charity!(charity.id) end
    end

    test "change_charity/1 returns a charity changeset" do
      charity = charity_fixture()
      assert %Ecto.Changeset{} = Charities.change_charity(charity)
    end
  end
end
