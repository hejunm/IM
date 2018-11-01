//
//  HEMulticastDelegate.m
//  IM
//
//  Created by wulixiwa on 2018/10/20.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import "HEMulticastDelegate.h"

@interface HEMulticastDelegateNode : NSObject
@property(nonatomic,weak)id delegate;
@property(nonatomic,strong)dispatch_queue_t delegateQueue;
- (id)initWithDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue;
@end

@implementation HEMulticastDelegateNode
- (id)initWithDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue{
    if (self = [super init]) {
        self.delegate = delegate;
        self.delegateQueue = delegateQueue;
    }
    return self;
}
@end

@interface HEMulticastDelegate()
@property (nonatomic, strong)NSMutableArray<HEMulticastDelegateNode *> *delegateNodes;
@end

@implementation HEMulticastDelegate
- (instancetype)init{
    if (self = [super init]) {
        self.delegateNodes = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)addDelegate:(id)delegate{
    [self addDelegate:delegate delegateQueue:NULL];
}

- (void)addDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue{
    if (delegate == nil) {
        return;
    }
    HEMulticastDelegateNode *node = [[HEMulticastDelegateNode alloc]initWithDelegate:delegate delegateQueue:delegateQueue];
    [self.delegateNodes addObject:node];
}

- (void)removeDelegate:(id)delegate{
    [self removeDelegate:delegate delegateQueue:NULL];
}

- (void)removeDelegate:(id)delegate delegateQueue:(nullable dispatch_queue_t)delegateQueue{
    NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
    NSUInteger count = self.delegateNodes.count;
    for (int i=0; i<count; i++) {
        HEMulticastDelegateNode *node = self.delegateNodes[i];
        if (delegate == node.delegate) {
            if (delegateQueue==NULL || delegateQueue==node.delegateQueue) {
                node.delegate = nil;
                [indexSet addIndex:i];
            }
        }
    }
    [self.delegateNodes removeObjectsAtIndexes:indexSet];
}

- (void)removeAllDelegates{
    for (HEMulticastDelegateNode *node in self.delegateNodes) {
        node.delegate = nil;
        node.delegateQueue = NULL;
    }
    [self.delegateNodes removeAllObjects];
}

- (NSUInteger)count{
    return [self.delegateNodes count];
}

- (NSUInteger)countOfClass:(Class)aClass{
    NSUInteger count = 0;
    for (HEMulticastDelegateNode *node in self.delegateNodes){
        id nodeDelegate = node.delegate;
        if ([nodeDelegate isKindOfClass:aClass]){
            count++;
        }
    }
    return count;
}

- (NSUInteger)countForSelector:(SEL)aSelector{
    NSUInteger count = 0;
    for (HEMulticastDelegateNode *node in self.delegateNodes){
        id nodeDelegate = node.delegate;
        if ([nodeDelegate respondsToSelector:aSelector]){
            count++;
        }
    }
    return count;
}

- (BOOL)hasDelegateThatRespondsToSelector:(SEL)aSelector{
    for (HEMulticastDelegateNode *node in self.delegateNodes){
        id nodeDelegate = node.delegate;
        if ([nodeDelegate respondsToSelector:aSelector]){
            return YES;
        }
    }
    return NO;
}

#pragma mark - 消息转发
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    for (HEMulticastDelegateNode *node in self.delegateNodes){
        id nodeDelegate = node.delegate;
        if ([nodeDelegate respondsToSelector:aSelector]){
            NSMethodSignature * result = [nodeDelegate methodSignatureForSelector:aSelector];
            if (result != nil){
                return result;
            }
        }
    }
    return [[self class] instanceMethodSignatureForSelector:@selector(doNothing)];
}



- (void)forwardInvocation:(NSInvocation *)origInvocation{
    SEL selector = [origInvocation selector];
    BOOL foundNilDelegate = NO;
    for (HEMulticastDelegateNode *node in self.delegateNodes){
        id nodeDelegate = node.delegate;
        if ([nodeDelegate respondsToSelector:selector]){
            NSInvocation *dupInvocation = [self duplicateInvocation:origInvocation];
            // All delegates MUST be invoked ASYNCHRONOUSLY.
            if (node.delegateQueue == NULL) {
                [dupInvocation invokeWithTarget:nodeDelegate];
            }else{
                dispatch_async(node.delegateQueue, ^{ @autoreleasepool {
                    [dupInvocation invokeWithTarget:nodeDelegate];
                }});
            }
            
        }else if (nodeDelegate == nil){
            foundNilDelegate = YES;
        }
    }
    if (foundNilDelegate){
        /**
         At lease one weak delegate reference disappeared.
         Remove nil delegate nodes from the list.
         
         This is expected to happen very infrequently.
         This is why we handle it separately (as it requires allocating an indexSet).
         */
        NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
        NSUInteger count = self.delegateNodes.count;
        for (int i=0; i<count; i++) {
            HEMulticastDelegateNode *node = self.delegateNodes[i];
            if (node.delegate == nil){
                [indexSet addIndex:i];
            }
        }
        [self.delegateNodes removeObjectsAtIndexes:indexSet];
    }
}

- (NSInvocation *)duplicateInvocation:(NSInvocation *)origInvocation{
    NSMethodSignature *methodSignature = [origInvocation methodSignature];
    NSInvocation *dupInvocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    [dupInvocation setSelector:[origInvocation selector]];
    NSUInteger i, count = [methodSignature numberOfArguments];
    for (i = 2; i < count; i++){
        const char *type = [methodSignature getArgumentTypeAtIndex:i];
        if (*type == *@encode(BOOL)){
            BOOL value;
            [origInvocation getArgument:&value atIndex:i];
            [dupInvocation setArgument:&value atIndex:i];
        }
        else if (*type == *@encode(char) || *type == *@encode(unsigned char)){
            char value;
            [origInvocation getArgument:&value atIndex:i];
            [dupInvocation setArgument:&value atIndex:i];
        }
        else if (*type == *@encode(short) || *type == *@encode(unsigned short)){
            short value;
            [origInvocation getArgument:&value atIndex:i];
            [dupInvocation setArgument:&value atIndex:i];
        }
        else if (*type == *@encode(int) || *type == *@encode(unsigned int)){
            int value;
            [origInvocation getArgument:&value atIndex:i];
            [dupInvocation setArgument:&value atIndex:i];
        }
        else if (*type == *@encode(long) || *type == *@encode(unsigned long)){
            long value;
            [origInvocation getArgument:&value atIndex:i];
            [dupInvocation setArgument:&value atIndex:i];
        }
        else if (*type == *@encode(long long) || *type == *@encode(unsigned long long)){
            long long value;
            [origInvocation getArgument:&value atIndex:i];
            [dupInvocation setArgument:&value atIndex:i];
        }
        else if (*type == *@encode(double)){
            double value;
            [origInvocation getArgument:&value atIndex:i];
            [dupInvocation setArgument:&value atIndex:i];
        }
        else if (*type == *@encode(float)){
            float value;
            [origInvocation getArgument:&value atIndex:i];
            [dupInvocation setArgument:&value atIndex:i];
        }
        else if (*type == '@'){
            void *value;
            [origInvocation getArgument:&value atIndex:i];
            [dupInvocation setArgument:&value atIndex:i];
        }
        else if (*type == '^'){
            void *block;
            [origInvocation getArgument:&block atIndex:i];
            [dupInvocation setArgument:&block atIndex:i];
        }
        else{
            NSString *selectorStr = NSStringFromSelector([origInvocation selector]);
            
            NSString *format = @"Argument %lu to method %@ - Type(%c) not supported";
            NSString *reason = [NSString stringWithFormat:format, (unsigned long)(i - 2), selectorStr, *type];
            
            [[NSException exceptionWithName:NSInvalidArgumentException reason:reason userInfo:nil] raise];
        }
    }
    [dupInvocation retainArguments];
    return dupInvocation;
}

- (void)doNothing {
    
}

- (void)doesNotRecognizeSelector:(SEL)aSelector{
    // Prevent NSInvalidArgumentException
}

- (void)dealloc{
    [self removeAllDelegates];
}
@end



