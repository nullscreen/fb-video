# Changelog

All notable changes to this project will be documented in this file.

For more information about changelogs, check
[Keep a Changelog](http://keepachangelog.com) and
[Vandamme](http://tech-angels.github.io/vandamme).

## 0.2.3 - 2016/06/22

* [FEATURE] Add `page_name` of a video found by API call (which is `Funky::Video.where`)

## 0.2.2 - 2016/06/17

* [BUGFIX] Single video id passed to the `Funky::Video.where` clause will not
error even if the response is not 200. It would return an empty array.

## 0.2.1  - 2016/06/16

* [FEATURE] Add method to find video by url, `Funky::Video.find_by_url!(url)`.
The following URL formats are currently supported:
- `https://www.facebook.com/{page_name}/videos/vb.{alt_page_id}/{video_id}/`
- `https://www.facebook.com/{page_name}/videos/{video_id}/`
- `https://www.facebook.com/{page_id}/videos/{video_id}/`
- `https://www.facebook.com/video.php?v={video_id}`

## 0.2.0  - 2016/06/07

**How to upgrade**

If your code never calls `Funky::Video#view_count`, then you are good to go.

If it does, then be aware that Facebook has started displaying two types of
view counts in the video page: 'views from this post' and 'cumulative views'.
For coherence with the videos without this new type of page, `view_count` will
always return the "views from this post" (whereas it was returning cumulative
views in 0.1.1)

* [ENHANCEMENT] Always return 'views from this post' in `Funky::Video#view_count`.

## 0.1.1  - 2016/06/07

* [BUGFIX] Added support for scraping view count from the new cumulative views that Facebook recently started rolling out.

## 0.1.0  - 2016/05/26

* [FEATURE] Added support for Facebook video data. Currently we can get the video id, length, description, created_time, picture, view_count, share_count, comment_count, and like_count.
