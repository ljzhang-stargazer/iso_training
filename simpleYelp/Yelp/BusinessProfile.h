//
//  BusinessProfile.h
//  Yelp
//
//  Created by Lin Zhang on 6/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BusinessProfile : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *distance;
@property (strong, nonatomic) NSString *reviewNum;
@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) NSURL *profileImage;
@property (strong, nonatomic) NSURL *ratingImage;

- (id) initWithBusinessProfileData: (NSDictionary *) businessData;

@end
