# Battlequest API

Battlequest API is a Ruby on Rails application that processes logs from Battlequest matches, stores structured data in a database, and exposes endpoints for querying player, event, and leaderboard information.

## Overview

- **Log Processing:** Parses game log files and imports events (player joins, kills, item pickups, quest completions, boss kills, etc.) into the database.
- **REST API:** Provides endpoints to query players, events, leaderboards, and dashboard statistics.
- **Authentication:** The dashboard endpoint requires a valid API token.
- **Requirements** Rails 8.0.2+, Ruby 3.3.2+

---

## Models

- **Player:** Stores player information (`id`, `name`, `score`, `xp`, `gold`).
- **Kill:** Records kills between players (`killer_id`, `victim_id`, `method`).
- **ItemPickup:** Tracks items collected by players (`player_id`, `item_name`, `quantity`).
- **QuestCompletion:** Logs quest completions (`player_id`, `quest_id`, `xp_gained`, `gold_gained`).
- **BossKill:** Records boss defeats (`player_id`, `boss_name`, `xp_gained`, `gold_gained`).
- **GameEvent:** Stores raw log events and their parsed types/timestamps.
- **ApiToken:** Used for authenticating dashboard requests.

---

## API Endpoints

All endpoints are prefixed with `/api/v1/`.

### Players

- `GET /api/v1/players`  
  List all players with basic information.

- `GET /api/v1/players/:id/stats`  
  Shows detailed stats for a specific player, including:

- Basic info (id, name, score, gold, xp)

- Combat stats (kills, deaths, nemesis)

- Collections (bosses_killed_names, collected_item_names)

- Quest progress (quests_started, quests_completed, started_quest_names, finished_quest_names)

- PvP stats (killed_player_names)

- `GET /api/v1/players/:player_id/quests/started`

  Lists all quests a player has started but not yet completed. Supports a limit parameter.

- `GET /api/v1/players/:player_id/quests/completed`

  Lists all quests a player has completed. Supports a limit parameter.

### Leaderboard

- `GET /api/v1/leaderboard`  
  List players ordered by score (default).

- `GET api/v1/leaderboard/gold`

  Lists players ordered by total gold.

- `GET api/v1/leaderboard/xp`

  Lists players ordered by total XP.

### Items

- `GET /api/v1/items/top`  
  List top 50 most collected items at a time, ordered by quantity.

### Events

- `GET /api/v1/events?limit=N`  
  List the most recent N game events (default: 50).

### Dashboard (Requires Authentication)

- `GET /api/v1/dashboard/index`  
  Returns:
  - `active_players`: Total number of players
  - `total_score`: Sum of all player scores
  - `top_items`: Top 5 items collected overall
  - `top_killers`: Top 5 players by kills
  - `bosses_defeated`: Count of each boss defeated
  - `completed_quests`: Count of each quest completed

  **Authentication:**  
  Pass a valid API token in the `Authorization` header:  
  `Authorization: Bearer <token>`
  When `$ bin/rails db:seed` is executed, it outputs an access token on the terminal:
  `Token de acesso criado: <your-access-token>`
  Then, it's possible to access the dashboard endpoint with
  `$ curl -H "Authorization: Bearer <your-access-token>" http://localhost:3000/api/v1/dashboard/index`

### Chat

-`GET /chat`  
    Lists recent chat messages and server announcements, ordered by most recent.

    **Query Parameters:**
    -`limit` (optional): The maximum number of messages to return. Defaults to `100`.
    -`start_time` (optional): The start of the time interval to filter messages. Should be in ISO 8601 format (e.g., `2025-08-10T20:00:00Z`).
    -`end_time` (optional): The end of the time interval to filter messages. Should be in ISO 8601 format.

---

## Setup & Usage

### 1. Install dependencies

- `$ bundle install`

### 2. Create DB and run migrations

- `$ bin/rails db:create`
- `$ bin/rails db:migrate`

### 3. Apply seeds

- `$ bin/rails db:seed`

### 4. Run Server

- `$ bin/rails s`

### Run tests

- `$ bin/rails test`

### Process new logs

- `$ bin/rails log:import`

Only logs with a timestamp later than the last imported timestamps are considered
