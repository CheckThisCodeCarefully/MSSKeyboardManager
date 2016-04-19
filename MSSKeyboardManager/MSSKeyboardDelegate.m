//
//  MSSKeyboardDelegate.m
//
//  Created by Merrick Sapsford on 07/04/2016.
//  Copyright © 2016 Merrick Sapsford. All rights reserved.
//

#import "MSSKeyboardDelegate.H"

@implementation MSSKeyboardUpdate

+ (instancetype)updateWithDictionary:(NSDictionary *)updateDictionary {
    return [[[self class]alloc]initWithDictionary:updateDictionary];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        _beginFrame = [[dictionary objectForKey:UIKeyboardFrameBeginUserInfoKey]CGRectValue];
        _endFrame = [[dictionary objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
        _animationDuration = [[dictionary objectForKey:UIKeyboardAnimationDurationUserInfoKey]floatValue];
        _animationCurve = [[dictionary objectForKey:UIKeyboardAnimationCurveUserInfoKey]unsignedIntegerValue];
        _isLocal = [[dictionary objectForKey:UIKeyboardIsLocalUserInfoKey]boolValue];
    }
    return self;
}

@end

@implementation MSSKeyboardDelegate

#pragma mark - Init

+ (instancetype)keyboardDelegateForResponder:(id<MSSKeyboardDelegate>)responder {
    return [[[self class]alloc]initWithResponder:responder];
}

- (instancetype)initWithResponder:(id<MSSKeyboardDelegate>)responder {
    if (self = [super init]) {
        _responder = responder;
        [self registerNotifications];
    }
    return self;
}

#pragma mark - Lifecycle

- (void)dealloc {
    [self unregisterNotifications];
}

#pragma mark - Notifications

- (void)keyboardWillShowNotification:(NSNotification *)notification {
    if ([self.responder respondsToSelector:@selector(keyboardDelegate:willShowKeyboardWithUpdate:)]) {
        MSSKeyboardUpdate *update = [MSSKeyboardUpdate updateWithDictionary:notification.userInfo];
        [self.responder keyboardDelegate:self willShowKeyboardWithUpdate:update];
    }
}

- (void)keyboardDidShowNotification:(NSNotification *)notification {
    if ([self.responder respondsToSelector:@selector(keyboardDelegate:didShowKeyboardWithUpdate:)]) {
        MSSKeyboardUpdate *update = [MSSKeyboardUpdate updateWithDictionary:notification.userInfo];
        [self.responder keyboardDelegate:self didShowKeyboardWithUpdate:update];
    }
}

- (void)keyboardWillHideNotification:(NSNotification *)notification {
    if ([self.responder respondsToSelector:@selector(keyboardDelegate:willHideKeyboardWithUpdate:)]) {
        MSSKeyboardUpdate *update = [MSSKeyboardUpdate updateWithDictionary:notification.userInfo];
        [self.responder keyboardDelegate:self willHideKeyboardWithUpdate:update];
    }
}

- (void)keyboardDidHideNotification:(NSNotification *)notification {
    if ([self.responder respondsToSelector:@selector(keyboardDelegate:didHideKeyboardWithUpdate:)]) {
        MSSKeyboardUpdate *update = [MSSKeyboardUpdate updateWithDictionary:notification.userInfo];
        [self.responder keyboardDelegate:self didHideKeyboardWithUpdate:update];
    }
}

#pragma mark - Internal

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyboardWillShowNotification:)
                                                name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyboardDidShowNotification:)
                                                name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyboardWillHideNotification:)
                                                name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyboardDidHideNotification:)
                                                name:UIKeyboardDidHideNotification object:nil];
}

- (void)unregisterNotifications {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
