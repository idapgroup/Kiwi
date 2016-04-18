//
//  KWBlockLayout.m
//  Kiwi
//
//  Created by Oleksa 'trimm' Korin on 4/16/16.
//  Copyright © 2016 Allen Ding. All rights reserved.
//

#import <objc/message.h>

#include "KWBlockLayout.h"

kKWBlockOptions KWBlockLayoutGetFlags(KWBlockLayout *block) {
    return block->flags & ~(kKWBlockRefcountMask | kKWBlockDeallocating);
}

BOOL KWBlockLayoutGetOption(KWBlockLayout *block, kKWBlockOptions option) {
    return KWBlockLayoutGetFlags(block) & option;
}

BOOL KWBlockLayoutHasCopyDispose(KWBlockLayout *block) {
    return KWBlockLayoutGetOption(block, kKWBlockHasCopyDispose);
}

BOOL KWBlockLayoutHasCTOR(KWBlockLayout *block) {
    return KWBlockLayoutGetOption(block, kKWBlockHasCTOR);
}

BOOL KWBlockLayoutIsGlobal(KWBlockLayout *block) {
    return KWBlockLayoutGetOption(block, kKWBlockIsGlobal);
}

BOOL KWBlockLayoutHasStructureReturn(KWBlockLayout *block) {
    return KWBlockLayoutGetOption(block, kKWBlockHasStructureReturn) && KWBlockLayoutHasSignature(block);
}

BOOL KWBlockLayoutHasSignature(KWBlockLayout *block) {
    return KWBlockLayoutGetOption(block, kKWBlockHasSignature);
}

BOOL KWBlockLayoutHasExtendedLayout(KWBlockLayout *block) {
    return KWBlockLayoutGetOption(block, kKWBlockHasExtendedLayout);
}

IMP KWBlockLayoutGetImp(KWBlockLayout *block) {
    return block->imp;
}

uintptr_t KWBlockLayoutGetDescriptorSize(KWBlockLayout *block) {
    return KWBlockLayoutGetDescriptor(block)->size;
}

const char *KWBlockLayoutGetSignature(KWBlockLayout *block) {
    if (!KWBlockLayoutHasSignature(block)) {
        return NULL;
    }
    
    return KWBlockLayoutGetDescriptorMetadata(block)->signature;
}

NSMethodSignature *KWBlockLayoutGetMethodSignature(KWBlockLayout *block) {
    // if there is no signature, we consider block to be returning void
    const char *UTF8Signature = KWBlockLayoutHasSignature(block) ? KWBlockLayoutGetSignature(block) : @encode(void);
    
    NSString *signature = [NSString stringWithFormat: @"%s", UTF8Signature];
    NSMethodSignature *result = [NSMethodSignature signatureWithObjCTypes:signature.UTF8String];
    
    // if there are not enough arguments, we append them by adding void *, which is valid for both id and SEL
    // forwarding expect.
    while (result.numberOfArguments < 2) {
        signature = [NSString stringWithFormat:@"%@%s", signature, @encode(void *)];
        result = [NSMethodSignature signatureWithObjCTypes:signature.UTF8String];
    }
    
    return result;
}

KWBlockDescriptor *KWBlockLayoutGetDescriptor(KWBlockLayout *block) {
    return block->descriptor;
}

KWBlockDescriptorMetadata *KWBlockLayoutGetDescriptorMetadata(KWBlockLayout *block) {
    if (!KWBlockLayoutHasSignature(block)) {
        return NULL;
    }
    
    uint8_t *address = (uint8_t *)KWBlockLayoutGetDescriptor(block);
    address += sizeof(KWBlockDescriptor);
    if (KWBlockLayoutHasCopyDispose(block)) {
        address += sizeof(KWBlockDescriptorCopyDispose);
    }
    
    return (KWBlockDescriptorMetadata *)address;
}

IMP KWBlockLayoutGetForwardingImp(KWBlockLayout *block) {
    // explicit type casting for OBJC_OLD_DISPATCH_PROTOTYPES
    return KWBlockLayoutHasStructureReturn(block) ? (IMP)_objc_msgForward_stret : (IMP)_objc_msgForward;
}
