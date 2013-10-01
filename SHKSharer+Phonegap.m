//
//  SHKSharer+Phonegap.m
//  example
//
//  Created by Erick Camacho Chavarría on 13/08/11.
//  Updated by Abdul Rauf on September 2013
//  ARC Support

#import "SHKSharer+Phonegap.h"

@implementation SHKSharer (SHKSharer_Phonegap)

+ (id)loginToService {
    
    SHKSharer *controller = [[self alloc] init];
    if( ![controller isAuthorized] ) {
        [controller promptAuthorization];
    }
    
  return controller;
}

@end
