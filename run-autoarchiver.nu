use youtube-autoarchive-core.nu *
def main [
    channel_url: string # Url of the request channel to autoarchive.
    attempt_interval: duration # Time between server contact attempts.
]: nothing -> nothing {
    let spans = {
        channel_url: ((metadata $channel_url).span)
        attempt_interval_: ((metadata $attempt_interval).span)
    }
    if (($channel_url | find --regex '(?:"https?:\/\/)?(www\.)?youtube\.com\/(channel\/UC[\w-]{21}[AQgw]|(c\/|user\/)?[\w@-]+)') == null) {
        error make {
            code: 'autoarchiver::validation::invalid_channel_url'
            msg: 'The provided Channel URL is invalid.'
            labels: [
                {text: "Not a valid Channel URL" span: $spans.channel_url}
            ]
        }
    }  
    while true {
    get-channel-id $channel_url | channel-id-to-rss | backup-most-recent $in;
    sleep $attempt_interval 
    }
}