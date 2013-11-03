# /dev/pty/screen
> Terminal pair programming without raster graphics.

> Desktop sharing is for windows devs!

> Tmux!? Who wants to set that all up (not me).

> A sister project to [/dev/pty/vim](https://github.com/dapplebeforedawn/dev-pty-vim)

## Obligatory Recursive Joke:
> Yo dawg, anyone want to pair with me on my pair programming program?

## What's It Do:
  - Only the server runs the application (or even needs it installed for that matter).
  - VIM will be used for example purposes in the rest of this document, but any program can be used
  - Everyone who wishes to be part of the paring session connects to the server.
  - This is a very similar technique to what GNU Screen or TMux do.

## How's It Work:
  - The server's VIM is loaded into a pseudoterminal that is controlled by the server
  - Client keystrokes are sent to the server
  - The server then passes those on to the captive VIM
  - STDOUT from the pseudoterminal is forwarded to the server and the broadcast to cleints
  - Clients have their display updated to match the forwareded STDOUT
  - `ctrl-z` allows clients to disconnect.

## TL;DR - An Animated Gif
![dev-pyt-screen](https://raw.github.com/dapplebeforedawn/dev-pty-screen/master/dev-pty-screen.gif)

## Installation:
Requires Ruby 2.0.0 or better.

```bash
  gem install dev-pty-screen
```

or:

```bash
  # clone this repository
  git clone https://github.com/dapplebeforedawn/dev-pty-screen

  # build the gem
  cd dev-pty-screen
  rake build

  # install the gem
  rake install
```

## Getting Started:
  - On the computer hosting the code to work on.
  ```bash
    cd /a/directory/with/some/code
    dev-pty-server "vim"
  ```

  - On each client
  ```bash
    dev-pty-client
  ```

  - Quitting: ^Z (ctrl+z) prompts your client to quit.  All other keys are forwarded to the server.

## Another Example:
  - Any terminal program can be used (say, the Guard your probably running with your vim)
  ```bash
    dev-pty-server "tail -f log/development.log"
  ```

  - On the client, for a quick log sharing session:
  ```bash
    dev-pty-client
  ```

  - With non-interactive programs, like tail, the clients screen will refresh when the server has new data.

## Defaults:
Since the terminal output from the server is shared with the clients directly, the number of rows/columns on the screen is set by the server.  When starting dev-pty-server, rows/columns are defaulted to the size of the terminal window housing the server.  This can be changed by using the `--rows` and `--columns` options.

## Considerations:
  This approach has a few draw-backs compared to the run-your-own-VIM tact that /dev/pty/vim uses (and a few advantages)

### Positives
  - Since there's only one copy of the files and one running VIM, it's impossible for the buffers or files on disk to be out of sync
  - When a commit is made using a VIM plugin, like [fugitive](https://github.com/tpope/vim-fugitive), only the repository running the server, and it's user make the commit (as opposed to two users making the same commit in two repos)
  - The clients can only interact with the server, but not each other.  This means in an untrusted pairing session, you could run the server on a temporary ec2, and invite strangers to pair without giving them access to your private network.
  - A hell of a lot less setup than /dev/pty/vim

### Negatives
  - As with /dev/pty/vim all clients need to share a common .vimrc (and plugins).  Here it's inforced by there only being on copy of VIM running, as opposed to a pre-connect .vimrc handshake.
  - Since the clients are dumb terminals, and they may have different screen sizes, some clients may not get a full screen experience.  Screen size is controlled by the server, and forced upon the clients.

## Work in Progress:
 - When a client initially connects they need to press key to get STDOUT to re-paint.  Telling VIM to create a new tab (`:tabnew`) is a simple work around for now.
 - Notifications about who is typing
 - Custom .vimrcs that are applied when a client is typing
 - Replace all the `Thread.new` calls with a celluloid actor
 - Seriously, why are arrow keys so hard to work with !?

## Application Structure
  ```
  ├── bin
  │   ├── dev-pty-client                # Run this to start a client
  │   └── dev-pty-server                # Run this to start a server
  ├── lib
  │   ├── client
  │   │   ├── app.rb
  │   │   └── options.rb                # Options parser for the client
  │   └── server
  │       ├── app.rb
  │       ├── key_server.rb             # Listens for keys strokes from clients
  │       ├── options.rb                # Options parser for the server
  │       ├── pty_server.rb             # Manages the screen/key servers and the application_interface
  │       ├── screen_server.rb          # Pushes STDOUT updates to clients
  │       └── application_interface.rb  # Sends keystrokes to the captive VIM
  |
  ├── spec
      ├── client
      └── server
          ├── key_server_spec.rb
          ├── pty_server_spec.rb
          └── screen_server_spec.rb
  ```

## Running the Tests:
```bash
  rspec
```

## Support:
  - File a bug here
  - Contact me on twitter/email : @soodesune/markjlorenz@gmail.com
