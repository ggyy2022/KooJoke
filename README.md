# KooJoke

KooJoke — an Objective-C iOS app skeleton (pure code, no storyboard) with four tabs: Jokes, Video, Girls, Featured.

Features included in this repository:
- Jokes: pull-to-refresh and pagination
- Video: short-video style vertical feed with auto-play and fullscreen
- Girls: two-column image grid with pull-to-refresh, load more, and big-image viewer
- Featured: simple banner carousel

Dependencies (CocoaPods): AFNetworking, SDWebImage, Masonry, MJRefresh, SDCycleScrollView

How to run
1. Install CocoaPods if you don't have it: `sudo gem install cocoapods`
2. In the project root run `pod install`
3. Open KooJoke.xcworkspace in Xcode and run (iOS 13+)

Notes
- This repo contains a code skeleton and mock data (sample image/video URLs). Replace API endpoints and assets as needed.
