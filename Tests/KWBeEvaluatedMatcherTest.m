//
//  KWBeEvaluatedMatcherTest.m
//  Kiwi
//
//  Created by Oleksa 'trimm' Korin on 4/21/16.
//  Copyright © 2016 Allen Ding. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "KiwiTestConfiguration.h"
#import "TestClasses.h"

#if KW_TESTS_ENABLED

typedef void(^KWVoidBlock)(void);

@interface KWBeEvaluatedMatcherTest : XCTestCase
@property (nonatomic, strong) id subject;
@property (nonatomic, readonly) KWBeEvaluatedMatcher *matcher;
@property (nonatomic, readonly) KWBeEvaluatedMatcher *negativeExpecationMatcher;

@end

@implementation KWBeEvaluatedMatcherTest

@dynamic matcher;
@dynamic negativeExpecationMatcher;

- (void)setUp {
    [super setUp];
    
    Class class = [self class];
    id subject = [KWProxyBlock blockWithBlock:^{ [class description]; }];
    self.subject = subject;
}

- (KWBeEvaluatedMatcher *)matcher {
    return [KWBeEvaluatedMatcher matcherWithSubject:self.subject];
}

- (KWBeEvaluatedMatcher *)negativeExpecationMatcher {
    KWBeEvaluatedMatcher *matcher = self.matcher;
    matcher.willEvaluateAgainstNegativeExpectation = YES;
    
    return matcher;
}

- (void)callSubject {
    id subject = self.subject;
    
    if (subject) {
        ((KWVoidBlock)subject)();
    }
}

- (void)callSubjectWithCount:(NSUInteger)count {
    for (NSUInteger i = 0; i < count; i++) {
        [self callSubject];
    }
}

- (void)testItShouldHaveTheRightMatcherStrings {
    id matcherStrings = [KWBeEvaluatedMatcher matcherStrings];
    id expectedStrings = @[@"beEvaluated",
                           @"beEvaluatedWithCount",
                           @"beEvaluatedWithCountAtLeast:",
                           @"beEvaluatedWithCountAtMost:",
                           @"beEvaluatedWithArguments:",
                           @"beEvaluatedWithCount:arguments:",
                           @"beEvaluatedWithCountAtLeast:arguments:",
                           @"beEvaluatedWithCountAtMost:arguments:"];
    
    XCTAssertEqualObjects([matcherStrings sortedArrayUsingSelector:@selector(compare:)],
                          [expectedStrings sortedArrayUsingSelector:@selector(compare:)],
                          @"expected specific matcher strings");
}

- (void)testItShouldMatchEvaluationsForBeEvaluated {
    KWBeEvaluatedMatcher *matcher = self.matcher;
    
    [matcher beEvaluated];
    
    [self callSubject];
    
    XCTAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldMatchMultipleEvaluationsForBeEvaluatedWhenAttachedToNegativeVerifier {
    KWBeEvaluatedMatcher *matcher = self.negativeExpecationMatcher;
    [matcher beEvaluated];
    
    [self callSubjectWithCount:2];
    
    XCTAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchMultipleEvaluationsForBeEvaluatedWhenNotAttachedToNegativeVerifier {
    KWBeEvaluatedMatcher *matcher = self.matcher;
    
    [matcher beEvaluated];
    [matcher beEvaluated];

    [self callSubjectWithCount:2];
    
    XCTAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldMatchEvaluationsForBeEvaluatedWithCount {
    KWBeEvaluatedMatcher *matcher = self.matcher;
    
    [matcher beEvaluatedWithCount:2];
    
    [self callSubjectWithCount:2];
    
    XCTAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchEvaluationsForBeEvaluatedWithInappropriateCount {
    KWBeEvaluatedMatcher *matcher = self.matcher;
    
    [matcher beEvaluatedWithCount:2];
    
    [self callSubjectWithCount:3];
    
    XCTAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldMatchEvaluationsForBeEvaluatedWithCountAtLeast {
    KWBeEvaluatedMatcher *matcher = self.matcher;
    
    [matcher beEvaluatedWithCountAtLeast:2];
    
    [self callSubjectWithCount:3];
    
    XCTAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchEvaluationsForBeEvaluatedWithInappropriateCountAtLeast {
    KWBeEvaluatedMatcher *matcher = self.matcher;
    
    [matcher beEvaluatedWithCountAtLeast:2];
    
    [self callSubjectWithCount:1];
    
    XCTAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldMatchEvaluationsForBeEvaluatedWithCountAtMost {
    KWBeEvaluatedMatcher *matcher = self.matcher;
    
    [matcher beEvaluatedWithCountAtMost:3];
    
    [self callSubjectWithCount:2];
    
    XCTAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchEvaluationsForBeEvaluatedWithInappropriateCountAtMost {
    KWBeEvaluatedMatcher *matcher = self.matcher;
    
    [matcher beEvaluatedWithCountAtMost:2];
    
    [self callSubjectWithCount:3];
    
    XCTAssertFalse([matcher evaluate], @"expected negative match");
}

@end

#endif // #if KW_TESTS_ENABLED
