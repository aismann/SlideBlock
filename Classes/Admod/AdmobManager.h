//
//  AdmobManager.h
//  SlideBlock
//
//  Created by Harry Nguyen on 22/8/22.
//

#ifndef AdmobManager_h
#define AdmobManager_h

#include <string>

enum class AdmobPosition {
  TopLeft = 1,
  TopCenter = 2,
  TopRight = 3,
  MiddleLeft = 4,
  MiddleCenter = 5,
  MiddleRight = 6,
  BottomLeft = 7,
  BottomCenter = 8,
  BottomRight = 9
};

class AdmobManager {
public:
  static AdmobManager* getInstance();
  
  void init(const std::string &bannerId, const std::string &interstitialId);
  
  void showBanner(AdmobPosition position);
  void hideBanner();
  
  void loadInterstitial();
  void showInterstitial();

  bool isBannerAvailable();
};

#endif /* AdmobManager_h */
