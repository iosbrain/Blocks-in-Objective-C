# Blocks in Objective-C
A project (Xcode 8.2.1) demonstrating blocks/closures in iOS with Objective-C. Blocks/closures allow you to create chunks of almost any type of code that can be called almost anywhere, anytime (like in the future). They are self-contained but know about variables around them (in the same scope). They can be assigned to properties, variables, and/or constants — and passed as parameters to functions/methods. Blocks/closures can access variables and constants from the surrounding environment in which they were defined. Even if the variables and constants from their original surrounding environment go out of scope, blocks/closures can still access those variables and constants. Perhaps most importantly, blocks/closures are great for communicating between objects, especially as in the case of reporting completion of an operation (i.e., callbacks). You can define a block/closure one place, but not have it execute until (much) later. So you don’t have to incur the overhead of adopting protocols and encoding calls to delegate methods. Protocols/delegates have their place, but you don’t have to write all the code to implement and adopt them when you just need a simple callback.

## Xcode 8.2.1 project settings
**To get this project running on the Simulator or a physical device (iPhone, iPad)**, go to the following locations in Xcode and make the suggested changes:

1. Project Navigator -> [Project Name] -> Targets List -> TARGETS -> [Target Name] -> General -> Signing
- [ ] Tick the "Automatically manage signing" box
- [ ] Select a valid name from the "Team" dropdown
  
2. Project Navigator -> [Project Name] -> Targets List -> TARGETS -> [Target Name] -> General -> Identity
- [ ] Change the "com.yourDomainNameHere" portion of the value in the "Bundle Identifier" text field to your real reverse domain name (i.e., "com.yourRealDomainName.Project-Name").
