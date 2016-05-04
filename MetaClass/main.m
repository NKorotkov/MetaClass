//
//  main.m
//  MetaClass
//
//  Created by Nikolay Korotkov on 27/04/16.
//  Copyright © 2016 Nikolay Korotkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

void _printMetaclass(Class _objClass) {
    NSLog(@"%@ metaclass: %p", object_getClass(_objClass), object_getClass(_objClass));
}

void _printClass(Class _objClass) {
    NSLog(@"%@: %p", _objClass, _objClass);
}

void _reportFunction(id self, SEL _cmd) {

    _printClass([self class]);
    _printMetaclass([NSClassFromString(@"RuntimeNSErrorSubclass") class]);
    _printClass([self superclass]);
    _printClass([NSObject class]);
    _printMetaclass([NSObject class]);
 
    Class currentClass = [self class];
    for (int i=0; i<5; i++) {
        NSLog(@"Traversed through isa tree %i times, current class is %p, named: %@", i, currentClass, currentClass);
        currentClass = object_getClass(currentClass);
    }
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        Class newClass = objc_allocateClassPair([NSError class], "RuntimeNSErrorSubclass", 0);
        class_addMethod(newClass, NSSelectorFromString(@"report"), (IMP)_reportFunction, "V@:");
        objc_registerClassPair(newClass);
        
        id newClassInstance = [[newClass alloc] initWithDomain:@"" code:0 userInfo:nil];
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [newClassInstance performSelector:NSSelectorFromString(@"report")];
#pragma clang diagnostic pop

    }
    return 0;
}



