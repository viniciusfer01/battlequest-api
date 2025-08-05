class LogParser
  def self.parse(filepath)
    File.foreach(filepath) do |line|
      next if line.strip.empty?

      timestamp_str, time_str, _, event_type, *data_pairs = line.strip.split(/\s+/)
      next unless event_type
      timestamp = Time.parse("#{timestamp_str} #{time_str}")

      data = Hash[data_pairs.map { |s| s.split("=", 2) }]

      GameEvent.create(
        raw_event: line,
        event_type: event_type,
        event_timestamp: timestamp
      )

      # puts "Processando evento: #{event_type} com dados: #{data.inspect}"

      case event_type
      when "PLAYER_JOIN"
        player = Player.find_or_initialize_by(id: data["id"].gsub("p", ""))
        player.name = data["name"]
        player.score ||= 0
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
        QuestCompletion.create(player: player, quest_id: data["quest_id"], xp_gained: data["xp"].to_i, gold_gained: data["gold"].to_i)
      when "BOSS_DEFEAT"
        player = self.find_or_create_placeholder_player(data["defeated_by"])
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
  end

  private

  def self.find_or_create_placeholder_player(player_id_str)
    return nil unless player_id_str

    player_id = player_id_str.gsub("p", "")
    Player.find_or_create_by(id: player_id) do |player|
      player.name = "unknown player p#{player_id}"
      player.score = 0
    end
  end
end
