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

+ (id)messagePatternFromInvocation:(NSInvocation *)anInvocation;

// this method should be overloaded by subclasses
- (id)initWithInvocation:(NSInvocation *)anInvocation;

#pragma mark - Properties

@property (nonatomic, readonly) NSArray *argumentFilters;

#pragma mark - Matching Invocations

- (BOOL)matchesInvocation:(NSInvocation *)anInvocation;

#pragma mark - Comparing Message Patterns

- (BOOL)isEqualToMessagePattern:(id)aMessagePattern;

#pragma mark - Retrieving String Representations

// this method should be overloaded by subclasses
- (NSString *)stringValue;

@end

// methods in this category are used for inheritance and should not be called directly
@interface KWAbstractMessagePattern (KWAbstractMessagePatternPrivate)

#pragma mark - Initializing

- (id)initWithArgumentFilters:(NSArray *)anArray;

#pragma mark - Argument Filters Creation

- (NSArray *)argumentFiltersWithInvocation:(NSInvocation *)invocation;
- (NSArray *)argumentFiltersWithFirstArgumentFilter:(id)firstArgumentFilter
                                       argumentList:(va_list)argumentList
                                      argumentCount:(NSUInteger)count;

#pragma mark - Invocation Handling

// this method should be overloaded by subclasses
- (NSUInteger)argumentCountWithInvocation:(NSInvocation *)invocation;

@end

