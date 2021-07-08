//
//  PostCell.m
//  Instagram
//
//  Created by Sanjana Meduri on 7/7/21.
//

#import "PostCell.h"
#import "NSDate+DateTools.h"

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setPost:(Post *)post {
    _post = post;
    self.imageView.file = post[@"image"];
    [self.imageView loadInBackground];
    
    NSDate *creationDate = post.createdAt;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yy"];
    
    NSString *stringFromDate = [formatter stringFromDate:creationDate];
    
    self.creationDateLabel.text = stringFromDate;
    
    self.captionLabel.text = post[@"caption"];
    
    self.likeCount.text = [NSString stringWithFormat:@"%@",  post[@"likeCount"]];
    self.commentCount.text = [NSString stringWithFormat:@"%@",  post[@"commentCount"]];
    
    self.usernameLabel.text = (post[@"author"])[@"username"];
}

@end
