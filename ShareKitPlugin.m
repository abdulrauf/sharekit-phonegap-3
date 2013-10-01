//
//  ShareKitPlugin.m
//
//  Created by Erick Camacho on 28/07/11.
//  MIT Licensed
//  Phonegap 3.0 support by Mohamed Fasil

#import "ShareKitPlugin.h"
#import "SHKActionSheet.h"
#import "SHKTwitter.h"
#import "SHKFacebook.h"
#import "SHKMail.h"
#import "SHKTextMessage.h"


@interface ShareKitPlugin ()

- (void)IsLoggedToService:(BOOL)isLogged callback:(NSString *) callback;

@end

@implementation ShareKitPlugin


- (void)share:(CDVInvokedUrlCommand*)command {
  
  NSString *message = [command.arguments objectAtIndex:0];
  SHKItem *item;
  
  if ([command.arguments count] == 2) {
    NSURL *itemUrl = [NSURL URLWithString:[command.arguments objectAtIndex:1]];
    item = [SHKItem URL:itemUrl title:message contentType:SHKURLContentTypeWebpage];
  } else {
    item = [SHKItem text:message];
  }
  
  SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
  [SHK setRootViewController:self.viewController];
  
  [actionSheet showInView:self.viewController.view];
}

- (void)isLoggedToTwitter:(CDVInvokedUrlCommand*)command {
  NSString *callback = [command.arguments objectAtIndex:0];
  [self IsLoggedToService:[SHKTwitter isServiceAuthorized] callback:callback];
}

- (void)isLoggedToFacebook:(CDVInvokedUrlCommand*)command {
  
  NSString *callback = [command.arguments objectAtIndex:0];
  [self IsLoggedToService:[SHKFacebook isServiceAuthorized] callback:callback];
}

- (void)IsLoggedToService:(BOOL)isLogged callback:(NSString *) callback {
  
  CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsInt: isLogged ];
  [self writeJavascript:[pluginResult toSuccessCallbackString:callback]];
}


- (void)logoutFromTwitter:(CDVInvokedUrlCommand*)command {
  [SHKTwitter logout];
}

- (void)logoutFromFacebook:(CDVInvokedUrlCommand*)command {
  
  [SHKFacebook logout];
}

- (void)facebookConnect:(CDVInvokedUrlCommand*)command {
  if (![SHKFacebook isServiceAuthorized]) {
    [SHK setRootViewController:self.viewController];
    [SHKFacebook loginToService];
  }
}

- (void)shareToFacebook:(CDVInvokedUrlCommand*)command {
  
  [SHK setRootViewController:self.viewController];
  
  SHKItem *item;
  
  NSString *message = [command.arguments objectAtIndex:0];
  if ([command.arguments objectAtIndex:2]==NULL) {
    NSURL *itemUrl = [NSURL URLWithString:[command.arguments objectAtIndex:1]];
    item = [SHKItem URL:itemUrl title:message contentType:SHKURLContentTypeWebpage];
  } else {
    item = [SHKItem text:message];
  }
  
  [SHKFacebook shareItem:item];
  
}

- (void)shareToTwitter:(CDVInvokedUrlCommand*)command {
  [SHK setRootViewController:self.viewController];
  
  SHKItem *item;
  
  NSString *message = [command.arguments objectAtIndex:0];
  if ([command.arguments objectAtIndex:2]==NULL) {
    NSURL *itemUrl = [NSURL URLWithString:[command.arguments objectAtIndex:1]];
    item = [SHKItem URL:itemUrl title:message contentType:SHKURLContentTypeWebpage];
  } else {
    item = [SHKItem text:message];
  }
  
  [SHKTwitter shareItem:item];
  
}

- (void)shareToMail:(CDVInvokedUrlCommand*)command {
  [SHK setRootViewController:self.viewController];
  
  SHKItem *item;
  
  NSString *subject = [command.arguments objectAtIndex:0];
  NSString *body = [command.arguments objectAtIndex:1];
  
  item = [SHKItem text:body];
  item.title = subject;
  
  [SHKMail shareItem:item];
  
}


- (void)shareToSMS:(CDVInvokedUrlCommand*)command {
  [SHK setRootViewController:self.viewController];
  
  SHKItem *item;
  
  NSString *message = [command.arguments objectAtIndex:0];
  if ([command.arguments count] >= 2 && [command.arguments objectAtIndex:1]==NULL) {
    NSURL *itemUrl = [NSURL URLWithString:[command.arguments objectAtIndex:1]];
    item = [SHKItem text:message];
    item.URL = itemUrl;
  } else {
    item = [SHKItem text:message];
  }
  
  [SHKTextMessage shareItem:item];
  
}




#pragma mark ABPersonViewControllerDelegate methods
// Does not allow users to perform default actions such as dialing a phone number, when they select a contact property.
- (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person
                    property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifierForValue
{
  NSLog(@"testing %@",person);
  return YES;
}

#pragma mark ABPeoplePickerNavigationControllerDelegate methods
// Displays the information of a selected person
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
  return YES;
}


// Does not allow users to perform default actions such as dialing a phone number, when they select a person property.
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
  return YES;
}


// Dismisses the people picker and shows the application when users tap Cancel.
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker;
{
  //[self dismissModalViewControllerAnimated:YES];
  [[SHK currentHelper] hideCurrentViewControllerAnimated:YES];
}

#pragma mark Show all contacts
// Called when users tap "Display Picker" in the application. Displays a list of contacts and allows users to select a contact from that list.
// The application only shows the phone, email, and birthdate information of the selected contact.
-(void)showPeoplePickerController
{
  NSLog(@"showPeoplePickerController ");
  ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
  picker.peoplePickerDelegate = self;
  // Display only a person's phone, email, and birthdate
  NSArray *displayedItems = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonPhoneProperty], nil];
  
  picker.displayedProperties = displayedItems;
  // Show the picker
  [[SHK currentHelper] showViewController:picker];
  //[self presentModalViewController:picker animated:YES];
  //[picker release];
}

- (void)shareToCall:(CDVInvokedUrlCommand*)command {
  NSLog(@"shareToCall");
  [self showPeoplePickerController];
}


@end