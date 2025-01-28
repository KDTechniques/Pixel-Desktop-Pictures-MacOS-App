# Pixel Desktop Pictures 🏞️ 🌁 🌄
## The `Unsplash Wallpapers` MacOS App Killer 😈

> [!Note]
> This macOS app is a complete redesign and reengineering of the **Unsplash Wallpapers** macOS app, improved in every way to provide a better user experience—especially in the Collections tab.
>
> While the **Unsplash Wallpapers** app doesn’t allow you to create custom collections tailored to your preferences, this app does.
> If you’ve ever used the **Unsplash Wallpapers** app on your Mac, you’ll notice significant differences in the **Collections** tab.
>
> This app is primarily built to meet the owner's specific requirements.
>
> *[Compare with Unsplash Wallpapers macOS app here](https://apps.apple.com/us/app/unsplash-wallpapers/id1284863847?mt=12)*


> [!Important]
> Please use the following public key as your API access key and inject it into the API access key text field in the **Settings** tab.
> Otherwise create your API access key by following the guidelines in the API access key injection sheet in the **Settings** tab.
>
> ***Public API Access Key `7ej27jdK3xA-t6PhPiFYfPts0jUsv-WLQxa61g0gDrI`***

> [!Tip]
> The above public API access key may be rate-limited(reached maximum requests per hour), allowing only 50 requests per hour.
> Therefore, it’s always recommended to create your API access key.
>
> First, try using the public API key. Create your API access key if you encounter an error on the app interface.

## 👨🏻‍🏫 Introduction
**Pixel Desktop Pictures** is a macOS-exclusive Menu Bar app designed to enhance your desktop experience with stunning wallpapers from Unsplash. The app is structured around four main tabs: **Main, Recents, Collections, and Settings**, each serving a specific purpose with a clear separation of concerns.

**Terminologies:** The following terminologies are used to match the design requirements of the Mac operating system. We don't say wallpaper in the context of Macs. The same applies to spaces, and We don't call them desktops like on operating systems like MS Windows.
- Show on all spaces = Show wallpaper on all desktops
- Desktop Picture = Desktop Wallpaper

I know you’d prefer seeing the app in action over reading a wall of text—so I’ve included GIF previews for your convenience. 😉

|Dark Mode|Light Mode|
|-|-|
|<img src='https://github.com/KDTechniques/Pixel-Desktop-Pictures-MacOS-App-ReadMe-Media-Files/blob/main/Preview%20-%20Dark%20Mode.jpg?raw=true'>|<img src='https://github.com/KDTechniques/Pixel-Desktop-Pictures-MacOS-App-ReadMe-Media-Files/blob/main/Preview%20-%20Light%20Mode.jpg?raw=true'>|


## 📹 Previews 

# `MAIN` Tab 🖼️
### General Description:

The **Main** tab lets you explore and set beautiful desktop wallpapers tailored to your preferences. You can refresh images based on your selected collections, set a new image as your desktop wallpaper, or download it in the highest available quality directly to your Mac.

<img src='https://github.com/KDTechniques/Pixel-Desktop-Pictures-MacOS-App-ReadMe-Media-Files/blob/main/The%20Basics%20-%20Video%20Preview.gif?raw=true'>

### Technical Details:
<details>
<summary>Click here to read more</summary>
<br>  
  
The **Main** tab leverages Unsplash’s API to fetch and display high-quality images. Depending on your configuration, it retrieves images via two API endpoints:

**1. Random Image Endpoint:**
This endpoint fetches a single random image, ideal for variety and surprise.

**URL:**
`https://api.unsplash.com/photos/random?orientation=landscape`
- **Orientation** is set to `landscape` to ensure compatibility with macOS desktop wallpapers.
- The app doesn’t include additional parameters at this time to keep the implementation simple and focused.

**Decoded Attributes:**

- **Image URLs:** Available in three resolutions—Full, Regular (1080px width), and Small (400px width).
  - **Full:** Used for setting desktop wallpapers to ensure maximum quality.
  - **Regular:** Used for image previews in the **Main** tab.
  - **Small:** Used for previews in the **Recents** and Collections tabs.

- **User Information:** Includes the author’s name and a link to the image on Unsplash.
- **Image Location:** Displays the location where the photo was taken (if provided).
- **Download Link:** Ensures accurate download counts on Unsplash, supporting the image author.

> [!Note]
> The app uses Unsplash's dedicated download URL instead of the `full` resolution URL for downloading. This contributes to the photographer's download count on Unsplash, which supports their work.

**2. Query Image Endpoint:**
This endpoint fetches images based on specific search terms, such as `Nature`.

**URL Example:**
`https://api.unsplash.com/search/photos?orientation=landscape&page=1&per_page=10&query=Nature`

  - **Query Parameter:** Dynamically takes the name of a selected collection to fetch relevant images.
  - **Pagination:** Images are fetched in batches of 10. The `page` parameter increments to retrieve additional results.

**Key Differences from the Random Endpoint:**

- **Image Location**: Not included in the response for query-based searches.
- Other attributes, such as image URLs and user information, are consistent.

**Persistence:**
All fetched images are stored locally on the Mac using **SwiftData** for efficient and persistent access.

**Placeholder Handling:**
Instead of pre-downloading thumbnail images for placeholders, the app displays a random **mesh gradient** view as a placeholder while the high-resolution image is being downloaded. This approach avoids unnecessary complexity while maintaining a smooth user experience.

> **Why not use thumbnails?**
> 
> Downloading thumbnails could improve user experience by providing a quicker preview. However, this would increase app complexity for a relatively simple requirement. The chosen solution balances functionality and simplicity effectively.

**User Experience:**
- Refreshing the image triggers a smooth fade animation for a seamless transition.
- Users can click the author’s name in the bottom-left corner to view the original image on the Unsplash website.
- Images can be downloaded directly to the Mac’s **Downloads** folder in the highest available resolution, contributing to the author’s download count on Unsplash.
</details>


# `RECENTS` Tab ⏱️
### General Description:

The **Recents** tab organizes previously refreshed images in reverse chronological order, making it easy for you to revisit them. You can click on an image in this tab to:

  - Set it as the **Main** tab's active image and access its full set of functionalities.
  - Set it as your desktop picture if you change your mind later.

This feature provides you with another opportunity to reuse a previously loaded image, ensuring you don't lose access to an image you liked while refreshing rapidly.

<img src='https://github.com/KDTechniques/Pixel-Desktop-Pictures-MacOS-App-ReadMe-Media-Files/blob/main/Recents%20-%20Video%20Preview.gif?raw=true'>

### Technical Details:
<details>
<summary>Click here to read more</summary>
<br>  
  
- **Image Persistence:**

  Each time you refresh to load a new image in the **Main** tab, the image is automatically added to the **Recents** tab and stored persistently. This ensures that you can always revisit it, even after navigating away or closing the app.

- **Image Resolution:**
  
  All images in the **Recents** tab are displayed in a smaller resolution format (400px width) to reduce memory consumption.

- **Efficient Image Caching:**
  
  A third-party image caching library is utilized to optimize image loading, ensuring:
    - Minimal memory usage.
    - Reduced network bandwidth.
    - Quick retrieval of images while scrolling.

- **Image Retention Policy:**

    To avoid excessive storage, the app maintains a maximum of **102 images**, organized in a 3x34 vertical grid.
    - Once the limit is reached, the **oldest image** is deleted automatically for every subsequent refresh.
    - Users cannot manually delete images, as the app handles cleanup implicitly to ensure seamless operation.

</details>
