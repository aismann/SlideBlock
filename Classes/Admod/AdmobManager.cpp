//
//  AdmobManager.c
//  SlideBlock
//
//  Created by Harry Nguyen on 22/8/22.
//

#include "AdmobManager.h"
#include "cocos2d.h"
using namespace std;
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
#include "AdmobIOSWrapper.h"
#endif

static AdmobManager _sAdmobManager;

AdmobManager* AdmobManager::getInstance() {
  return &_sAdmobManager;
}

void AdmobManager::init(const std::string &bannerId, const std::string &interstitialId) {
#if CC_TARGET_PLATFORM == CC_PLATFORM_IOS
  AdmobIOSWrapper::getInstance()->init(bannerId, interstitialId);
#endif
}

void AdmobManager::showBanner(AdmobPosition position) {
#if CC_TARGET_PLATFORM == CC_PLATFORM_IOS
  AdmobIOSWrapper::getInstance()->showBanner((int)position);
#endif
}

void AdmobManager::hideBanner() {
#if CC_TARGET_PLATFORM == CC_PLATFORM_IOS
  AdmobIOSWrapper::getInstance()->hideBanner();
#endif
}

void AdmobManager::loadInterstitial() {
#if CC_TARGET_PLATFORM == CC_PLATFORM_IOS
  AdmobIOSWrapper::getInstance()->loadInterstitial();
#endif
}

void AdmobManager::showInterstitial() {
#if CC_TARGET_PLATFORM == CC_PLATFORM_IOS
  AdmobIOSWrapper::getInstance()->showInterstitial();
#endif
}
bool AdmobManager::isBannerAvailable() {
#if CC_TARGET_PLATFORM == CC_PLATFORM_IOS
  return AdmobIOSWrapper::getInstance()->isBannerAvailable();
#endif
}

