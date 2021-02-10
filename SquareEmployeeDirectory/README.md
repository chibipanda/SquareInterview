#  README

1. **Build Tools & Versions Used.** 
This was written with XCode 12.3 and 12.4 (my XCode updated itself while I was doing this project). I tested this only with simulators, largely running on iOS 14.4 (I only run this on iPhone 12 Pro). 
2. **Your Focus Areas.** 
Getting the project working, and trying to make sure that things are testable. Per the coverage, I've got about 85% tested, which is not bad. 
3. **Copied-in code or copied-in dependencies.** 
I googled up how to ignore invalid employee JSON. I saw the code from stack overflow, tho I didn't copy/paste the code exactly. I took the idea, tho. I also looked at how to generate UIImage from words. I include the source where I found the original code in the relevant sections. 
4. **Tablet / phone focus.** 
I tried this mostly on iPhone, but should work on tablet the same, I think. 
5. **How long you spent on the project.** 
Probably about 4 hours? 
6. **Anything else you want us to know.** 
I write down why I do some things in the comments in the code. Hopefully these are alright. I decided against CoreData, Realm, or TMCache since the image caching being persisted to disk can be achieved much more simply by using a dictionary and an NSKeyedArchiver/NSKeyedUnarchiver. The employee json is not persisted anywhere, but getting downloaded when the app finish launching. 
I put in a skeleton "detail" page, tho that page is really not that great looking at all, seeing that that was not required, I figured, it might make some sense to show the employee's email and larger picture, at least. 
