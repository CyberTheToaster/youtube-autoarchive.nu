#Gets The Channel ID from a Channel URL
export def get-channel-id [
    url: string
]: [nothing -> string] {
    try { http get $url } | parse --regex '<meta itemprop="identifier" content="(?<ID>.{1,24})">' | get ID.0 --optional
}
#Turns inputted channel id into an rss feed.
export def channel-id-to-rss [id?: string]: [oneof<string,nothing> -> string] {
    if $id != null {
        ["https://www.youtube.com/feeds/videos.xml?channel_id=" $id] | str join 
    } else {
        ["https://www.youtube.com/feeds/videos.xml?channel_id=" $in] | str join
    }
}
#Backs up the most recent video.
export def backup-most-recent [
    rss_feed: string
]: [nothing -> nothing ] {
    let video_table: table  = try { http get $rss_feed --raw } | parse --regex '<link rel="alternate" href="https:\/\/www\.youtube\.com\/watch\?v=(?<videoURL>.{11})"\/>';
    let most_recent_video: string = $video_table | get videoURL.0 --optional;
    yt-dlp --sleep-interval 5 --max-sleep-interval 10 $most_recent_video;
}