## Server:
  - Start VIM in a PTY
  - Listen for `screen_connection` requests
  - Listen for `key_connection` requests
  - Listen for keys from `key_connection` clients
  - Send those keys to vim and log them
  - Send the updated screen to the `screen_clients`

