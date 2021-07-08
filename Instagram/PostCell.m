//
//  PostCell.m
//  Instagram
//
//  Created by Sanjana Meduri on 7/7/21.
//

#import "PostCell.h"

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
    
    self.creationDateLabel.text = post[@"createdAt"];
    
    self.captionLabel.text = post[@"caption"];
    
    self.likeCount.text = [NSString stringWithFormat:@"%@",  post[@"likeCount"]];
    self.commentCount.text = [NSString stringWithFormat:@"%@",  post[@"commentCount"]];
    
    self.usernameLabel.text = (post[@"author"])[@"username"];
}

@end
