defmodule DhSmsWeb.MessageControllerTest do
  use DhSmsWeb.ConnCase

  alias DhSms.Conversations

  @create_attrs %{body: "some body", from_dh: false}
  @update_attrs %{body: "some updated body"}
  @invalid_attrs %{body: nil}

  def fixture(:conversation) do
    {:ok, conversation} = Conversations.create_conversation()
    conversation
  end

  def fixture(:message, conversation_id) do
    attrs = Map.put(@create_attrs, :conversation_id, conversation_id)
    {:ok, message} = Conversations.create_message(attrs)
    message
  end

  describe "index" do
    setup [:create_conversation]

    test "lists all messages", %{conn: conn, conversation: conversation} do
      conn = get(conn, Routes.conversation_message_path(conn, :index, conversation.id))
      assert html_response(conn, 200) =~ "Listing Messages"
    end
  end

  describe "new message" do
    setup [:create_conversation]

    test "renders form", %{conn: conn, conversation: conversation} do
      conn = get(conn, Routes.conversation_message_path(conn, :new, conversation.id))
      assert html_response(conn, 200) =~ "New Message"
    end
  end

  describe "create message" do
    setup [:create_conversation]

    test "redirects to show when data is valid", %{conn: conn, conversation: conversation} do
      create_attrs = Map.put(@create_attrs, :conversation_id, conversation.id)
      conn = post(conn, Routes.conversation_message_path(conn, :create, conversation.id), message: create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.conversation_message_path(conn, :show, conversation.id, id)

      conn = get(conn, Routes.conversation_message_path(conn, :show, conversation.id, id))
      assert html_response(conn, 200) =~ "Show Message"
    end

    test "renders errors when data is invalid", %{conn: conn, conversation: conversation} do
      conn = post(conn, Routes.conversation_message_path(conn, :create, conversation.id), message: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Message"
    end
  end

  describe "edit message" do
    setup [:create_message]

    test "renders form for editing chosen message", %{conn: conn, conversation: conversation, message: message} do
      conn = get(conn, Routes.conversation_message_path(conn, :edit, conversation.id, message))
      assert html_response(conn, 200) =~ "Edit Message"
    end
  end

  describe "update message" do
    setup [:create_message]

    test "redirects when data is valid", %{conn: conn, conversation: conversation, message: message} do
      conn = put(conn, Routes.conversation_message_path(conn, :update, conversation.id, message), message: @update_attrs)
      assert redirected_to(conn) == Routes.conversation_message_path(conn, :show, conversation.id, message)

      conn = get(conn, Routes.conversation_message_path(conn, :show, conversation.id, message))
      assert html_response(conn, 200) =~ "some updated body"
    end

    test "renders errors when data is invalid", %{conn: conn, conversation: conversation, message: message} do
      conn = put(conn, Routes.conversation_message_path(conn, :update, conversation.id, message), message: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Message"
    end
  end

  describe "delete message" do
    setup [:create_message]

    test "deletes chosen message", %{conn: conn, conversation: conversation, message: message} do
      conn = delete(conn, Routes.conversation_message_path(conn, :delete, conversation.id, message))
      assert redirected_to(conn) == Routes.conversation_message_path(conn, :index, conversation.id)
      assert_error_sent 404, fn ->
        get(conn, Routes.conversation_message_path(conn, :show, conversation.id, message))
      end
    end
  end

  defp create_conversation(_) do
    %{
      conversation: fixture(:conversation)
    }
  end

  defp create_message(_) do
    conversation = fixture(:conversation)
    message = fixture(:message, conversation.id)
    %{
      conversation: conversation,
      message: message
    }
  end
end
