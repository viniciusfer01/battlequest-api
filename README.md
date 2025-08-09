# Battlequest API

Battlequest API is a Ruby on Rails application that processes logs from Battlequest matches, stores structured data in a database, and exposes endpoints for querying player, event, and leaderboard information.

## Overview

- **Log Processing:** Parses game log files and imports events (player joins, kills, item pickups, quest completions, boss kills, etc.) into the database.
- **REST API:** Provides endpoints to query players, events, leaderboards, and dashboard statistics.
- **Authentication:** The dashboard endpoint requires a valid API token.

---

## Models

- **Player:** Stores player information (`id`, `name`, `score`).
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
  List all players.

- `GET /api/v1/players/:id/stats`  
  Show stats for a specific player (kills, deaths, items collected, quests completed, score).

### Leaderboard

- `GET /api/v1/leaderboard`  
  List players ordered by score (descending).

### Items

- `GET /api/v1/items/top`  
  List top 50 items collected, ordered by quantity.

### Events

- `GET /api/v1/events?limit=N`  
  List the most recent N game events (default: 50).

### Dashboard (Requires Authentication)

- `GET /api/v1/dashboard/index`  
  Returns:
  - `active_players`: Total number of players
  - `total_score`: Sum of all player scores
  - `top_items`: Top 5 items collected
  - `top_killers`: Top 5 players by kills
  - `bosses_defeated`: Count of each boss defeated
  - `completed_quests`: Count of each quest completed

  **Authentication:**  
  Pass a valid API token in the `Authorization` header:  
  `Authorization: Bearer <token>`
  When `$ rails db:seed` is executed, it outputs an access token on the terminal:
  `Token de acesso criado: <your-access-token>`
  Then, it's possible to access the dashboard endpoint with
  `$ curl -H "Authorization: Bearer <your-access-token>" http://localhost:3000/api/v1/dashboard/index`

---

## Setup & Usage

### 1. Install dependencies

- `$ bundle install`

### 2. Run migrations

- `$ rails db:migrate`

### 3. Apply seeds

- `$ rails db:seed`

### 4. Run Server

- `$ rails s`

### Run tests

- `$ rails test`

### Process new logs

- `$ rails log:import`

Only logs with a timestamp later than the last imported timestamps are considered
