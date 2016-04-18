//
//  KWProxyBlock.m
//  Kiwi
//
//  Created by Oleksa 'trimm' Korin on 4/18/16.
//  Copyright © 2016 Allen Ding. All rights reserved.
//

#import "KWProxyBlock.h"

#import "KWBlockLayout.h"

@interface NSInvocation (KWPrivateInterface)

- (void)invokeUsingIMP:(IMP)imp;

@end

@interface KWProxyBlock()

#pragma mark - Properties

@property (nonatomic, readonly, copy) id block;
@property (nonatomic, readonly, assign) KWBlockLayout *blockLayout;
@property (nonatomic, readonly, assign) KWBlockDescriptor *descriptor;

#pragma mark - Methods

- (void)interposeBlock:(id)block;

@end

@implementation KWProxyBlock {
    // we imitate the block layout for block forwarding to work
    // the order of ivars is important
    volatile int32_t _flags;
    int32_t _reserved;
    IMP _imp;
    KWBlockDescriptor *_descriptor;
    
    // ivars related to our class, rather, than to the block
    id _block;
}

@synthesize block = _block;
@synthesize descriptor = _descriptor;

@dynamic blockLayout;

#pragma mark - Deallocating

- (void)dealloc {
    free(_descriptor);
    _descriptor = NULL;
}

#pragma mark - Initializing

- (id)initWithBlock:(id)block {
    self = [super init];
    if (self) {
        _block = [block copy];
        [self interposeBlock:_block];
    }
    
    return self;
}

+ (id)blockWithBlock:(id)aBlock {
    return [[self alloc] initWithBlock:aBlock];
}

#pragma mark - Block Interposing

- (void)interposeBlock:(id)interposeBlock {
    KWBlockLayout *block = (__bridge KWBlockLayout *)interposeBlock;
    
    _flags = KWBlockLayoutGetFlags(block);
    
    if (_descriptor) {
        free(_descriptor);
    }
    
    uintptr_t interposeSize = KWBlockLayoutGetDescriptorSize(block);
    _descriptor = calloc(1, interposeSize);
    
    KWBlockDescriptor *descriptor = KWBlockLayoutGetDescriptor(block);
    memcpy(&_descriptor, descriptor, interposeSize);
    
    KWBlockDescriptorMetadata *descriptorMetadata = KWBlockLayoutGetDescriptorMetadata((__bridge KWBlockLayout *)self);
    descriptorMetadata->signature = KWBlockLayoutGetSignature(block);
    
    _imp = KWBlockLayoutGetForwardingImp(block);
}

- (id)copyWithZone:(nullable NSZone *)zone {
    return self;
}

#pragma mark - Properties

- (KWBlockLayout *)blockLayout {
    return (__bridge KWBlockLayout *)(self.block);
}

#pragma mark - Forwarding

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    return KWBlockLayoutGetMethodSignature(self.blockLayout);
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    [invocation setTarget:self.block];
    [invocation invokeUsingIMP:KWBlockLayoutGetImp(self.blockLayout)];
}

@end
