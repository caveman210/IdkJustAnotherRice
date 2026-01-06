#!/bin/zsh

if [[ $(hyprctl descriptions | jq -r '.decoration:blur:enabled' | jq -r '.data.value' == 'true' ]]; then
    hyprctl --batch "keyword decoration:blur:enabled false"
else
    hyprctl --batch "keyword decoration:blur:enabled true"
fi

