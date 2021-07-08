//
//  ProfileViewController.m
//  Instagram
//
//  Created by Sanjana Meduri on 7/8/21.
//

#import "ProfileViewController.h"
@import Parse;
#import "Parse/Parse.h"
#import "Post.h"
#import "PostCollectionCell.h"
#import "UIImageView+AFNetworking.h"

@interface ProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *pfpView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) PFUser *user;
@property (strong, nonatomic) NSArray *posts;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    self.user = PFUser.currentUser;
    
    self.usernameLabel.text = self.user.username;
    
    int numPosts = 40;
    [self queryPosts:numPosts];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*) self.collectionView.collectionViewLayout;
        
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    
    CGFloat postersPerLine = 3;
    CGFloat itemWidth = ((self.collectionView.frame.size.width - layout.minimumInteritemSpacing * (postersPerLine - 1)) / postersPerLine);
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    

    [self.collectionView reloadData];
}

- (void) queryPosts:(int) numPosts{
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    [query includeKey:@"likeCount"];
    [query includeKey:@"commentCount"];
    [query includeKey:@"createdAt"];
    [query includeKey:@"objectId"];
    [query includeKey:@"caption"];
    [query includeKey:@"image"];
    
    [query whereKey:@"author" equalTo:self.user];
    query.limit = numPosts;

    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.posts = posts;
            [self.collectionView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PostCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PostCollectionCell" forIndexPath:indexPath];
    
    Post *currentPost = self.posts[indexPath.item];
    PFFileObject *image = currentPost.image;
    NSURL *imageURL = [NSURL URLWithString:image.url];
    [cell.postImageView setImageWithURL:imageURL];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.posts.count;
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
