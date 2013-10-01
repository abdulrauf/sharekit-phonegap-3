#ShareKit plugin for Phonegap 

By Erick Camacho
Updated for Cordova 1.7/Sharekit 2.0 by Kerri Shotts
Updated by Abdul Rauf for phonegap 3.0 full support and ARC


* Install sharekit 2.x using https://github.com/ShareKit/ShareKit/wiki/Installing-sharekit

* * Make sure you follow *all* the steps, all the way through step 7. This will ensure you have FaceBook SSO working properly.

* * Also make sure to configure the services with their appropriate API keys. This step is not described particularly well on the wiki. It boils down to creating a new Objective C class in your project that is based on DefaultSHKConfigurator, copying & pasting from DefaultSHKConfigurator, and filling in your API keys. (See the example configuration files under example-config directory.)

* Because ShareKit utilizes JSONKit, you will receive errors when building your app. You *must*:

* * Update the subproject's User Header Search Paths for the Sharekit SubProject to "/Users/Shared/Cordova/Frameworks/Cordova.framework/**"

* * Rename (or delete) Sharekit's JSONKit.h/.m. If you rename them, make sure not to have an ending in .h or .m.

### Other potential issues you may (or may not) have:

* Instant crash due to missing symbol _NSURLIsExcludedFromBackupKey on IOS < 5.1

* * Current fix: comment lines 804-814 out in SHK.m. If anyone has a better fix, I'd love to hear it.

* Crashes when trying to share from the action sheet OR when cancelling an action.

* * In hideCurrentViewControllerAnimated, comment out the completion block and change the method to dismissModalViewControllerAnimated. It should look like this:

    [[currentView presentingViewController] dismissModalViewControllerAnimated:animated ];
    /* completion:^{                                                                           
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
           [[NSNotificationCenter defaultCenter] postNotificationName:SHKHideCurrentViewFinishedNotification object:nil];
         }];
      }];*/

* * Crash when sharing with Twitter on iOS 5 - the simple fix is to force the old Twitter method used in iOS 4 and below in your configuration file. 

## Adding the Plugin to the Project

1. phonegap local plugin add https://github.com/abdulrauf/sharekit-phonegap-3.git


## Using the plugin


Add the js file to your html - just make sure put this line after including phonegap js file

<script type="text/javascript" src="ShareKitPlugin.js"></script>

The plugin registers itself in the variable window.plugins.shareKit. It exposes the following methods:

1. `share( message, url )` Displays the ShareKit Form to share the given message and URL on a social network.

2. `isLoggedToTwitter( callback )` Returns wheter the user is logged in to twitter or no. Invokes the callback with an int argument :

	window.plugins.shareKit.isLoggedToTwitter( function( isLogged ) {
		if( isLogged ) {
			//do something
		} else {
			//do something
		}
	});

3. `isLoggedToFacebook( callback )` Returns wheter the user is logged in to Facebook or no. Invokes the callback with an int argument.

4. `logoutFromTwitter( )` Logouts the user from Twitter (By default, ShareKit keeps the user logged in. So if you want to log in with a different user
you must logout the current one first );

5. `logoutFromFacebook( )` Logouts the user from Facebook (By default, ShareKit keeps the user logged in. So if you want to log in with a different user
you must logout the current one first );

6. `facebookConnect( )` Shows the Facebook Login form, if the user is not logged in. Convenient method for login to Facebook without showing the post in the wall form.

7. `shareToFacebook(message, url )` Shows only the post in the wall form of Facebook if the user is logged in. 

8. `shareToTwitter(message, url)` Shares an item specifically with Twitter, will automatically shorten the URL

9. `shareToMail(subject, body)` Opens up the iOS mail dialog with pre-filled subject and body

10. `shareToSMS(message, url)` Opens up the iOS sms application dialog with pre-filled message and url

11. `shareToCall()` Opens up the iOS call app
## Limitations

Currently the plugin can only share messages and URLs. In the future I will add functionality to share images as well.

## License 


The MIT License

Copyright (c) 2011 Erick Camacho

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.


