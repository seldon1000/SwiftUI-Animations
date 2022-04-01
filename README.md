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

The next aimation I would like to analyze is a simple swipe. Here, you use swipes to move vertically or horizontally and you move through all the available space, until you find an obstacles (dark dots in our case). The swipe should be quick but consistently animated, using colors, scale effect and overlays, with timed UI changes. Let's take a look.

![Alt Text](https://github.com/seldon1000/SwiftUI_Animations/blob/main/ezgif-1-529eaaadff.gif)

This animation comes with a lot of headackes. Let's see why. First things first, we have a grid State variable, of type Grid. Grid is a custom class I created that manages the whole "gameplay" and grid you play in. Let's see what it actually does. Below you can take a look to its members and initializer. The ```currentDot``` variable contain the coordinates of the current dot inside the grid and is marked ```@Published``` meaning that everytime it gets updated, the UI will refresh too, according to the changes. ```dotsToWin``` counts the dots left to be colored. ```dots``` holds the whole grid of dots, our game environment. ```startDot``` holds the coordinates of the dot where you start playing. ```rows``` and ```cols``` hold the dimensions of the grid. The initialiser will take a Level object, which holds information about the level you are going to play. There's only one level inside this prototype and I won't explain how it works here, cause it's boring.

```swift
@Published var currentDot: (Int, Int)
var dotsToWin: Int
var dots: [[Dot]]
    
private let startDot: (Int, Int)
let rows: Int
let cols: Int
    
init(level: Level) {
    currentDot = level.startDot
        
    dotsToWin = level.rows * level.cols - level.obstacles.count - 1
    dots = []
        
    startDot = level.startDot
    rows = level.rows
    cols = level.cols
        
    for i in 0..<rows {
        dots.append([])
            
       for j in 0..<cols {
            dots[i].append(Dot(isObstacle: level.obstacles.contains(where: { k in k == (i, j) }), coordinates: (i, j)))
        }
    }
        
    dots[currentDot.0][currentDot.1].isColored = true
}
```

Let's move on to the headackes part: the gesture management. Since a swipe gesture modifies a lot of things inside the grid object we are using, its management is held inside the grid itself. The function is ```dragGesture(translation: CGSize) -> Bool```. Below you will find an example. The j variable is used for two reasons: it lets us better delay animations when we swipe and it lets us know if we actually moved from a position inside the grid to another. The function takes a ```translation``` object as input parameter, which holds the amount of space dragged during the swipe. Inside the if statement, we check if the user did a left to right swipe. If so, we start iterating throughout every dot present in that specific direction. The iteration stops when we encounter an edge, an obstacle or when there are no other dots to be colored. If there is a dot we can move to, we color that dot with an easeInOut animation, with a duration of j. Then, we increment j, in order to provide a gradual animation for the whole swipe length. This was for the left to right swipe, but it's the same for the other directions.

```swift
var j: Double = 0.3
        
if translation.width > 90 {
    var i = currentDot.1 + 1
            
    while i < cols && !dots[currentDot.0][i].isObstacle && dotsToWin > 0 {
        if !dots[currentDot.0][i].isColored {
            dotsToWin -= 1
        }
                
        withAnimation(.easeInOut(duration: j)) {
            currentDot.1 = i
            dots[currentDot.0][i].isColored = true
        }
                
        i += 1
        j *= 1.06
    }
}
```

We've talked about the internal stuff, but now the UI. Below there's the DotComponent file source code. We have the grid again, the one declared inside the GameView file, then there are a ```isObstalce``` State variable, which tells the UI if the dot is obstacle or not, a ```diameter``` State var, which defines the dimensions of the dot accordingly to the device screen, a ```dot``` variable of type Dot, which holds information about the dot and lastly a ```win``` Binding variable, which we will analyze later. So, we fill the dot with the right color, keeping in mind that obstacles should be dark: ```.fill(Color(isObstacle ? dot.obstacleColor : dot.color))```. We set the frame and then apply an overlay: ```.overlay(Circle().strokeBorder(.black.opacity(0.35), lineWidth: diameter * (dot.coordinates == grid.currentDot && grid.dotsToWin > 0 ? 0.35 : 0.0)))```, this means that we put a darker stroke border on top of the dot, but only if its the current one, to differentiate it. This is also important for the swipe animation. Then, we apply a scale effect: ```.scaleEffect(dot.coordinates == grid.currentDot && grid.dotsToWin > 0 ? 1.2 : (dot.isColored ? 1.0 : 0.0))```, meaning that if the dot is the current one, it will be larger than the others, otherwise, if the dot is already colored it will fill its frame or else it will stay scaled to a 0 factor (it won't even appear). That means that as soon as the grid colors the dot, it will enlarge itself from a 0 scal factor to 1. Anything else inside the file will be discussed later.

```swift
@EnvironmentObject var grid: Grid
    
@State var isObstacle: Bool = false
@State var diameter: CGFloat = 64
    
@Binding var win: Bool
    
var dot: Dot
    
var body: some View {
    Circle()
        .fill(Color(isObstacle ? dot.obstacleColor : dot.color))
        .frame(width: diameter, height: diameter)
        .overlay(Circle().strokeBorder(.black.opacity(0.35), lineWidth: diameter * (dot.coordinates == grid.currentDot && grid.dotsToWin > 0 ? 0.35 : 0.0)))
        .scaleEffect(dot.coordinates == grid.currentDot && grid.dotsToWin > 0 ? 1.2 : (dot.isColored ? 1.0 : 0.0))
        .padding(6)
        .onAppear {
            diameter = UIScreen.main.bounds.width / CGFloat(grid.cols) - 17
            isObstacle = dot.isObstacle
        }
        .onChange(of: win) { newValue in
            if dot.isObstacle && newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 0.5...1.5)) {
                    withAnimation(.easeInOut) {
                        isObstacle = false
                    }
                }
            }
        }
```

Lastly, let's take a look to the GameView file source code, which displays the grid of DotComponent objects. Let's scrap anything we don't care about for now and focus of the gesture management. Using the ```.gesture``` modifier, we listen for drag gestures, and we pass their translation value to the grid's ```dragGesture``` function.

```swift
VStack(spacing: 0) {
    ForEach(0..<grid.rows, id: \.self) { i in
        HStack(spacing: 0) {
            ForEach(grid.dots[i]) { dot in
                DotComponent(win: $win, dot: dot)
            }
        }
    }
}
.environmentObject(grid)
.contentShape(Rectangle())
.gesture(DragGesture().onEnded { value in
    if !win && !showMenu {
        if grid.dragGesture(translation: value.translation) {
            win.toggle()
                        
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.easeInOut) {
                     showMenu = false
                     isPlaying = false
                }
            }
        }
    }
})
```

I told ya there were a lot of headackes here. But if you've come this far why stop now? Let's continue, cause the best part is yet to come.

## Refresh that grid

The prototype we are discussing hold just one game level, which is so simple even a one-eyed lizard could solve it. However, you could be a completely blind lizard, so let's talk about the level refresh feature (and about its animation, of course).

![Alt Text](https://github.com/seldon1000/SwiftUI_Animations/blob/main/ezgif-1-9e57cf8c41.gif)

Cool, but how? Nothing special actually, in fact we will use the same components we discussed earlier. Below, there's a longPressGesture we scrapped earlier for the GameView file. This opens the GameView menu, exactly as we've already seen with the first animation, using scale effects and size.

```swift
.onLongPressGesture {
    if !win {
        withAnimation(.easeInOut) {
             showMenu = true
             scale = 0.6
        }
    }
}
```

When the menu is shown, there are just two buttons: one for exiting the level, and one for refreshing it. Below, you'll find the MenuView called by GameView. We set the menu type to ```.game``` and this time we pass a closure. The closure holds the action to execute when refreshing the level. Here, we just call the ```refreshGrid``` method of the grid object, then, when the refresh is done internally, we hide the menu with an animation. This animation is delayed by 0.3 seconds using ```DispatchQueue```. You could ask yourself, why this and not a simple delay applied on the easeInOut animation, like previously? Well, we will discuss it later, don't worry.

```swift
MenuView(showMenu: $showMenu, isPlaying: $isPlaying, menuType: .game) {
    if !win {
        grid.resetGrid()
                        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeInOut) {
                showMenu = false
                scale = 1.0
            }
        }
    }
}
```

And now? Let's analyze the ```resetGrid``` function. We reset the ```dotsToWin``` counter. Then, we iterate throughout all the dots inside our grid. If the dot is not an obstacle, and neither the starting dot, we decolor it with an animation. As we've seen previously, a coloring/decoloring a dot, makes it scale down to 0 or to 1 accordingly.

```swift
func resetGrid() {
    dotsToWin = 0
        
    for i in 0..<dots.count {
        for dot in dots[i] {
            if !dot.isObstacle && dot.coordinates != startDot {
                withAnimation(.easeInOut) {
                    currentDot = startDot
                    dot.isColored = false
                }
                    
                dotsToWin += 1
            }
        }
    }
}
```

Aaaaaand that's it. Kinda simple. Now, one last animation.

## Timed coolness



![Alt Text](https://github.com/seldon1000/SwiftUI_Animations/blob/main/ezgif-1-5eac10cc89.gif)



*** work in progress ***
