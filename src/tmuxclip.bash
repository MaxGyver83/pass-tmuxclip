#!/usr/bin/env bash

clip() {
	if [[ -n $TMUX ]] && command -v tmux &> /dev/null; then
		local copy_cmd=( tmux load-buffer - )
		local paste_cmd=( tmux save-buffer - )
	else
		die "Error: No tmux session detected"
	fi
	local sleep_argv0="password store sleep in tmux"

	# This base64 business is because bash cannot store binary data in a shell
	# variable. Specifically, it cannot store nulls nor (non-trivally) store
	# trailing new lines.
	pkill -f "^$sleep_argv0" 2>/dev/null && sleep 0.5
	local before="$("${paste_cmd[@]}" 2>/dev/null | $BASE64)"
	echo -n "$1" | "${copy_cmd[@]}" || die "Error: Could not copy data to the tmux paste buffer"
	(
		( exec -a "$sleep_argv0" bash <<<"trap 'kill %1' TERM; sleep '$CLIP_TIME' & wait" )
		local now="$("${paste_cmd[@]}" | $BASE64)"
		[[ $now != $(echo -n "$1" | $BASE64) ]] && before="$now"

		echo "$before" | $BASE64 -d | "${copy_cmd[@]}"
	) >/dev/null 2>&1 & disown
	echo "Copied $2 to tmux paste buffer. Will clear in $CLIP_TIME seconds."
}

cmd_show --clip "$@"
