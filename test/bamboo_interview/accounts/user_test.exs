defmodule BambooInterview.UserTest do
  use BambooInterview.DataCase

  alias BambooInterview.Accounts.User

  import BambooInterview.UserFixtures

  @invalid_attrs %{first_name: nil, last_name: nil, email: nil, password: nil}

  describe "create_user/1" do
    test "create_user with valid data creates a user account" do
      valid_attrs = Map.from_struct(user_validator())

      assert {:ok, %User{} = user} = User.create_user(valid_attrs)
      assert user.first_name == valid_attrs.first_name
      assert user.last_name == valid_attrs.last_name
      assert user.gender == valid_attrs.gender
    end

    test "create_user with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = User.create_user(@invalid_attrs)
    end
  end

  describe "get/1" do
    test "success: get user with valid user_id" do
      [user | _] = Enum.map([1, 2, 3, 4], fn _count -> users_fixture() end)

      assert {:ok, %User{} = returned_user} = User.get_user(user.id)
     
      assert returned_user.id == user.id
    end

    test "error: return not_found error when given a non_existent  user_id" do
      Enum.map([1, 2, 3, 4], fn _count -> users_fixture() end)
      non_existent_id = Ecto.UUID.generate()
      assert {:error, :not_found} = User.get_user(non_existent_id)
    end
  end
end
