//
//  HomeFeedViewController.m
//  Instagram
//
//  Created by Sanjana Meduri on 7/6/21.
//

#import "HomeFeedViewController.h"
#import "Parse/Parse.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "PostCell.h"
#import "PostDetailsViewController.h"
#import "SceneDelegate.h"

@interface HomeFeedViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSArray *posts;

@end

@implementation HomeFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self queryPosts];
    [self.tableView reloadData];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(queryPosts) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (IBAction)onLogout:(id)sender {
    //following line was taken from codepath
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {}];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    myDelegate.window.rootViewController = loginViewController;
}

- (void) queryPosts{
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    [query includeKey:@"likeCount"];
    [query includeKey:@"commentCount"];
    [query includeKey:@"createdAt"];
    [query includeKey:@"caption"];
    query.limit = 20;

    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.posts = posts;
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    
    Post *post = self.posts[indexPath.row];
    
    [cell setPost:post];
    
    return cell;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    PostDetailsViewController *detailsViewController =  [segue destinationViewController];
    UITableViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
    
    Post *tappedPost = self.posts[indexPath.row];
    detailsViewController.post = tappedPost;
}


@end
