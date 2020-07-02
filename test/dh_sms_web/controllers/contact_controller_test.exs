defmodule DhSmsWeb.ContactControllerTest do
  use DhSmsWeb.ConnCase

  alias DhSms.Conversations

  @create_attrs %{name: "Some Body", email: "test@example.com", phone: "0001234567"}
  @update_attrs %{name: "Someone Else", email: "test@example.com", phone: "0001234567"}
  @invalid_attrs %{name: nil, email: "test@example.com"}

  def fixture(:conversation) do
    {:ok, conversation} = Conversations.create_conversation()
    conversation
  end

  def fixture(:contact, conversation_id) do
    attrs = Map.put(@create_attrs, :conversation_id, conversation_id)
    {:ok, contact} = Conversations.create_contact(attrs)
    contact
  end

  describe "index" do
    setup [:create_conversation]

    test "lists all contacts", %{conn: conn, conversation: conversation} do
      conn = get(conn, Routes.conversation_contact_path(conn, :index, conversation.id))
      assert html_response(conn, 200) =~ "Listing Contacts"
    end
  end

  describe "new contact" do
    setup [:create_conversation]

    test "renders form", %{conn: conn, conversation: conversation} do
      conn = get(conn, Routes.conversation_contact_path(conn, :new, conversation.id))
      assert html_response(conn, 200) =~ "New Contact"
    end
  end

  describe "create contact" do
    setup [:create_conversation]

    test "redirects to show when data is valid", %{conn: conn, conversation: conversation} do
      create_attrs = Map.put(@create_attrs, :conversation_id, conversation.id)
      conn = post(conn, Routes.conversation_contact_path(conn, :create, conversation.id), contact: create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.conversation_contact_path(conn, :show, conversation.id, id)

      conn = get(conn, Routes.conversation_contact_path(conn, :show, conversation.id, id))
      assert html_response(conn, 200) =~ "Show Contact"
    end

    test "renders errors when data is invalid", %{conn: conn, conversation: conversation} do
      conn = post(conn, Routes.conversation_contact_path(conn, :create, conversation.id), contact: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Contact"
    end
  end

  describe "edit contact" do
    setup [:create_contact]

    test "renders form for editing chosen contact", %{conn: conn, conversation: conversation, contact: contact} do
      conn = get(conn, Routes.conversation_contact_path(conn, :edit, conversation.id, contact))
      assert html_response(conn, 200) =~ "Edit Contact"
    end
  end

  describe "update contact" do
    setup [:create_contact]

    test "redirects when data is valid", %{conn: conn, conversation: conversation, contact: contact} do
      conn = put(conn, Routes.conversation_contact_path(conn, :update, conversation.id, contact), contact: @update_attrs)
      assert redirected_to(conn) == Routes.conversation_contact_path(conn, :show, conversation.id, contact)

      conn = get(conn, Routes.conversation_contact_path(conn, :show, conversation.id, contact))
      assert html_response(conn, 200) =~ "Someone Else"
    end

    test "renders errors when data is invalid", %{conn: conn, conversation: conversation, contact: contact} do
      conn = put(conn, Routes.conversation_contact_path(conn, :update, conversation.id, contact), contact: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Contact"
    end
  end

  describe "delete contact" do
    setup [:create_contact]

    test "deletes chosen contact", %{conn: conn, conversation: conversation, contact: contact} do
      conn = delete(conn, Routes.conversation_contact_path(conn, :delete, conversation.id, contact))
      assert redirected_to(conn) == Routes.conversation_contact_path(conn, :index, conversation.id)
      assert_error_sent 404, fn ->
        get(conn, Routes.conversation_contact_path(conn, :show, conversation.id, contact))
      end
    end
  end

  defp create_conversation(_) do
    %{
      conversation: fixture(:conversation)
    }
  end

  defp create_contact(_) do
    conversation = fixture(:conversation)
    contact = fixture(:contact, conversation.id)
    %{
      conversation: conversation,
      contact: contact
    }
  end
end
