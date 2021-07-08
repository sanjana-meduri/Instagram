//
//  PostCell.h
//  Instagram
//
//  Created by Sanjana Meduri on 7/7/21.
//

#import <UIKit/UIKit.h>
#import "Post.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface PostCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet PFImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *likeCount;
@property (weak, nonatomic) IBOutlet UILabel *commentCount;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *creationDateLabel;

@property (strong, nonatomic) Post *post;
- (void)setPost:(Post *)post;

@end

NS_ASSUME_NONNULL_END
