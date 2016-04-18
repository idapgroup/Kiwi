//
//  KWProxyBlockTest.m
//  Kiwi
//
//  Created by Oleksa 'trimm' Korin on 4/18/16.
//  Copyright © 2016 Allen Ding. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "KiwiTestConfiguration.h"

#import "KWProxyBlock.h"

#if KW_TESTS_ENABLED

typedef void(^__KWVoidBlock)(void);

@interface KWProxyBlockTest : XCTestCase

@end

@implementation KWProxyBlockTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testItShouldEvaluateWrappedVoidBlockWithoutParams {
    __block BOOL evaluated = NO;
    
    __KWVoidBlock block = ^ {
        evaluated = YES;
    };
    
    KWProxyBlock *wrappedBlock = [KWProxyBlock blockWithBlock:block];
    
    ((__KWVoidBlock)wrappedBlock)();
    
    XCTAssertTrue(evaluated, "wrapped block wasn't evaluated");
}

@end

#endif