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
#import "NSDate+DateTools.h"

@interface PostDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet PFImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *likeCount;
@property (weak, nonatomic) IBOutlet UILabel *commentCount;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *creationDateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *likeIcon;

@end

@implementation PostDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self populateDetails];
    
}

- (void) populateDetails{
    self.imageView.file = self.post.image;
    [self.imageView loadInBackground];
    
    NSDate *creationDate = self.post.createdAt;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yy"];
    NSString *dateString = [dateFormatter stringFromDate:creationDate];
    self.creationDateLabel.text = dateString;

    self.captionLabel.text = self.post.caption;
    
    self.likeCount.text = [NSString stringWithFormat:@"%@",  self.post.likeCount];
    self.commentCount.text = [NSString stringWithFormat:@"%@",  self.post.commentCount];
    
    self.usernameLabel.text = (self.post.author)[@"username"];
}

- (IBAction)onLike:(id)sender {
    int numberOfLikes = [self.post.likeCount intValue] + 1;
    self.post.likeCount = [NSNumber numberWithInt:numberOfLikes];
    
    [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (succeeded) {
                self.likeCount.text = [NSString stringWithFormat:@"%@",  self.post.likeCount];
            } else {
                NSLog(@"Problem saving post: %@", error.localizedDescription);
            }}];
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
