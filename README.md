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

**3. Persistence:**
All fetched images are stored locally on the Mac using **SwiftData** for efficient and persistent access.

**4. Placeholder Handling:**
Instead of pre-downloading thumbnail images for placeholders, the app displays a random **mesh gradient** view as a placeholder while the high-resolution image is being downloaded. This approach avoids unnecessary complexity while maintaining a smooth user experience.

> **Why not use thumbnails?**
> 
> Downloading thumbnails could improve user experience by providing a quicker preview. However, this would increase app complexity for a relatively simple requirement. The chosen solution balances functionality and simplicity effectively.

**5. User Experience:**
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
  
**1. Image Persistence:**

Each time you refresh to load a new image in the **Main** tab, the image is automatically added to the **Recents** tab and stored persistently. This ensures that you can always revisit it, even after navigating away or closing the app.

**2. Image Resolution:**

All images in the **Recents** tab are displayed in a smaller resolution format (400px width) to reduce memory consumption.

**3. Efficient Image Caching:**
- A third-party image caching library is utilized to optimize image loading, ensuring:
  - Minimal memory usage.
  - Reduced network bandwidth.
  - Quick retrieval of images while scrolling.

**4. Image Retention Policy:**

To avoid excessive storage, the app maintains a maximum of **102 images**, organized in a 3x34 vertical grid.
  - Once the limit is reached, the **oldest image** is deleted automatically for every subsequent refresh.
  - Users cannot manually delete images, as the app handles cleanup implicitly to ensure seamless operation.

</details>


# `COLLECTIONS` Tab 🌄🏞️🌁
### General Description:

The **Collections** tab is the heart🫀 of this app, offering a level of customization and functionality that sets it apart from the **Unsplash Wallpapers** macOS app. This tab allows you to explore your favorite themes by creating and managing custom collections tailored to your interests.

For example, if you’re a cat lover (like the app’s author 😉), you can create a collection called **"Cat"** to refresh through stunning cat-themed wallpapers. Prefer orange cats? Simply rename the collection to **"Orange Cat"** to focus your results.

You can further organize your collections by:
  - Updating a collection’s thumbnail to a specific image.
  - Deleting collections that you no longer need.

This tab puts control firmly in your hands, letting you curate and refine your wallpaper experience effortlessly.

##### 1) Creation of collections:
<img src='https://github.com/KDTechniques/Pixel-Desktop-Pictures-MacOS-App-ReadMe-Media-Files/blob/main/Creation%20of%20Collections%20-%20Video%20Preview.gif?raw=true'>

##### 2) Selection of collections:
<img src='https://github.com/KDTechniques/Pixel-Desktop-Pictures-MacOS-App-ReadMe-Media-Files/blob/main/Selection%20of%20Collections%20-%20Video%20Preview.gif?raw=true'>

##### 3) Update of collections:
<img src='https://github.com/KDTechniques/Pixel-Desktop-Pictures-MacOS-App-ReadMe-Media-Files/blob/main/Update%20of%20Collections%20-%20Video%20Preview.gif?raw=true'>

### Technical Details:
<details>
<summary>Click here to read more</summary>
<br>  
  
**1. Custom Collections:**
- Users can create custom collections in addition to the default ones.
- Each new collection is persistently stored using **SwiftData**, ensuring your collections remain accessible even after restarting the app.
- Upon creating a collection, the app:
  - Fetches **10 image results** based on the collection name (query) from the Unsplash API.
  - Saves these images for future use.
  - Assign the first image as the collection’s thumbnail.

**2. Renaming Collections:**
- When renaming a collection, the app:
  1. Updates the collection’s name.
  2. Fetches new images for the updated name via the **Query Image API endpoint**.
  3. Saves the new data without updating the underlying **QueryImage** model.

**3. Data Storage and Models:**

The app employs two distinct models for data storage and logic:
  - **Collection Model:** Handles presentation logic for displaying collections.
  - **QueryImage Model:** Manages business logic, including the collection name, fetched image data, and pagination.

> **Important Behavior:**
- When a collection is deleted, the associated **QueryImage** data is **not** removed.
- This ensures that if you recreate the same collection later, the app retains its pagination state.
  - For example, if you’ve refreshed a collection 100 times, the app will maintain the page number at 10 (since each page contains 10 images).
  - Recreating the collection will resume from the 10th page, avoiding repeated images for a seamless user experience.
- The **only** case where the page number resets to 1 is when the server runs out of images for the given query.

**4. Random Image Selection:**
- Users can select multiple collections at once, enabling the app to fetch images randomly from one collection at a time.
- For a completely context-free experience, users can select the **"RANDOM"** collection. This triggers a call to the Unsplash **Random Image API endpoint**, providing a truly random wallpaper.

</details>
