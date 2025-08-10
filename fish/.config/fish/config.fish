set -x CARGO_HOME ~/.local/share/cargo
set -x CARGO_NET_GIT_FETCH_WITH_CLI true
set -x COLORTERM truecolor
set -x DOCKER_CONFIG ~/.config/docker
set -x EDITOR nvim
set -x FZF_DEFAULT_OPTS "--reverse --height=10 --no-separator"
set -x GOPATH ~/.local/share/go
set -x HISTFILE ~/.local/state/bash/history
set -x NPM_CONFIG_USERCONFIG ~/.config/npm/npmrc
set -x NVIM_LOG_FILE /tmp/nvim.log
set -x PGPASSFILE ~/.config/pg/pgpass
set -x PGSERVICEFILE ~/.config/pg/pg_service.conf
set -x PSQLRC ~/.config/psqlrc
set -x PSQL_HISTORY ~/.local/share/psql_history
set -x REDISCLI_HISTFILE ~/.local/share/redis/rediscli_history
set -x RUSTUP_HOME ~/.local/share/rustup
set -x USQLPASS ~/.config/usql/pass
set -x USQLRC ~/.config/usql/rc
set -x USQL_HISTORY ~/.config/usql/history
set -x USQL_TERM_GRAPHICS none
set -x XDG_CACHE_HOME ~/.cache
set -x XDG_CONFIG_HOME ~/.config
set -x XDG_DATA_HOME ~/.local/share
set -x XDG_STATE_HOME ~/.local/state

fish_add_path -P \
	~/.local/share/go/bin \
	~/.local/share/cargo/bin \
	~/.local/bin \
	/usr/local/go/bin \
	/opt/google-cloud-cli/bin \
	/opt/homebrew/bin \
	/opt/homebrew/sbin

if status is-interactive
	# Commands to run in interactive sessions can go here
end

if test -n "$WT_SESSION"
	function storePathForWindowsTerminal --on-variable PWD
		printf "\e]9;9;%s\e\\" (wslpath -w "$PWD")
	end
end

if test -f ~/.phpbrew/phpbrew.fish
	source ~/.phpbrew/phpbrew.fish
end
