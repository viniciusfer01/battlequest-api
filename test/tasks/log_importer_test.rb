require "test_helper"
require "rake"
require "mocha/minitest"

class LogImporterTest < ActiveSupport::TestCase
  setup do
    BattlequestApi::Application.load_tasks if Rake::Task.tasks.empty?
    Rake::Task["log:import"].reenable
  end

  teardown do
    File.delete(@log_path) if @log_path && File.exist?(@log_path)
  end

  test "initial import should process all log entries" do
    log_content = <<~LOG
      2025-08-05 10:00:00 [INFO] PLAYER_JOIN id=p1 name=Alice level=1 zone=Start
      2025-08-05 10:01:00 [GAME] ITEM_PICKUP player_id=p1 item=health_potion qty=1
      2025-08-05 10:02:00 [COMBAT] DEATH victim_id=p1 killer_id=p2 method=sword
    LOG
    create_temp_log_file(log_content)

    # 2. Action: Run the Rake task
    assert_difference("GameEvent.count", 3) do
      Rake::Task["log:import"].invoke
    end

    # 3. Assertions
    assert_equal 3, Player.count # p1 and p2 (placeholder)
    assert_equal 1, ItemPickup.count
    assert_equal 1, Kill.count
  end

  test "incremental import should only process new log entries" do
    # 1. Setup: Create an initial event in the database
    GameEvent.create!(
      raw_event: "2025-08-05 10:00:00 [INFO] PLAYER_JOIN id=p1 name=Alice level=1 zone=Start",
      event_type: "PLAYER_JOIN",
      event_timestamp: "2025-08-05 10:00:00"
    )

    # Create a log file with one old and two new entries
    log_content = <<~LOG
      2025-08-05 10:00:00 [INFO] PLAYER_JOIN id=p1 name=Alice level=1 zone=Start
      2025-08-05 10:01:00 [GAME] ITEM_PICKUP player_id=p1 item=health_potion qty=1
      2025-08-05 10:02:00 [COMBAT] DEATH victim_id=p1 killer_id=p2 method=sword
    LOG
    create_temp_log_file(log_content)

    # 2. Action: Run the task, expecting only 2 new events
    assert_difference("GameEvent.count", 2) do
      Rake::Task["log:import"].invoke
    end
  end

  test "import should not add events if log has not changed" do
    # 1. Setup: Create a log file and run the import once
    log_content = <<~LOG
      2025-08-05 10:00:00 [INFO] PLAYER_JOIN id=p1 name=Alice level=1 zone=Start
    LOG
    create_temp_log_file(log_content)
    Rake::Task["log:import"].invoke
    Rake::Task["log:import"].reenable # Re-enable for the second run

    # 2. Action: Run the task again with no changes
    #    We expect no new GameEvents to be created
    assert_no_difference("GameEvent.count") do
      Rake::Task["log:import"].invoke
    end
  end

  private

  # Helper method to create a temp log file and tell the Rake task where to find it
  def create_temp_log_file(content)
    # Create a temporary file that will be automatically cleaned up
    @temp_log = Tempfile.new("test_log.txt")
    @temp_log.write(content)
    @temp_log.close
    @log_path = @temp_log.path

    # IMPORTANT: We need to tell our Rake task to use this temporary file.
    # We do this by "stubbing" Rails.root.join to return our temp path.
    Rails.root.stubs(:join).with("game_log_large.txt").returns(@log_path)
  end
end
