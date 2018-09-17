
#import <UIKit/UIKit.h>

/**
 需要加载的数据类型
 */
typedef enum : NSUInteger {
    
    //    1为全部，10为图片，29为段子，31为音频，41为视频
    BSJTopicTypeAll = 1,
    BSJTopicTypePicture = 10,
    BSJTopicTypeWords = 29,
    BSJTopicTypeVoice = 31,
    BSJTopicTypeVideo = 41,
    
} BSJTopicType;



typedef enum : NSUInteger {
    BSJUserSexFemale = 1, //女
    BSJUserSexMale = 0, // 男
} BSJUserSex;





/**
 *  百思不得姐的api
 */
UIKIT_EXTERN NSString *const BSJBaiSiJieHTTPAPI;



/**
 *  用户的性别, 服务器返回字段
 */
UIKIT_EXTERN NSString *const BSJUserSexFemaleStr;

/**
 *  用户的性别, 服务器返回字段
 */
UIKIT_EXTERN NSString *const BSJUserSexMaleStr;

// 服务器SUP
UIKIT_EXTERN NSString *const SUPSUPBaseUrl;


/** tabBar被选中的通知名字 */
UIKIT_EXTERN NSString * const SUPTabBarDidSelectNotification;
/** tabBar被选中的通知 - 被选中的控制器的index key */
UIKIT_EXTERN NSString * const SUPSelectedControllerIndexKey;
/** tabBar被选中的通知 - 被选中的控制器 key */
UIKIT_EXTERN NSString * const SUPSelectedControllerKey;

UIKIT_EXTERN CGFloat const SUPTopicCellMargin;

/** 标签-间距 */
UIKIT_EXTERN CGFloat const SUPTagMargin;
/** 标签-高度 */
UIKIT_EXTERN CGFloat const SUPTagH;




