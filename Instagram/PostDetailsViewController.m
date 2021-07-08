//
//  PostDetailsViewController.m
//  Instagram
//
//  Created by Sanjana Meduri on 7/7/21.
//

#import "PostDetailsViewController.h"
@import Parse;
#import <UIKit/UIKit.h>
#import "Post.h"

@interface PostDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet PFImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *likeCount;
@property (weak, nonatomic) IBOutlet UILabel *commentCount;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *creationDateLabel;

@end

@implementation PostDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView.file = self.post[@"image"];
    [self.imageView loadInBackground];
    
    self.creationDateLabel.text = [NSString stringWithFormat:@"%@",  self.post[@"createdAt"]];
    
    self.captionLabel.text = self.post[@"caption"];
    
    self.likeCount.text = [NSString stringWithFormat:@"%@",  self.post[@"likeCount"]];
    self.commentCount.text = [NSString stringWithFormat:@"%@",  self.post[@"commentCount"]];
    
    self.usernameLabel.text = (self.post[@"author"])[@"username"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
