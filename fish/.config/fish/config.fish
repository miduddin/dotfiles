set -x XDG_CACHE_HOME ~/.cache
set -x XDG_CONFIG_HOME ~/.config
set -x XDG_DATA_HOME ~/.local/share
set -x XDG_STATE_HOME ~/.local/state

set -x BUNDLE_USER_CACHE $XDG_CACHE_HOME/bundle
set -x BUNDLE_USER_CONFIG $XDG_CONFIG_HOME/bundle
set -x BUNDLE_USER_PLUGIN $XDG_DATA_HOME/bundle
set -x CARGO_HOME $XDG_DATA_HOME/cargo
set -x CARGO_NET_GIT_FETCH_WITH_CLI true
set -x COLORTERM truecolor
set -x DOCKER_CONFIG $XDG_CONFIG_HOME/docker
set -x EDITOR nvim
set -x FZF_DEFAULT_OPTS "--reverse --height=10 --no-separator"
set -x GOPATH $XDG_DATA_HOME/go
set -x HISTFILE $XDG_STATE_HOME/bash/history
set -x NPM_CONFIG_USERCONFIG $XDG_CONFIG_HOME/npm/npmrc
set -x NVIM_LOG_FILE /tmp/nvim.log
set -x PGPASSFILE $XDG_CONFIG_HOME/pg/pgpass
set -x PGSERVICEFILE $XDG_CONFIG_HOME/pg/pg_service.conf
set -x PSQLRC $XDG_CONFIG_HOME/psqlrc
set -x PSQL_HISTORY $XDG_DATA_HOME/psql_history
set -x REDISCLI_HISTFILE $XDG_DATA_HOME/redis/rediscli_history
set -x RUSTUP_HOME $XDG_DATA_HOME/rustup
set -x USQLPASS $XDG_CONFIG_HOME/usql/pass
set -x USQLRC $XDG_CONFIG_HOME/usql/rc
set -x USQL_HISTORY $XDG_CONFIG_HOME/usql/history
set -x USQL_TERM_GRAPHICS none

fish_add_path -P \
	$XDG_DATA_HOME/go/bin \
	$XDG_DATA_HOME/cargo/bin \
	$XDG_DATA_HOME/gem/ruby/3.4.0/bin \
	~/.local/google-cloud-sdk/bin \
	~/.local/nvim/bin \
	~/.local/bin \
	/opt/homebrew/bin \
	/opt/homebrew/sbin
