defmodule DhSms.MessagingTest do
  use DhSms.DataCase

  alias DhSms.{Contact, Messaging, Repo}

  describe "contacts" do
    alias DhSms.Messaging.Contact

    @valid_attrs %{email: "some email", name: "some name", phone: "some phone"}
    @update_attrs %{email: "some updated email", name: "some updated name", phone: "some updated phone"}
    @invalid_attrs %{email: nil, name: nil, phone: nil}

    def contact_fixture(attrs \\ %{}) do
      {:ok, contact} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Messaging.create_contact()

      contact
    end

    test "list_contacts/0 returns all contacts" do
      contact = contact_fixture()
      assert Messaging.list_contacts() == [contact]
    end

    test "get_contact!/1 returns the contact with given id" do
      contact = contact_fixture()
      assert Messaging.get_contact!(contact.id) == contact
    end

    test "create_contact/1 with valid data creates a contact" do
      assert {:ok, %Contact{} = contact} = Messaging.create_contact(@valid_attrs)
      assert contact.email == "some email"
      assert contact.name == "some name"
      assert contact.phone == "some phone"
    end

    test "create_contact/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Messaging.create_contact(@invalid_attrs)
    end

    test "update_contact/2 with valid data updates the contact" do
      contact = contact_fixture()
      assert {:ok, %Contact{} = contact} = Messaging.update_contact(contact, @update_attrs)
      assert contact.email == "some updated email"
      assert contact.name == "some updated name"
      assert contact.phone == "some updated phone"
    end

    test "update_contact/2 with invalid data returns error changeset" do
      contact = contact_fixture()
      assert {:error, %Ecto.Changeset{}} = Messaging.update_contact(contact, @invalid_attrs)
      assert contact == Messaging.get_contact!(contact.id)
    end

    test "delete_contact/1 deletes the contact" do
      contact = contact_fixture()
      assert {:ok, %Contact{}} = Messaging.delete_contact(contact)
      assert_raise Ecto.NoResultsError, fn -> Messaging.get_contact!(contact.id) end
    end

    test "change_contact/1 returns a contact changeset" do
      contact = contact_fixture()
      assert %Ecto.Changeset{} = Messaging.change_contact(contact)
    end
  end

  describe "messages" do
    alias DhSms.Messaging.Message

    @valid_attrs %{body: "some body"}
    @update_attrs %{body: "some updated body"}
    @invalid_attrs %{body: nil}

    def message_fixture(attrs \\ %{}) do
      {:ok, message} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Messaging.create_message()

      message
    end

    test "list_messages/0 returns all messages" do
      contact = contact_fixture()
      message = message_fixture(contact_id: contact.id)
      assert Messaging.list_messages(contact.id) == [message]
    end

    test "get_message!/1 returns the message with given id" do
      contact = contact_fixture()
      message = message_fixture(contact_id: contact.id)
      assert Messaging.get_message!(contact.id, message.id) == message
    end

    test "create_message/1 with valid data creates a message" do
      contact = contact_fixture()
      attrs = Enum.into(%{contact_id: contact.id}, @valid_attrs)
      message = Messaging.create_message(attrs)

      assert {:ok, %Message{} = message} = message
      assert message.body == "some body"
    end

    test "create_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Messaging.create_message(@invalid_attrs)
    end

    test "update_message/2 with valid data updates the message" do
      contact = contact_fixture()
      message = message_fixture(contact_id: contact.id)
      attrs = Enum.into(%{contact_id: contact.id}, @update_attrs)
      assert {:ok, %Message{} = message} = Messaging.update_message(message, attrs)
      assert message.body == "some updated body"
    end

    test "update_message/2 with invalid data returns error changeset" do
      contact = contact_fixture()
      message = message_fixture(contact_id: contact.id)
      assert {:error, %Ecto.Changeset{}} = Messaging.update_message(message, @invalid_attrs)
      assert message == Messaging.get_message!(contact.id, message.id)
    end

    test "delete_message/1 deletes the message" do
      contact = contact_fixture()
      message = message_fixture(contact_id: contact.id)
      assert {:ok, %Message{}} = Messaging.delete_message(message)
      assert_raise Ecto.NoResultsError, fn -> Messaging.get_message!(contact.id, message.id) end
    end

    test "change_message/1 returns a message changeset" do
      contact = contact_fixture()
      message = message_fixture(contact_id: contact.id)
      assert %Ecto.Changeset{} = Messaging.change_message(message)
    end
  end

  describe "relations" do
    test "contact has many comments" do
      contact = contact_fixture()
      Enum.each(0..3, fn _i -> message_fixture(contact_id: contact.id) end)

      contact = Messaging.get_contact!(contact.id)
        |> Repo.preload(:messages)

      assert length(contact.messages) == 4
    end
  end
end
