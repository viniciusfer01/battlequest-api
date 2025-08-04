class LogProcessor
  def initialize(log_file)
    @log_file = log_file
    @defeated_bosses = Hash.new
    @players = Hash.new
    @completed_quests = Hash.new
    @inventory = Hash.new
  end

  def process
    File.open(@log_file, "r") do |file|
      file.each_line do |line|
        process_line(line)
      end
    end

    puts "Defeated bosses summary:"
    @defeated_bosses.each do |boss, count|
      puts "#{boss}: #{count} times"
    end

    puts "Players summary:"
    @players.each do |player_id, stats|
      puts "Player ID: #{player_id}, Kills: #{stats[:kills]}, Deaths: #{stats[:deaths]}, XP: #{stats[:xp]}, Gold: #{stats[:gold]}, HP: #{stats[:hp]}, Location: #{stats[:location]}, Score: #{stats[:score]}"
    end

    puts "Completed quests summary:"
    @completed_quests.each do |player_id, count|
      puts "Player ID: #{player_id}, Completed Quests: #{count}"
    end
  end

  private

  def process_line(line)
    # puts "Processing line: #{line.strip}"
    return if line.strip.empty?

    case line.strip.split(" ")[2]
    when "[COMBAT]"
      process_combat(line)
    when "[CHAT]"
      process_chat(line)
    when "[SYSTEM]"
      process_system(line)
    when "[GAME]"
      process_game(line)
    when "[INFO]"
      # puts "Info log: #{line.strip}"
    else
      puts "Unknown log type: #{line.strip.split(' ')[2]}"
    end
  end

  def process_combat(line)
    # puts "Processing combat log: #{line.strip}"
    # Add combat processing logic here

    if line.include?("BOSS_DEFEAT")
      boss_name = line.split(" ")[4]
      player_id = line.split(" ")[5].split("p")[1]
      # puts "xp and gold for boss defeat: #{line.strip}"
      xp = line.split(" ")[6].split("=")[1].to_i
      gold = line.split(" ")[-1].split("=")[1].to_i
      @defeated_bosses[boss_name] ||= 0
      @defeated_bosses[boss_name] += 1

      @players[player_id] ||= { xp: 0, gold: 0, kills: 0, deaths: 0, hp: 100, location: [ 0, 0 ], score: 0 }
      @players[player_id][:kills] += 1
      @players[player_id][:xp] += xp
      @players[player_id][:gold] += gold

    elsif line.include?("DEATH")
      victim_id = line.split(" ")[4].split("p")[1]
      killer_id = line.split(" ")[5].split("p")[1]

      victim_gold = @players[victim_id] ? @players[victim_id][:gold] : 0

      # puts "Player death: #{line.strip}"
      @players[victim_id] ||= { xp: 0, gold: 0, kills: 0, deaths: 0, hp: 100, location: [ 0, 0 ], score: 0 }
      @players[victim_id][:deaths] += 1
      @players[victim_id][:gold] = 0 # Reset gold on death
      @players[killer_id] ||= { xp: 0, gold: 0, kills: 0, deaths: 0, hp: 100, location: [ 0, 0 ], score: 0 }
      @players[killer_id][:kills] += 1
      @players[killer_id][:gold] += victim_gold
    else
      # puts "Combat log not recognized: #{line.strip}"
    end
  end

  def process_chat(line)
    # puts "Processing chat log: #{line.strip}"
  end

  def process_system(line)
    # puts "Processing system log: #{line.strip}"
  end

  def process_game(line)
    if line.include?("SCORE")
      player_id = line.split(" ")[4].split("=p")[1]
      new_score = line.split(" ")[5].split("=")[1].to_i

      @players[player_id] ||= { xp: 0, gold: 0, kills: 0, deaths: 0, hp: 100, location: [ 0, 0 ], score: 0 }
      @players[player_id][:score] = new_score

    elsif line.include?("QUEST_COMPLETE")
      player_id = line.split(" ")[4].split("=p")[1]
      # quest_id = line.split(" ")[6].split("=q")[1]
      xp = line.split(" ")[6].split("=")[1].to_i
      gold = line.split(" ")[-1].split("=")[1].to_i

      @completed_quests[player_id] ||= 0
      @completed_quests[player_id] += 1

      @players[player_id] ||= { xp: 0, gold: 0, kills: 0, deaths: 0, hp: 100, location: [ 0, 0 ], score: 0 }
      @players[player_id][:xp] += xp
      @players[player_id][:gold] += gold
    end
  end

  def process_info(line)
    # puts "Processing info log: #{line.strip}"
    # Add info processing logic here
  end
end
