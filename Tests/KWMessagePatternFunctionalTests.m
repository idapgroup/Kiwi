#import <Kiwi/Kiwi.h>
#import "KiwiTestConfiguration.h"
#import "TestClasses.h"

typedef void(^KWTestBlock)(id);

SPEC_BEGIN(KWMessagePatternFunctionalTests)

describe(@"message patterns", ^{

    it(@"can match a selector with a specific single argument", ^{
        Cruiser *cruiser = [Cruiser new];
        Fighter *fighter = [Fighter mock];
        [[cruiser should] receive:@selector(loadFighter:) withArguments:fighter];
        [cruiser loadFighter:fighter];
    });

});

describe(@"block message patterns", ^{
    
    it(@"can match a call with a specific single argument", ^{
        id argument = [NSObject new];
        id block = theBlockProxy(^(id object) { [object description]; });
        
        [[block should] beEvaluatedWithArguments:argument];

        ((KWTestBlock)block)(argument);
    });
    
});

SPEC_END
