function parseTime(seconds)
    local minutes = floor(mod(seconds, 3600) / 60)
    local seconds = floor(mod(time,60))
    return format("%d:%02d", minutes, seconds)
end