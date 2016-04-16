//
//  KWBlockLayout.m
//  Kiwi
//
//  Created by Oleksa 'trimm' Korin on 4/16/16.
//  Copyright © 2016 Allen Ding. All rights reserved.
//

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

NSMethodSignature *KWBlockLayoutGetSignature(KWBlockLayout *block) {
    if (!KWBlockLayoutHasSignature(block)) {
        return nil;
    }
    
    NSString *signatureString = [NSString stringWithFormat: @"%s", KWBlockLayoutGetDescriptorMetadata(block)->signature];
    
#warning TODO: test the way it is in libclosure-65
    NSMethodSignature *result = [NSMethodSignature signatureWithObjCTypes:signatureString.UTF8String];
    while (result.numberOfArguments < 2) {
        signatureString = [NSString stringWithFormat: @"%@%s", signatureString, @encode(void *)];
        result = [NSMethodSignature signatureWithObjCTypes:signatureString.UTF8String];
    }
    
    return result;
}

KWBlockDescriptor *KWBlockLayoutGetDescriptor(KWBlockLayout *block) {
    return block->descriptor;
}

FOUNDATION_EXPORT
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
