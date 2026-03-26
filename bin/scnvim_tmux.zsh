#!/usr/bin/env zsh

# TODO: get a better theme for bat that doesn't make the post window dominate over the actual code!
tail -F "$1" | bat --paging=never --style=plain --theme=OneHalfLight -l log
