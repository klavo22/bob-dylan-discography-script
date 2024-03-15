# Bob Dylan Discography

This Ruby script fetches Bob Dylan's discography and album cover art from the Spotify API, and creates a Trello board with lists sorted by decade, and cards representing each album.

## Prerequisites

- Ruby (version 3.2.2)
- Bundler

## Installation

1. Clone the repository:

```
git clone https://github.com/klavo22/bob-dylan-discography-script.git
```

2. Navigate to the project directory:

```
cd bob-dylan-discography-script
```

3. Install dependencies:

```
bundle install
```

4. Create a `.env` file in the project root and add your Spotify and Trello credentials:

```
SPOTIFY_CLIENT_ID=your_spotify_client_id
SPOTIFY_CLIENT_SECRET=your_spotify_client_secret
TRELLO_DEVELOPER_PUBLIC_KEY=your_trello_developer_public_key
TRELLO_MEMBER_TOKEN=your_trello_member_token
```

## Usage

1. Run the script:

```
bin/run.rb
```

2. After the script finishes executing, you should see the URL of the created Trello board in the console output.
