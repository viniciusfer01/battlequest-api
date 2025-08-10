require "test_helper"

class ChatMessageTest < ActiveSupport::TestCase
  # create_table :chat_messages do |t|
  #     t.references :player, null: false, foreign_key: true
  #     t.string :message_type, null: false
  #     t.text :content, null: false
  #     t.datetime :event_timestamp, null: false

  #     t.timestamps
  #   end
  test "created succesfully" do
    zezin = players(:zezin)
    chat_message = ChatMessage.create(
      player: zezin,
      message_type: "chat",
      content: "Hello, world!",
      event_timestamp: Time.now
    )
    assert chat_message.valid?
  end

  test "invalid without player" do
    chat_message = ChatMessage.new(
      message_type: "chat",
      content: "Hello, world!",
      event_timestamp: Time.now
    )
    assert_not chat_message.valid?
    assert_includes chat_message.errors[:player], "can't be blank"
  end

  test "invalid without message_type" do
    zezin = players(:zezin)
    chat_message = ChatMessage.new(
      player: zezin,
      content: "Hello, world!",
      event_timestamp: Time.now
    )
    assert_not chat_message.valid?
    assert_includes chat_message.errors[:message_type], "can't be blank"
  end

  test "invalid without content" do
    zezin = players(:zezin)
    chat_message = ChatMessage.new(
      player: zezin,
      message_type: "chat",
      event_timestamp: Time.now
    )
    assert_not chat_message.valid?
    assert_includes chat_message.errors[:content], "can't be blank"
  end

  test "invalid without event_timestamp" do
    zezin = players(:zezin)
    chat_message = ChatMessage.new(
      player: zezin,
      message_type: "chat",
      content: "Hello, world!"
    )
    assert_not chat_message.valid?
    assert_includes chat_message.errors[:event_timestamp], "can't be blank"
  end

  test "event_timestamp must be a valid datetime" do
    zezin = players(:zezin)
    chat_message = ChatMessage.new(
      player: zezin,
      message_type: "chat",
      content: "Hello, world!",
      event_timestamp: "invalid datetime"
    )
    assert_not chat_message.valid?
    assert_includes chat_message.errors[:event_timestamp], "can't be blank"
  end

  test "message_type must be either 'chat' or 'announcement'" do
    zezin = players(:zezin)
    chat_message = ChatMessage.new(
      player: zezin,
      message_type: "invalid_type",
      content: "Hello, world!",
      event_timestamp: Time.now
    )
    assert_not chat_message.valid?
    assert_includes chat_message.errors[:message_type], "is not included in the list"
  end
end
