use youtube-autoarchive-core.nu *
def main [
    channel_url: string # Url of the request channel to autoarchive.
    attempt_interval: duration # Time between server contact attempts.
]: nothing -> nothing {
    while true {
    get-channel-id $channel_url | channel-id-to-rss | backup-most-recent $in;
    sleep $attempt_interval 
    }
}