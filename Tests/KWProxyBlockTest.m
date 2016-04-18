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
typedef void(^__KWVoidBlockMultiparam)(NSUInteger, id, CGRect);

typedef NSUInteger(^__KWPrimitiveBlock)(void);

typedef id(^__KWObjectBlock)(void);
typedef id(^__KWObjectBlockMultiparam)(NSUInteger, id, CGRect);

typedef CGRect(^__KWStretBlock)(void);
typedef CGRect(^__KWStretBlockMultiparam)(NSUInteger, id, CGRect);

@interface KWProxyBlockTest : XCTestCase

- (void)assertCorrectParamsWithUInteger:(NSUInteger)intValue object:(id)object structure:(CGRect)rect;

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

#pragma mark - Test block without parameters

- (void)testItShouldEvaluateWrappedVoidBlock {
    __KWVoidBlock block = ^{ _evaluated = YES; };
    
    KWProxyBlock *wrappedBlock = [KWProxyBlock blockWithBlock:block];
    
    ((__KWVoidBlock)wrappedBlock)();
}

- (void)testItShouldEvaluateWrappedPrimitiveBlock {
    __KWPrimitiveBlock block = ^{
        _evaluated = YES;
        
        return KWUIntValue;
    };
    
    KWProxyBlock *wrappedBlock = [KWProxyBlock blockWithBlock:block];
    
    XCTAssertEqual(KWUIntValue, ((__KWPrimitiveBlock)wrappedBlock)(), "wrapped block didn't return a proper value");
}

- (void)testItShouldEvaluateWrappedObjectBlock {
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
    
    XCTAssertTrue(CGRectEqualToRect(KWRectValue, ((__KWStretBlock)wrappedBlock)()),
                  "wrapped block didn't return a proper value");
}

#pragma mark - Test block with parameters

- (void)testItShouldEvaluateWrappedVoidBlockWithMultipleParameters {
    __KWVoidBlockMultiparam block = ^(NSUInteger intValue, id object, CGRect rect) {
        [self assertCorrectParamsWithUInteger:intValue object:object structure:rect];
    };
    
    KWProxyBlock *wrappedBlock = [KWProxyBlock blockWithBlock:block];
    
    ((__KWVoidBlockMultiparam)wrappedBlock)(KWUIntValue, KWStringValue, KWRectValue);
}

- (void)testItShouldEvaluateWrappedObjectBlockWithMultipleParameters {
    __KWObjectBlockMultiparam block = ^(NSUInteger intValue, id object, CGRect rect) {
        [self assertCorrectParamsWithUInteger:intValue object:object structure:rect];
        
        return KWStringValue;
    };
    
    KWProxyBlock *wrappedBlock = [KWProxyBlock blockWithBlock:block];
    
    id object = ((__KWObjectBlockMultiparam)wrappedBlock)(KWUIntValue, KWStringValue, KWRectValue);
    
    XCTAssertEqualObjects(KWStringValue, object, "wrapped block didn't return a proper value");
}

- (void)testItShouldEvaluateWrappedStretBlockWithMultipleParameters {
    __KWStretBlockMultiparam block = ^(NSUInteger intValue, id object, CGRect rect) {
        [self assertCorrectParamsWithUInteger:intValue object:object structure:rect];
        
        return KWRectValue;
    };
    
    KWProxyBlock *wrappedBlock = [KWProxyBlock blockWithBlock:block];
    
    CGRect rect = ((__KWStretBlockMultiparam)wrappedBlock)(KWUIntValue, KWStringValue, KWRectValue);
    
    XCTAssertTrue(CGRectEqualToRect(KWRectValue, rect), "wrapped block didn't return a proper value");
}


- (void)assertCorrectParamsWithUInteger:(NSUInteger)intValue object:(id)object structure:(CGRect)rect {
    _evaluated = YES;
    
    XCTAssertTrue(CGRectEqualToRect(KWRectValue, rect), "wrapped block didn't return a proper value");
    XCTAssertEqualObjects(KWStringValue, object, "wrapped block didn't return a proper value");
    XCTAssertEqual(KWUIntValue, intValue, "wrapped block didn't return a proper value");
}

@end

#endif