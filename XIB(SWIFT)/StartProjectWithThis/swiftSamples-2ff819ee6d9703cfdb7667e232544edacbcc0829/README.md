Apple Samples Ported to Swift
============

Like a lot of other developers I'm trying to familiarize myself with Swift.

Towards that goal I'm porting some of the [Apple sample code](https://developer.apple.com/library/ios/navigation/#section=Resource%20Types&topic=Sample%20Code) to Swift.

In general, I'm doing the following to each project before I start changing the code:

* Convert to Objective-C ARC
* Convert to Modern Objective-C Syntax
* Update Deployment Targets to iOS 8.0
* Validate the project settings and let Xcode change them as it wants
* Add Default-568h@2x.png to allow for running on an iPhone 5

Then I start diving into it one file at a time.

I'll add notes and comments as I go along and discover stuff of note.

HelloWorld
----

A straight port without any major changes

PrintPhoto
----
A little trickier than the first one. For some reason it kept crashing whenever I tried to hit one of the buttons. I'm not entirely sure if it was something I did wrong or just somthing in the framework that is not quite there yet.

### Notes

* For some reason I was not able to define a closure as a variable. When I did I was getting compilation errors in PrintPhotoViewController when trying to present the UIPrintInteractionController. I got passed this by using trailing closures
* Converted the app to storyboards as I wanted to do something simple with storyboards before I start diving into more difficult stuff.