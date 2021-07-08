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
#import "SceneDelegate.h"
#import "LoginViewController.h"

@interface ProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *pfpView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) PFUser *user;
@property (strong, nonatomic) NSArray *posts;
@property (strong, nonatomic) UIRefreshControl *refreshControl;


@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    self.user = PFUser.currentUser;
    
    self.usernameLabel.text = self.user.username;
    
    [self queryPosts];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*) self.collectionView.collectionViewLayout;
        
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    
    CGFloat postersPerLine = 3;
    CGFloat itemWidth = ((self.collectionView.frame.size.width - layout.minimumInteritemSpacing * (postersPerLine - 1)) / postersPerLine);
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    

    [self.collectionView reloadData];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(queryPosts) forControlEvents:UIControlEventValueChanged];
    [self.collectionView insertSubview:self.refreshControl atIndex:0];
}

- (void) queryPosts{
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
    int numPosts = 20;
    query.limit = numPosts;

    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.posts = posts;
            [self.collectionView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    [self.collectionView reloadData];
    [self.refreshControl endRefreshing];
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

- (IBAction)onPfpTap:(id)sender {
    [self getPicture:YES];
}

//refactored codepath snippet into function with boolean parameter
- (void) getPicture:(BOOL)willTakePicture{
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    if (willTakePicture){
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        else
            NSLog(@"Camera 🚫 available so we will use photo library instead");
    }
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // next two lines are from codepath
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];

    CGSize newSize = CGSizeMake(300, 300);
    UIImage *resizedImage = [self resizeImage:editedImage withSize:newSize];
    
    [self.pfpView setImage:resizedImage];
    
    
    // following line from codepath
    [self dismissViewControllerAnimated:YES completion:nil];
}

//method from codepath
- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (IBAction)onLogout:(id)sender {
    //following line was taken from codepath
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {}];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    myDelegate.window.rootViewController = loginViewController;
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
