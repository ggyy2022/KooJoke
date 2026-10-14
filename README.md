# KooJoke (enhancement/v1)

This branch upgrades the skeleton into a more production-like starter.

New features in enhancement/v1:
- ZFPlayer integration for smoother video feed
- Production-like NetworkManager + APIClient (baseURL, timeout, reachability, simple retries)
- Theme and Logger utilities for consistent styling and debugging
- Girls page converted to waterfall layout (CHTCollectionViewWaterfallLayout)
- README updated with additional instructions (Info.plist keys for saving images)

How to run locally
1. Checkout the branch: git checkout enhancement/v1
2. Run: pod install
3. Open KooJoke.xcworkspace
4. Ensure Info.plist contains NSPhotoLibraryAddUsageDescription if you want to save images
5. Build and run (simulator or device). Video autoplay and image save require network and device features.

Notes
- This branch does not add binary assets (icons/launch images). Add as needed.
- If you use a device to save images, grant Photos permission when prompted.
