P := "$$(tput setaf 2)"
S := "$$(tput setaf 4)"
L := "$$(tput setaf 6)"
G := "$$(tput setaf 10)"
R := "$$(tput sgr0)"
usage:
	@echo ""
	@echo " $(L)┏━━━━━━━━━━━━━━━━━━━━━━━━━━┓$(R)"
	@echo " $(L)┃ $(R)Docker Development Stack$(L) ┃$(R)"
	@echo " $(L)┡━━━━━━━━━━━━━━━━━━━━━━━━━━┩$(R)"
	@echo " $(L)│ $(R)Available Commands:$(L)      │$(R)"
	@echo " $(L)╰─┬────────────────────────╯$(R)"
	@echo "   $(L)╰─$(R) $(P)up$(R) - launch full docker development stack"
	@echo ""

MKFILE := $(abspath $(lastword $(MAKEFILE_LIST)))
MKDIR  := $(dir $(MKFILE))

GIT_BRANCH = $(shell git rev-parse --abbrev-ref HEAD)

# Shortcuts
up:
	@echo "$(P)Launching Infrastructure Containers...$(R)";\
	COMPOSE_IGNORE_ORPHANS=True docker-compose --log-level ERROR -p dockerstack up -d;\
	echo "$(G)Done!$(R)\n\r"
