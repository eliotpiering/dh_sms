defmodule DhSmsWeb.MessageControllerTest do
  use DhSmsWeb.ConnCase

  alias DhSms.Messaging

  @create_attrs %{body: "some body"}
  @update_attrs %{body: "some updated body"}
  @invalid_attrs %{body: nil}

  def fixture(:contact) do
    {:ok, contact} = Messaging.create_contact(%{name: "Test", email: "test@example.com", phone: "0001234567"})
    contact
  end

  def fixture(:message, contact_id) do
    attrs = Map.put(@create_attrs, :contact_id, contact_id)
    {:ok, message} = Messaging.create_message(attrs)
    message
  end

  describe "index" do
    setup [:create_contact]

    test "lists all messages", %{conn: conn, contact: contact} do
      conn = get(conn, Routes.contact_message_path(conn, :index, contact.id))
      assert html_response(conn, 200) =~ "Listing Messages"
    end
  end

  describe "new message" do
    setup [:create_contact]

    test "renders form", %{conn: conn, contact: contact} do
      conn = get(conn, Routes.contact_message_path(conn, :new, contact.id))
      assert html_response(conn, 200) =~ "New Message"
    end
  end

  describe "create message" do
    setup [:create_contact]

    test "redirects to show when data is valid", %{conn: conn, contact: contact} do
      create_attrs = Map.put(@create_attrs, :contact_id, contact.id)
      conn = post(conn, Routes.contact_message_path(conn, :create, contact.id), message: create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.contact_message_path(conn, :show, contact.id, id)

      conn = get(conn, Routes.contact_message_path(conn, :show, contact.id, id))
      assert html_response(conn, 200) =~ "Show Message"
    end

    test "renders errors when data is invalid", %{conn: conn, contact: contact} do
      conn = post(conn, Routes.contact_message_path(conn, :create, contact.id), message: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Message"
    end
  end

  describe "edit message" do
    setup [:create_message]

    test "renders form for editing chosen message", %{conn: conn, contact: contact, message: message} do
      conn = get(conn, Routes.contact_message_path(conn, :edit, contact.id, message))
      assert html_response(conn, 200) =~ "Edit Message"
    end
  end

  describe "update message" do
    setup [:create_message]

    test "redirects when data is valid", %{conn: conn, contact: contact, message: message} do
      conn = put(conn, Routes.contact_message_path(conn, :update, contact.id, message), message: @update_attrs)
      assert redirected_to(conn) == Routes.contact_message_path(conn, :show, contact.id, message)

      conn = get(conn, Routes.contact_message_path(conn, :show, contact.id, message))
      assert html_response(conn, 200) =~ "some updated body"
    end

    test "renders errors when data is invalid", %{conn: conn, contact: contact, message: message} do
      conn = put(conn, Routes.contact_message_path(conn, :update, contact.id, message), message: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Message"
    end
  end

  describe "delete message" do
    setup [:create_message]

    test "deletes chosen message", %{conn: conn, contact: contact, message: message} do
      conn = delete(conn, Routes.contact_message_path(conn, :delete, contact.id, message))
      assert redirected_to(conn) == Routes.contact_message_path(conn, :index, contact.id)
      assert_error_sent 404, fn ->
        get(conn, Routes.contact_message_path(conn, :show, contact.id, message))
      end
    end
  end

  defp create_contact(_) do
    %{
      contact: fixture(:contact)
    }
  end

  defp create_message(_) do
    contact = fixture(:contact)
    message = fixture(:message, contact.id)
    %{
      contact: contact,
      message: message
    }
  end
end
