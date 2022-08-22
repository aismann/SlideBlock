//
//  AdmobIOS.m
//  SlideBlock
//
//  Created by Harry Nguyen on 22/8/22.
//

#import "AdmobIOS.h"
#import <GoogleMobileAds/GADBannerView.h>
#import <GoogleMobileAds/GADInterstitialAd.h>

typedef enum : NSUInteger {
  TopLeft = 1,
  TopCenter = 2,
  TopRight = 3,
  MiddleLeft = 4,
  MiddleCenter = 5,
  MiddleRight = 6,
  BottomLeft = 7,
  BottomCenter = 8,
  BottomRight = 9
} AdPosition;

@interface AdmobIOS() <GADBannerViewDelegate, GADFullScreenContentDelegate>
@property (nonatomic, strong) GADBannerView* bannerView;
@property (nonatomic, strong) GADInterstitialAd* interstitialAd;
@end

@implementation AdmobIOS

+ (AdmobIOS*)sharedAdmob {
  static AdmobIOS* sAdmobManager = nil;
  @synchronized (self) {
    if (sAdmobManager == nil) {
      sAdmobManager = [[self alloc] init];
    }
  }
  return sAdmobManager;
}

- (void)showBannerInPosition:(int) position {
  if (self.bannerId == nil || self.bannerId.length == 0) {
    return;
  }
  if (self.bannerView == nil) {
    CGRect vFrame = [self rootViewController].view.frame;
    /// Ad banner will be hight 32 px
    GADAdSize size = GADInlineAdaptiveBannerAdSizeWithWidthAndMaxHeight(vFrame.size.width, 32.0);
    self.bannerView = [[GADBannerView alloc] initWithAdSize: size origin: CGPointZero];
    [self.bannerView setAdUnitID: self.bannerId];
    [self.bannerView setDelegate: self];
    [self.bannerView setRootViewController: [self rootViewController]];
    [[self rootViewController].view addSubview:  self.bannerView];
    
    GADRequest* request = [GADRequest request];
    [self.bannerView loadRequest: request];
  }
  
  [self.bannerView setFrame:[self getFrameFromPosition: position]];
  [self.bannerView setHidden: NO];
}

- (void)hideBanner {
  if (self.bannerView == nil) { return; }
  [self.bannerView setHidden:YES];
}

- (void)loadInterstitial {
  if (self.interstitialId == nil || self.interstitialId.length == 0) {
    return;
  }
  if (self.interstitialAd == nil) {
    GADRequest *request = [GADRequest request];
    [GADInterstitialAd loadWithAdUnitID: self.interstitialId
                                request: request
                      completionHandler:^(GADInterstitialAd *ad, NSError *error) {
      if (error) {
        NSLog(@"Failed to load interstitial ad with error: %@", [error localizedDescription]);
        return;
      }
      self.interstitialAd = ad;
      self.interstitialAd.fullScreenContentDelegate = self;
    }];
  }
}

- (void)showInterstitial {
  if (self.interstitialAd != nil){
    [self.interstitialAd presentFromRootViewController: [self rootViewController]];
  } else {
    [self loadInterstitial];
  }
}

/// MARK: GADFullScreenContentDelegate
- (void)ad:(nonnull id<GADFullScreenPresentingAd>)ad didFailToPresentFullScreenContentWithError:(nonnull NSError *)error {
  NSLog(@"Ad did fail to present full screen content.");
}

- (void)adWillPresentFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
  NSLog(@"Ad will present full screen content.");
}

- (void)adDidDismissFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
  NSLog(@"Ad did dismiss full screen content.");
}

/// MARK: GADBannerViewDelegate
- (void)bannerViewDidReceiveAd:(nonnull GADBannerView *)bannerView {
  NSLog(@"bannerViewDidReceiveAd");
}

- (void)bannerView:(nonnull GADBannerView *)bannerView didFailToReceiveAdWithError:(nonnull NSError *)error {
  NSLog(@"didFailToReceiveAdWithError: %@", [error localizedDescription]);
}

- (void)bannerViewDidRecordImpression:(nonnull GADBannerView *)bannerView {
  NSLog(@"bannerViewDidRecordImpression");
}

- (void)bannerViewDidRecordClick:(nonnull GADBannerView *)bannerView {
  NSLog(@"bannerViewDidRecordClick");
}

/// MARK: Helper method
- (BOOL)isLandscape {
  UIInterfaceOrientation orientation = [self getInterfaceOrientation];
  return UIInterfaceOrientationIsLandscape(orientation);
}

- (BOOL)isPortrait {
  UIInterfaceOrientation orientation = [self getInterfaceOrientation];
  return UIInterfaceOrientationIsPortrait(orientation);
}


- (UIInterfaceOrientation)getInterfaceOrientation {
  return [self getFixedOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

- (UIInterfaceOrientation)getFixedOrientation:(UIInterfaceOrientation) statusBarOrientation
{
  if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
    //    statusBarOrientation = UIInterfaceOrientationPortrait;
  }
  return statusBarOrientation;
}

- (CGRect)getFrameFromPosition:(int)position {
  CGRect frame = self.bannerView.frame;
  CGRect vFrame = [self rootViewController].view.frame;
  if (([self isLandscape] && vFrame.size.width < vFrame.size.height) ||
      ([self isPortrait] && vFrame.size.width > vFrame.size.height)) {
    CGFloat temp = vFrame.size.width;
    vFrame.size.width = vFrame.size.height;
    vFrame.size.height = temp;
  }
  
  CGPoint point;
  switch (position) {
    case TopLeft:
      point = CGPointMake(0, 0);
      break;
    case TopCenter:
      point = CGPointMake((vFrame.size.width - frame.size.width) / 2, 0);
      break;
    case TopRight:
      point = CGPointMake(vFrame.size.width - frame.size.width, 0);
      break;
    case MiddleLeft:
      point = CGPointMake(0, (vFrame.size.height - frame.size.height) / 2);
      break;
    case MiddleCenter:
      point = CGPointMake((vFrame.size.width - frame.size.width) / 2, (vFrame.size.height - frame.size.height) / 2);
      break;
    case MiddleRight:
      point = CGPointMake(vFrame.size.width - frame.size.width, (vFrame.size.height - frame.size.height) / 2);
      break;
    case BottomLeft:
      point = CGPointMake(0, (vFrame.size.height - frame.size.height));
      break;
    case BottomCenter:
      point = CGPointMake((vFrame.size.width - frame.size.width) / 2, (vFrame.size.height - frame.size.height));
      break;
    case BottomRight:
      point = CGPointMake(vFrame.size.width - frame.size.width, (vFrame.size.height - frame.size.height));
      break;
    default:
      break;
  }
  frame.origin = point;
  return frame;
}

- (UIViewController*)rootViewController {
  UIWindow* window = [[UIApplication sharedApplication] keyWindow];
  if (!window) {
    NSArray* windows = [[UIApplication sharedApplication] windows];
    window = [windows objectAtIndex:0];
  }
  return [window rootViewController];
}

@end
