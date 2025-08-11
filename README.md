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

  - Filters: name (partial match), min_score, max_score, min_kills, etc

  - Pagination: page (default: 1), per_page (default: 5, max: 100)

  - Example: `/players?name=dragon&min_kills=10&page=2`

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

  - Filters: name (partial match), min_score, min_gold

  - Pagination: page (default: 1), per_page (default: 5, max: 100)

  - Example: `/leaderboard?min_gold=50&per_page=20`

- `GET api/v1/leaderboard/gold`

  Lists players ordered by total gold.

- `GET api/v1/leaderboard/xp`

  Lists players ordered by total XP.

### Items

- `GET /api/v1/items/top`  
  List the top looted items.

  - Filters: name (partial match), gt (greater than x), gte (greater than or equal to x), lt (lower than x), lte (lower than or equal to x), eq (for total quantity)

  - Pagination: page (default: 1), per_page (default: 5, max: 100)

  - Example: `/items/top?name=potion&gte=100`

### Events

- `GET api/v1/events`
  List the last logged events.

  - Pagination: page (default: 1), per_page (default: 25, max: 200)

  - Example: `/events?page=3&per_page=50`

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

## Setup & Usage (with Docker)
This project is configured to run in a Docker container, providing a consistent development environment.

### Prerequisites
Docker and Docker Compose: Ensure you have both installed on your system.

VS Code + Dev Containers extension: Install Visual Studio Code and the ms-vscode-remote.remote-containers extension.

### 1. Start the Development Container
Clone the repository to your local machine.

Open the project folder in VS Code.

A notification will appear asking to "Reopen in Container". Click it.

VS Code will build the Docker image and start the container. This may take a few minutes on the first run.

### 2. Set Up the Database
Once the container is running, open a new terminal within VS Code (Terminal > New Terminal). All subsequent commands should be run inside this container terminal.

`
Bash

# Create the SQLite database
bin/rails db:create

# Run database migrations
bin/rails db:migrate
`

### 3. Apply Seeds (Initial Data Load)
This command will parse the game_log_large.txt file and populate your database. It will also generate a valid API token for the dashboard.

`
Bash

bin/rails db:seed
`

### 4. Run the Server
Your Rails server is automatically started by Docker Compose. You can access the API at http://localhost:3000.

### 5. Run Tests
To run the test suite, use the following command in the container terminal:

`
Bash

bin/rails test
`

### 6. Process New Logs (Continuous Update)
To process new lines that have been added to the log file after the initial seed, run:

`
Bash

bin/rails log:import
`

