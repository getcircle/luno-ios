//
//  ABTestUtils.m
//  Circle
//
//  Created by Ravi Rani on 3/31/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

#import "ABTestUtils.h"
#import "Mixpanel/MPTweakInline.h"

@implementation ABTestUtils

+ (BOOL)shouldShowInterests {

    if (MPTweakValue(@"Show Interests", YES)) {
        return YES;
    } else {
        return NO;
    }
}

@end
