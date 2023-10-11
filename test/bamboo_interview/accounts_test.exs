defmodule BambooInterview.AccountsTest do
  @moduledoc false
  use BambooInterview.DataCase
  alias BambooInterview.Accounts
  alias BambooInterview.Accounts.User

  import BambooInterview.UserFixtures

  describe "create_user_account/1" do
    test "success: create a user account when given valid params" do
      user_validated_params = user_validator()

      assert {:ok, %User{} = returned_user} = Accounts.create_user_account(user_validated_params)

      assert !is_nil(returned_user.id)
      assert returned_user.first_name == user_validated_params.first_name
    end

    test "success: returns validation error when trying to create a user account when given invalid params" do
        user_validated_params = %{user_validator() | email: nil}
        assert {:error, %Ecto.Changeset{}} = Accounts.create_user_account(user_validated_params)
      end
  end

  describe "get_user/1" do
    test "success: gets a user account when given valid id" do
        [user | _] = Enum.map([1, 2, 3, 4], fn _count -> users_fixture() end)

      assert {:ok, %User{} = returned_user} = Accounts.get_user(user.id)

      assert !is_nil(returned_user.id)
      assert returned_user.first_name == user.first_name
    end

    test "success: returns validation error when trying to create a user account when given invalid params" do
        Enum.map([1, 2, 3, 4], fn _count -> users_fixture() end)
        non_existent_id = Ecto.UUID.generate()

        assert {:error, :not_found} = Accounts.get_user(non_existent_id)
      end
  end
end
