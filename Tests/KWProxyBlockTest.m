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

// test values
static const NSUInteger KWUIntValue = 1;
static NSString * const KWStringValue = @"mama";
static const CGRect KWRectValue = (CGRect){{1.0, 1.0}, {1.0, 1.0}};

// test typedefs
typedef void(^__KWVoidBlock)(void);
typedef NSUInteger(^__KWPrimitiveBlock)(void);
typedef id(^__KWObjectBlock)(void);
typedef CGRect(^__KWStretBlock)(void);

@interface KWProxyBlockTest : XCTestCase

@end

@implementation KWProxyBlockTest {
    __block BOOL _evaluated;
}

- (void)setUp {
    [super setUp];
    
    _evaluated = NO;
}

- (void)tearDown {
    XCTAssertTrue(_evaluated, "wrapped block wasn't evaluated");
    
    [super tearDown];
}

- (void)testItShouldEvaluateWrappedVoidBlockWithoutParams {
    __KWVoidBlock block = ^{ _evaluated = YES; };
    
    KWProxyBlock *wrappedBlock = [KWProxyBlock blockWithBlock:block];
    
    ((__KWVoidBlock)wrappedBlock)();
}

- (void)testItShouldEvaluateWrappedPrimitiveBlockWithoutParams {
    __KWPrimitiveBlock block = ^{
        _evaluated = YES;
        
        return KWUIntValue;
    };
    
    KWProxyBlock *wrappedBlock = [KWProxyBlock blockWithBlock:block];
    
    XCTAssertEqual(KWUIntValue, ((__KWPrimitiveBlock)wrappedBlock)(), "wrapped block didn't return a proper value");
}

- (void)testItShouldEvaluateWrappedObjectBlockWithoutParams {
    __KWObjectBlock block = ^{
        _evaluated = YES;
        
        return KWStringValue;
    };
    
    KWProxyBlock *wrappedBlock = [KWProxyBlock blockWithBlock:block];
    
    XCTAssertEqualObjects(KWStringValue, ((__KWObjectBlock)wrappedBlock)(), "wrapped block didn't return a proper value");
}

- (void)testItShouldEvaluateWrappedStretBlock {
    __KWStretBlock block = ^{
        _evaluated = YES;
        
        return KWRectValue;
    };
    
    KWProxyBlock *wrappedBlock = [KWProxyBlock blockWithBlock:block];
    
    XCTAssertTrue(CGRectEqualToRect(KWRectValue, ((__KWStretBlock)wrappedBlock)()), "wrapped block didn't return a proper value");
}

@end

#endif