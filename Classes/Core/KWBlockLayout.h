//
//  KWBlockLibClosure.h
//  Kiwi
//
//  Created by Oleksa 'trimm' Korin on 4/16/16.
//  Copyright © 2016 Allen Ding. All rights reserved.
//

#import "KiwiConfiguration.h"

typedef enum {
    kKWBlockDeallocating        = (0x0001),  // runtime
    kKWBlockRefcountMask        = (0xfffe),  // runtime
    kKWBlockNeedsFree           = (1 << 24), // runtime
    kKWBlockHasCopyDispose      = (1 << 25), // compiler
    kKWBlockHasCTOR             = (1 << 26), // compiler: helpers have C++ code
    kKWBlockIsGC                = (1 << 27), // runtime
    kKWBlockIsGlobal            = (1 << 28), // compiler
    kKWBlockHasStructureReturn  = (1 << 29), // compiler: undefined if !BLOCK_HAS_SIGNATURE
    kKWBlockHasSignature        = (1 << 30), // compiler
    kKWBlockHasExtendedLayout   = (1 << 31)  // compiler
} kKWBlockOptions;

struct KWBlockDescriptor {
    uintptr_t reserved;
    uintptr_t size;
};
typedef struct KWBlockDescriptor KWBlockDescriptor;

struct KWBlockDescriptorCopyDispose {
    // requires BLOCK_HAS_COPY_DISPOSE
    void (*copy)(void *dst, const void *src);
    void (*dispose)(const void *);
};
typedef struct KWBlockDescriptorCopyDispose KWBlockDescriptorCopyDispose;

struct KWBlockDescriptorMetadata {
    // requires BLOCK_HAS_SIGNATURE
    const char *signature;
    const char *layout;     // contents depend on BLOCK_HAS_EXTENDED_LAYOUT
};
typedef struct KWBlockDescriptorMetadata KWBlockDescriptorMetadata;

struct KWBlockLayout {
    void *isa;
    volatile int32_t flags; // contains ref count
    int32_t reserved;
    IMP imp;
    KWBlockDescriptor *descriptor;
};
typedef struct KWBlockLayout KWBlockLayout;


FOUNDATION_EXPORT
BOOL KWBlockLayoutGetFlags(KWBlockLayout *block);

FOUNDATION_EXPORT
BOOL KWBlockLayoutGetOption(KWBlockLayout *block, kKWBlockOptions option);

FOUNDATION_EXPORT
BOOL KWBlockLayoutIsDeallocating(KWBlockLayout *block);

FOUNDATION_EXPORT
BOOL KWBlockLayoutNeedsFree(KWBlockLayout *block);

FOUNDATION_EXPORT
BOOL KWBlockLayoutHasCopyDispose(KWBlockLayout *block);

FOUNDATION_EXPORT
BOOL KWBlockLayoutHasCTOR(KWBlockLayout *block);

FOUNDATION_EXPORT
BOOL KWBlockLayoutIsGC(KWBlockLayout *block);

FOUNDATION_EXPORT
BOOL KWBlockLayoutIsGlobal(KWBlockLayout *block);

FOUNDATION_EXPORT
BOOL KWBlockLayoutHasStructureReturn(KWBlockLayout *block);

FOUNDATION_EXPORT
BOOL KWBlockLayoutHasSignature(KWBlockLayout *block);

FOUNDATION_EXPORT
BOOL KWBlockLayoutHasExtendedLayout(KWBlockLayout *block);

FOUNDATION_EXPORT
BOOL KWBlockLayoutHasExtendedLayout(KWBlockLayout *block);

FOUNDATION_EXPORT
BOOL KWBlockLayoutGetImp(KWBlockLayout *block);

FOUNDATION_EXPORT
BOOL KWBlockLayoutGetSignature(KWBlockLayout *block);

FOUNDATION_EXPORT
KWBlockDescriptor KWBlockLayoutGetDescriptor(KWBlockLayout *block);

FOUNDATION_EXPORT
KWBlockDescriptorMetadata KWBlockLayoutGetDescriptorMetadata(KWBlockLayout *block);
