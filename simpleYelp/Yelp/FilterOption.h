//
//  FilterOption.h
//  Yelp
//
//  Created by Lin Zhang on 6/23/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilterOption : NSObject

@property (strong, nonatomic) NSString *categoryList;
@property (strong, nonatomic) NSMutableArray *categories;
@property (strong, nonatomic) NSString *distance;
@property (strong, nonatomic) NSString *priceRange;
@property (nonatomic) BOOL isOpenNow;
@property (nonatomic) BOOL isDealAvailable;
@property (strong, nonatomic) NSString *sortedBy;

@end
