//
//  KWMessageMatcher.h
//  Kiwi
//
//  Created by Oleksa 'trimm' Korin on 4/20/16.
//  Copyright © 2016 Allen Ding. All rights reserved.
//

#import "KWMatcher.h"

@class KWMessageTracker;

@interface KWMessageMatcher : KWMatcher

#pragma mark - Properties

@property (nonatomic, strong) KWMessageTracker *messageTracker;
@property (nonatomic, assign) BOOL willEvaluateMultipleTimes;
@property (nonatomic, assign) BOOL willEvaluateAgainstNegativeExpectation;

@end
