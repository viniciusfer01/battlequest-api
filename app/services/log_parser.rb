class LogParser
  def self.parse(filepath)
    File.foreach(filepath) do |line|
      parse_line(line)
    end
  end

  def self.parse_line(line)
    stripped_line = line.strip
    return if stripped_line.empty?

    timestamp_str, time_str, _, event_type, *data_pairs = stripped_line.split(/\s+/, 5)
    return unless event_type

    begin
      timestamp = Time.zone.parse("#{timestamp_str} #{time_str}")
      data_string = data_pairs.first || ""
      data = data_string.scan(/(\w+)="([^"]*)"|(\w+)=([\w\d.-]+)/).to_h do |match|
        [ match[0] || match[2], match[1] || match[3] ]
      end
    rescue ArgumentError
      puts "Skipping malformed line: #{stripped_line}"
      return
    end

    return if GameEvent.exists?(event_timestamp: timestamp, raw_event: stripped_line)

    GameEvent.create(
      raw_event: stripped_line,
      event_type: event_type,
      event_timestamp: timestamp
    )

    # puts "Processando evento: #{event_type} com dados: #{data.inspect}"

    case event_type
    when "PLAYER_JOIN"
      player = Player.find_or_initialize_by(id: data["id"].gsub("p", ""))
      player.name = data["name"]
      player.score ||= 0
      player.gold ||= 0
      player.xp ||= 0
      player.save!
    when "DEATH"
      killer = self.find_or_create_placeholder_player(data["killer_id"])
      victim = self.find_or_create_placeholder_player(data["victim_id"])
      Kill.create(killer: killer, victim: victim, method: data["method"])
    when "ITEM_PICKUP"
      player = self.find_or_create_placeholder_player(data["player_id"])
      ItemPickup.create(player: player, item_name: data["item"], quantity: data["qty"].to_i)
    when "QUEST_COMPLETE"
      player = self.find_or_create_placeholder_player(data["player_id"])
      player.xp += data["xp"].to_i
      player.gold += data["gold"].to_i
      player.save!
      QuestCompletion.create(player: player, quest_id: data["quest_id"], xp_gained: data["xp"].to_i, gold_gained: data["gold"].to_i)
    when "BOSS_DEFEAT"
      player = self.find_or_create_placeholder_player(data["defeated_by"])
      player.xp += data["xp"].to_i
      player.gold += data["gold"].to_i
      player.save!
      BossKill.create(
        player: player,
        boss_name: data["boss_name"],
        xp_gained: data["xp"].to_i,
        gold_gained: data["gold"].to_i
      )
    when "SCORE"
      player = self.find_or_create_placeholder_player(data["player_id"])
      player.score += data["points"].to_i
      # puts "data['points']: #{data["points"]}"
      # puts "inspect data: #{data.inspect}"
      player.save!
    else
      # puts "Evento não tratado: #{event_type}"
    end
  end

  private

  def self.find_or_create_placeholder_player(player_id_str)
    return nil unless player_id_str
    player_id = player_id_str.gsub("p", "")
    Player.find_or_create_by(id: player_id) do |player|
      player.name = "Unknown Player ##{player_id}"
      player.score = 0
      player.gold = 0
      player.xp = 0
    end
  end
end
