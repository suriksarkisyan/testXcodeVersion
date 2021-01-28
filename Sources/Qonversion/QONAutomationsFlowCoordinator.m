//
//  QONAutomationsFlowCoordinator.m
//  Qonversion
//
//  Created by Surik Sarkisyan on 24.09.2020.
//  Copyright © 2020 Qonversion Inc. All rights reserved.
//

#import "QONAutomationsFlowCoordinator.h"
#import "QONAutomationsFlowAssembly.h"
#import "QONAutomationsDelegate.h"
#import "QONAutomationsViewController.h"
#import "QONAutomationsService.h"
#import "QONAutomationsScreen.h"
#import "QONAutomationsActionsHandler.h"
#import "QNUserActionPoint.h"

@interface QONAutomationsFlowCoordinator() <QONAutomationsViewControllerDelegate>

@property (nonatomic, weak) id<QONAutomationsDelegate> automationsDelegate;
@property (nonatomic, strong) QONAutomationsFlowAssembly *assembly;
@property (nonatomic, strong) QONAutomationsService *automationsService;

@end

@implementation QONAutomationsFlowCoordinator

+ (instancetype)sharedInstance {
  static id shared = nil;
  static dispatch_once_t once;
  dispatch_once(&once, ^{
    shared = [self new];
  });
  
  return shared;
}

- (instancetype)init {
  self = [super init];
  
  if (self) {
    _assembly = [QONAutomationsFlowAssembly new];
    _automationsService = [_assembly automationsService];
  }
  
  return self;
}

- (void)setAutomationsDelegate:(id<QONAutomationsDelegate>)automationsDelegate {
  _automationsDelegate = automationsDelegate;
}

- (BOOL)handlePushNotification:(NSDictionary *)userInfo {
  BOOL shouldShowAutomation = [userInfo[@"qonv.pick_screen"] boolValue];
  if (shouldShowAutomation) {
    [self showAutomationIfExists];
  }
  
  return shouldShowAutomation;
}

- (void)showAutomationIfExists {
  __block __weak QONAutomationsFlowCoordinator *weakSelf = self;
  [self.automationsService obtainAutomationScreensWithCompletion:^(NSArray<QNUserActionPoint *> *actionPoints, NSError * _Nullable error) {
    NSArray<QNUserActionPoint *> *sortedActions = [actionPoints sortedArrayUsingSelector:@selector(createDate)];
    QNUserActionPoint *latestAction = sortedActions.lastObject;
    NSString *automationID = latestAction.screenId;
    
    if (automationID.length > 0) {
      [weakSelf showAutomationWithID:automationID];
    }
  }];
}

- (void)showAutomationWithID:(NSString *)automationID {
  __block __weak QONAutomationsFlowCoordinator *weakSelf = self;
  [self.automationsService automationWithID:automationID completion:^(QONAutomationsScreen *screen, NSError * _Nullable error) {
    if (screen) {
      [weakSelf.automationsService trackScreenShownWithID:automationID];
      QONAutomationsViewController *viewController = [weakSelf.assembly configureAutomationsViewControllerWithScreen:screen delegate:self];
      
      UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
      navigationController.navigationBarHidden = YES;
      
      UIViewController *presentationViewController;
      
      if ([weakSelf.automationsDelegate respondsToSelector:@selector(controllerForNavigation)]) {
        presentationViewController = [weakSelf.automationsDelegate controllerForNavigation];
      } else {
        presentationViewController = [weakSelf topLevelViewController];
      }
      navigationController.modalPresentationStyle = UIModalPresentationFullScreen;
      [presentationViewController presentViewController:navigationController animated:YES completion:nil];
    }
  }];
}

#pragma mark - QONAutomationsViewControllerDelegate

- (void)automationsDidShowScreen:(NSString *)screenID {
  if ([self.automationsDelegate respondsToSelector:@selector(automationsDidShowScreen:)]) {
    [self.automationsDelegate automationsDidShowScreen:screenID];
  }
}

- (void)automationsStartedActionResult:(QONActionResult *)actionResult {
  if ([self.automationsDelegate respondsToSelector:@selector(automationsStartedActionResult:)]) {
    [self.automationsDelegate automationsStartedActionResult:actionResult];
  }
}

- (void)automationsFailedActionResult:(QONActionResult *)actionResult {
  if ([self.automationsDelegate respondsToSelector:@selector(automationsFailedActionResult:)]) {
    [self.automationsDelegate automationsFailedActionResult:actionResult];
  }
}

- (void)automationsFinishedActionResult:(QONActionResult *)actionResult {
  if ([self.automationsDelegate respondsToSelector:@selector(automationsFinishedActionResult:)]) {
    [self.automationsDelegate automationsFinishedActionResult:actionResult];
  }
}

- (void)automationsFinished {
  if ([self.automationsDelegate respondsToSelector:@selector(automationsFinished)]) {
    [self.automationsDelegate automationsFinished];
  }
}

#pragma mark - Private

- (UIViewController *)topLevelViewController {
  UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;

  while (topController.presentedViewController) {
    topController = topController.presentedViewController;
  }

  return topController;
}

@end
