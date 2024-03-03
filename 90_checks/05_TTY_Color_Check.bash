#!/usr/bin/env bash

printf "Colors 0 to 15 for the standard 16 foreground colors\n"

for ((c = 0; c < 16; c++)); do
	printf "|%s%3d%s" "$(tput setaf "$c")" "$c" "$(tput sgr0)"
done
printf "|\n\n"


printf "Colors 0 to 15 for the standard 16 background colors\n"

for ((c = 0; c < 16; c++)); do
	printf "|%s%3d%s" "$(tput setab "$c")" "$c" "$(tput sgr0)"
done
printf "|\n\n"
