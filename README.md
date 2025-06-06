# idealista iOS Challenge

> **🆕 UPDATED!** This fork has been recently updated to support the new **dynamic property details API**. The app now fetches specific property details using the property ID (`detail_[id].json`) instead of always receiving the same static response. Additional API fields and data structure improvements have also been implemented to match the updated specifications. **Offline fallback functionality** has also been enhanced to work seamlessly with the new API structure, and **accessibility tags** have been added to images for improved accessibility support.

The idealista iOS team is on the lookout for a new teammate! We’re on a mission to find someone who’s ready to dive into the exciting (and sometimes wild) world of iOS development. From building cool new features to squashing bugs, crafting pixel-perfect UIs, and making sure everything runs smoothly and securely — we’ve got plenty to keep you on your toes.

Think you’re up for the challenge? We could really use your skills to create the next generation of awesome features that will take our app to new heights. Whether it’s making sure our users have a seamless experience or pushing the limits of performance, we need someone who’s ready to jump in and make a real impact.

Here at idealista, we’re all about clean, maintainable code and solid testable components. If you love turning great ideas into reality, this might just be the perfect challenge for you!

&nbsp;

### 🚀 Getting Started
1. Read the **minimum requirements**.
2. Fork this repository.
3. Start coding and have fun!

&nbsp;

### 📱 Task
Build a small app that allows users to browse through a list of ads and view ad details on a separate screen.

&nbsp;

### 🌐 API
- List: [https://idealista.github.io/ios-challenge/list.json](https://idealista.github.io/ios-challenge/list.json)  
- Detail: [https://idealista.github.io/ios-challenge/detail.json](https://idealista.github.io/ios-challenge/detail.json) *Please note: the response is always the same*.

&nbsp;

### ✅ Minimum Requirements
- ✅ ~~The app must run on **Xcode 16.0** and be compatible with **iOS 16** through **iOS 18**.~~
- ✅ ~~The app should include at least **two screens**:~~
  - ~~A **listing screen** displaying a collection of ads.~~
  - ~~A **detail screen** for viewing individual ad information.~~
- ✅ ~~The code must be written in **Swift** and use the **UIKit** framework.~~
- ✅ ~~Implement functionality to allow users to **favorite ads**.~~
  - ~~If an ad is favorited, display the **date** it was favorited.~~
- ✅ ~~Use the provided **API endpoints** to fetch and display ad data.~~
- ✅ ~~Only use **third-party libraries** if absolutely necessary. We value clean and lightweight implementations.~~

&nbsp;

### 🎁 Optional Bonus Tasks (For extra kudos!)
1. ✅ ~~Implement **pull-to-refresh** functionality on the listing screen.~~
2. ✅ ~~**Localize** the app into at least one additional language.~~
3. ✅ ~~Add **tests** for key components of the app.~~
4. ✅ ~~Add support for **Dark Mode** to ensure the app looks great in all environments.~~
5. ✅ ~~Incorporate some **SwiftUI** code alongside UIKit.~~
6. ✅ ~~Implement **persistent storage** using Core Data, SwiftData, Realm, or any other suitable solution.~~
7. ⚠️ Add **iPad support** with a responsive layout. *(Partially implemented - adapted but not iPad-exclusive)*
8. ✅ ~~Show the location of the ad using a **map** view, indicating its position.~~
9. ✅ ~~Feel free to go beyond the requirements and **improve the app** in any way you think is best — we love creativity!~~

&nbsp;

### 🎉 Once You’ve Finished
1. Email us at [tlfernandez@idealista.com](mailto:tlfernandez@idealista.com) with your repository link you'd like our iOS team to review, or send the project folder (including the `.git` directory).
2. Celebrate with a beer after a well done job! 🍺

&nbsp;

---

&nbsp;

### 🛠️ Implementation Details

I've completed the iOS challenge with a focus on clean architecture and demonstrating both UIKit and SwiftUI capabilities while maintaining compatibility with iOS 16+.

#### 📲 App Structure

**Splash Screen**
- Loads property data in the background while providing a smooth user experience
- Built with Interface Builder (.xib)
- Includes a fallback mechanism to load a sample JSON if the API or internet connection fails
- Informs users whether content is from API or local fallback

**Property List View**
- Created using a .xib file to add the UITableView and then configured in the ViewController
- Features **pull-to-refresh** functionality for updating the property list
- Incorporates **SwiftUI table cells** to demonstrate hybrid UIKit/SwiftUI integration (iOS 16+)
- Implements the **favorites functionality** with toggle and date display
- Shows a **non-interactive map** at position -1 in the gallery, loaded on-demand for performance

**Property Details View**
- Built entirely programmatically to showcase different approaches
- Fetches detail data on view entry with JSON fallback for API or connection failures
- Features an **interactive map** at the bottom of the view for property location

#### ⚙️ Architecture & Technical Details

- **MVVM pattern** throughout all views for separation of concerns
- **Coordinator pattern** for clean navigation management
- Modern **async/await** for asynchronous operations like API calls
- Centralized **NetworkService** for all API communication
- **Core Data persistence** for storing user favorites
- **Repository pattern** for data management abstraction
- Multiple **extensions and helpers** for code reusability
- Simple **image caching** system for detail view images

#### ✨ User Experience Enhancements

- **Localization** support for English and Spanish (easily expandable to more languages)
- Full **Dark Mode** support
- Custom colors that meet **accessibility requirements** and provide app coherence
- Support for **Dynamic Type** font sizing from Accessibility settings
- **MapKit integration** for maps without external dependencies
- Using UIViewRepresentable for SwiftUI compatibility (iOS 16 target)
- **iPad compatibility** with responsive layouts (not a dedicated iPad version)

#### 🧪 Testing

- Added multiple **Unit tests** following the Given-When-Then pattern
- Added **UI tests** covering main functionality flows
