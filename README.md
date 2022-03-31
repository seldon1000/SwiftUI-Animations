# SwiftUI_Animations
This repository was created as Frontend path Artifact deliverable, for the NCX - Daiquiri challenge @ Apple Developer Academy | Naples. The goal of the repository is to showcase the potential of SwiftUI framework when implementing modern and complex animations. The project will be deeply analyzed, offering a complete explanation of what was done to implement Animation&Motion inside the prototype application.

Some key aspects of the project:
- SwiftUI
- State
- Explicit animations
- Scale, opacity, color, etc transitions
- Concurrency


## Introduction
Animation&Motion, probably one of the most important aspects of UX design. In order to provide a good UX, an application should include nice, smooth and consistent animations. Animations let the user understand what's going on inside the app: a loading process, a swipe, a tap on the screen, everything should come with a coherent visual feedback.

![Alt Text](https://github.com/seldon1000/SwiftUI_Animations/blob/main/ezgif-2-a1c545c1e7.gif)                              ![Alt Text](https://github.com/seldon1000/SwiftUI_Animations/blob/main/ezgif-2-72a74f9641.gif)

## Scale&Size
The first animation we're going to analyze includes scale and size changes in order to show a little menu with a nice and smooth transition. Let's take a quick look at the animation, then we'll analyze the code.

![Alt Text](https://github.com/seldon1000/SwiftUI_Animations/blob/main/ezgif-2-78cdc7af88.gif)

What's needed to implement this animation? Let's take a close look at the code and start with the boring part. This is the source code from the SwiftUI_AnimationsApp file, the starting point of the prototype. Nothing special here.

```swift
import SwiftUI

@main
struct SwiftUI_AnimationsApp: App {
    var body: some Scene {
        WindowGroup {
            Start()
                .preferredColorScheme(.light)
                .statusBar(hidden: true)
        }
    }
}
```

Let's move on to the Start file source code. Okay, now what do we have here? We have a showMenu State variable, which will indicate when to show the menu. The UI is composed by a VStack, which aligns its content vertically. Inside the VStack, we have a MainView and, optionally based on the showMenu value, a MenuView.

```swift
import SwiftUI

struct Start: View {
    @State var showMenu: Bool = false
    
    var body: some View {
        VStack(spacing: 48) {
            MainView(showMenu: $showMenu)
            if showMenu {
                MenuView(showMenu: $showMenu, menuType: .artwork)
            }
        }
        .ignoresSafeArea()
    }
}
```

Now, let's dig deeper. Below, we have the MainView file source code. I'll spoil that the MainView can present the GameView, through the isPlaying State variable, but for now let's skip that. We have a showMenu Binding variable, bound to the one declared previously inside the Start file. The UI is composed by a ZStack, which will stack its components on top of each other. In fact, inside the ZStack, we have a pink color and, optionally based on the isPlaying variable, the GameView. The ZStack is modified with a frame ```.frame(width: UIScreen.main.bounds.width * (showMenu ? 0.5 : 1.0), height: UIScreen.main.bounds.height * (showMenu ? 0.5 : 1.0))```. What does that mean? The ZStack will occupy the whole screen when the menu is hidden, otherwise it will scale down proportionally to a 0.5 factor (half screen). But how does that happen? We have the ```onTapGesture``` and the ```onLongPressGesture``` modifiers, which are triggered respectively when the user taps or long presses on the ZStack. When the user long presses on the ZStack, we have a call to the ```withAnimation()``` function. As also stated by the Apple's SwiftUI documentation, the ```withAnimation()``` function immediately executes its closure's content, applying the changes, and updates the UI components affected by those changes with an animation, which will follow the curve/easing we pass as input parameter. ```withAnimation(.easeInOut)``` in our case changes the showMenu value after a long press gesture by user. The change will be immediate internally, but the UI will update with an animation which will follow the easeInOut timing function, which provides a gradual starting and ending transition. So, when the value of showMenu is true, the MenuView will start appearing on the screen, while at the same time the MainView will resize itself to make space for the menu. The ```onTapGesture``` will revert the showMenu value in order to close the menu, with exactly the same animation we've seen for the opening, but reversed. ```withAnimation()``` implements what is called "explicit animation", meaning that we explicitly tell SwiftUI which animation we want to use and for which internal changes (like with the showMenu variable changes).

```swift
import SwiftUI

struct MainView: View {
    @State var isPlaying: Bool = false
    
    @Binding var showMenu: Bool
    
    var body: some View {
        ZStack {
            Color.pink
                .opacity(isPlaying ? 0.0 : 0.2)
            if isPlaying {
                GameView(grid: Grid(level: level), isPlaying: $isPlaying)
                    .zIndex(100)
            }
        }
        .frame(width: UIScreen.main.bounds.width * (showMenu ? 0.5 : 1.0), height: UIScreen.main.bounds.height * (showMenu ? 0.5 : 1.0))
        .onTapGesture {
            if showMenu {
                withAnimation(.easeInOut) {
                    showMenu = false
                }
            } else {
                withAnimation(.easeInOut) {
                    isPlaying = true
                }
            }
        }
        .onLongPressGesture {
            withAnimation(.easeInOut) {
                showMenu.toggle()
            }
        }
    }
}
```

Pretty cool ah? Let's move on to the next animation.


## Overlays&Headackes
*** work in progress ***
