//
//  KWAbstractMessagePattern.h
//  Kiwi
//
//  Created by Oleksa 'trimm' Korin on 4/26/16.
//  Copyright © 2016 Allen Ding. All rights reserved.
//

#import "KiwiConfiguration.h"

@interface KWAbstractMessagePattern : NSObject

#pragma mark - Initializing

// this method should be overloaded by subclasses
+ (id)messagePatternFromInvocation:(NSInvocation *)anInvocation;

#pragma mark - Properties

@property (nonatomic, readonly) NSArray *argumentFilters;

// this method should be overloaded by subclasses
@property (nonatomic, readonly) NSUInteger *argumentCount;

#pragma mark - Matching Invocations

- (BOOL)matchesInvocation:(NSInvocation *)anInvocation;

#pragma mark - Comparing Message Patterns

// this method should be overloaded by subclasses
- (BOOL)isEqualToMessagePattern:(id)aMessagePattern;

#pragma mark - Retrieving String Representations

// this method should be overloaded by subclasses
- (NSString *)stringValue;

@end

// methods in this category are used for inheritance and should not be called directly
@interface KWAbstractMessagePattern (KWAbstractMessagePatternPrivate)

#pragma mark - Initializing

- (id)initWithArgumentFilters:(NSArray *)anArray;
- (id)initWithFirstArgumentFilter:(id)firstArgumentFilter
                     argumentList:(va_list)argumentList
                    argumentCount:(NSUInteger)count;

+ (id)messagePatternWithArgumentFilters:(NSArray *)anArray;
+ (id)messagePatternWithFirstArgumentFilter:(id)firstArgumentFilter
                               argumentList:(va_list)argumentList
                              argumentCount:(NSUInteger)count;

@end

