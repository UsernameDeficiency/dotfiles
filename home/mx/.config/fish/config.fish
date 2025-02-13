# Some themes that I like:
# catppuccin_frappe: clean one-line
# amro: clean two-line
# craver, tiwahu: two-line "bar" with a bit more info than amro
# pure: clean two-line, only shows prompt at bottom (not in history)
set theme pure
set theme_url https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/refs/heads/main/themes/"$theme".omp.json

if status is-interactive
	oh-my-posh init fish --config $theme_url | source
end

