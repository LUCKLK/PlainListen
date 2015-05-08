//
//  MusicListViewController.m
//  PlainListen
//
//  Created by lanouhn on 15-4-8.
//  Copyright (c) 2015年 luck. All rights reserved.
//

#import "MusicListViewController.h"
#import "VerticalLayout_.h"
#import "SectionsLayout_.h"
#import "MusicCell.h"
#import "SectionCell.h"
#import "SectionHeaderView.h"
#import "UILayout.h"
#import "List.h"
#import "DataHelper.h"
#import "PlayingViewController.h"
#import "MyMusicPlayer.h"
#import "HintView.h"
#import "Reimu.h"
#import "BackgroundView.h"
#import "SectionBackView.h"

@interface MusicListViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, UISearchBarDelegate>
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionView *sectionCollectionView;
@property (strong, nonatomic) UIView *allMusicsView;
@property (strong, nonatomic) VerticalLayout_ *verticalLayout;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableArray *sectionArr;
@property (strong, nonatomic) DataHelper *dataHelper;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *searchArr;
@property (copy, nonatomic) NSArray *tempSaveArr;       //搜索时保存数据
@property (strong, nonatomic) UITapGestureRecognizer *cancleKeyBoard;
@property (nonatomic) UIInterfaceOrientation interfaceOrientation;
@end

@implementation MusicListViewController

- (void)reloadSomething {
    self.sectionArr = [[self.dataHelper.listMusics allKeys] mutableCopy];
    [self.sectionCollectionView reloadData];
    self.dataSource = self.dataHelper.allMusic;
    [self.collectionView reloadData];
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        self.dataSource = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataSource;
}

- (NSMutableArray *)sectionArr {
    if (!_sectionArr) {
        self.sectionArr = [[self.dataHelper.listMusics allKeys] mutableCopy];
    }
    return _sectionArr;
}

- (void)loadView {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH / 2 * 3, SCREEN_HEIGHT);
    scrollView.contentOffset = CGPointMake(SCREEN_WIDTH / 2, 0);
    scrollView.bounces = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    self.view = scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataHelper = [DataHelper sharedDataHelper];
    self.dataSource = self.dataHelper.allMusic;
    // Do any additional setup after loading the view.
    [self listCollectionLayout];
    [self sectionCollectionLayout];
    [self allMusicViewLayout];
}

//列表详情布局
- (void)listCollectionLayout {
    self.verticalLayout = [[VerticalLayout_ alloc] init];
    self.collectionView = [[BackgroundView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:self.verticalLayout];
    [self.collectionView registerNib:[UINib nibWithNibName:@"MusicCell" bundle:nil] forCellWithReuseIdentifier:@"sher"];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    UISwipeGestureRecognizer *downSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    downSwipe.direction = UISwipeGestureRecognizerDirectionDown;
    [_collectionView addGestureRecognizer:downSwipe];
    
    UISwipeGestureRecognizer *upSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    upSwipe.direction = UISwipeGestureRecognizerDirectionUp;
    [_collectionView addGestureRecognizer:upSwipe];
    [self.view addSubview:self.collectionView];
    
}

#pragma mark - search


- (void)handleSwipe:(UISwipeGestureRecognizer *)swipe {
    switch (swipe.direction) {
        case UISwipeGestureRecognizerDirectionDown:
        {
            if (((UIScrollView *)self.view).contentOffset.x == SCREEN_WIDTH / 2) {
                if (!_searchBar) {
                    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2, 0 - 40, SCREEN_WIDTH, 40)];
                    _searchBar.delegate = self;
                    [self.view addSubview:_searchBar];
                    [UIView animateWithDuration:0.7 animations:^{
                        _collectionView.center = CGPointMake(_collectionView.center.x, _collectionView.center.y + 40);
                        _searchBar.frame = CGRectMake(SCREEN_WIDTH / 2, 0, SCREEN_WIDTH, 40);
                    } completion:^(BOOL finished) {
                        
                    }];
                } else {
                    [UIView animateWithDuration:0.5 animations:^{
                        _collectionView.center = CGPointMake(_collectionView.center.x, _collectionView.center.y - 40);
                        _searchBar.frame = CGRectMake(SCREEN_WIDTH / 2, -40, SCREEN_WIDTH, 40);
                    } completion:^(BOOL finished) {
                        [_searchBar removeFromSuperview];
                        self.searchBar = nil;
                        if (_cancleKeyBoard) {
                            [self.collectionView removeGestureRecognizer:_cancleKeyBoard];
                            self.cancleKeyBoard = nil;
                        }
                    }];
                }
            }
        }
            break;
        case UISwipeGestureRecognizerDirectionUp:
        {
            if (_collectionView.center.y == SCREEN_HEIGHT / 2) {
                PlayingViewController *playingVC = [PlayingViewController mainPlayingViewController];
                if (![[MyMusicPlayer sharedMyMusicPlayer] isPlaying]) {
                    [playingVC.reimu.timer invalidate];
                }
                [[[[UIApplication sharedApplication] delegate] window] bringSubviewToFront:playingVC.view];
            }
        }
            break;
        default:
            break;
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.tempSaveArr = [NSArray arrayWithArray:_dataSource];
    NSMutableArray *arr = [NSMutableArray array];
    for (Music *music in _dataSource) {
        [arr addObject:music.title];
    }
    self.searchArr = [NSArray arrayWithArray:arr];
    self.cancleKeyBoard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapCollectionView:)];
    [_collectionView addGestureRecognizer:_cancleKeyBoard];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText isEqualToString:@""]) {
        NSLog(@"xxxxxxxx");
        self.dataSource = [_tempSaveArr mutableCopy];
        [self.collectionView reloadData];
        return;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@",searchText];
    NSArray *arr = [_searchArr filteredArrayUsingPredicate:predicate];
    NSMutableArray *mutableArr = [NSMutableArray array];
    if (arr) {
        for (NSString *title in arr) {
            for (Music *music in _tempSaveArr) {
                if ([title isEqualToString:music.title]) {
                    [mutableArr addObject:music];
                }
            }
        }
    }
    self.dataSource = mutableArr;
    [self.collectionView reloadData];
}

- (void)handleTapCollectionView:(UITapGestureRecognizer *)tap {
    if (_searchBar) {
        [_searchBar endEditing:YES];
    }
    [self.collectionView removeGestureRecognizer:tap];
}


//分区列表布局
- (void)sectionCollectionLayout {
    SectionsLayout_ *sectionsLayout = [[SectionsLayout_ alloc] init];
    self.sectionCollectionView = [[SectionBackView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 2, SCREEN_HEIGHT - SECTION_CELL_HEIGHT) collectionViewLayout:sectionsLayout];
    [self.sectionCollectionView registerNib:[UINib nibWithNibName:@"SectionTitle" bundle:nil] forCellWithReuseIdentifier:@"her"];
    [self.sectionCollectionView registerNib:[UINib nibWithNibName:@"SectionHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    self.sectionCollectionView.showsVerticalScrollIndicator = NO;
    self.sectionCollectionView.dataSource = self;
    self.sectionCollectionView.delegate = self;
    [self.view addSubview:self.sectionCollectionView];
}
//所有歌曲分区布局
- (void)allMusicViewLayout {
    self.allMusicsView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - SECTION_CELL_HEIGHT, SCREEN_WIDTH / 2, SECTION_CELL_HEIGHT)];
    self.allMusicsView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"All_Musics"]];
    self.allMusicsView.layer.borderWidth = 5.5;
    self.allMusicsView.layer.borderColor = [UIColor whiteColor].CGColor;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [_allMusicsView addGestureRecognizer:tap];
    [self.view addSubview:_allMusicsView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    label.center = CGPointMake(_allMusicsView.bounds.size.width / 2, _allMusicsView.bounds.size.height / 2);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"ALL";
    label.font = [UIFont systemFontOfSize:30];
    [_allMusicsView addSubview:label];
}

- (void)handleTap:(UITapGestureRecognizer *)tap {
    self.dataSource = self.dataHelper.allMusic;
    [self.collectionView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.collectionView) {
         return self.dataSource.count;
    } else if (collectionView == self.sectionCollectionView) {
        return self.sectionArr.count;
    }
    return 0;
}
//返回cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.collectionView) {
        MusicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"sher" forIndexPath:indexPath];
        cell.music = self.dataSource[indexPath.item];
        return cell;
    }
    if (collectionView == self.sectionCollectionView) {
        SectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"her" forIndexPath:indexPath];
        cell.list = self.dataHelper.listMusics[self.sectionArr[indexPath.item]];
        return cell;
    }
    return nil;
}
//返回辅助视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.sectionCollectionView) {
        if (kind == UICollectionElementKindSectionHeader) {
            SectionHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
            __weak typeof(self) mySelf = self;
            header.creatList = ^(List *list) {
                [mySelf.sectionArr insertObject:list.title atIndex:0];
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
                [mySelf.sectionCollectionView insertItemsAtIndexPaths:@[indexPath]];
                [mySelf.sectionCollectionView reloadItemsAtIndexPaths:@[indexPath]];
            };
            return header;
        }
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.sectionCollectionView) {
//        NSString *listName = ((Music *)[self.dataSource firstObject]).listName;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:1];
        for (int i = 0; i < self.sectionArr.count; i++) {
            NSIndexPath *indexP = [NSIndexPath indexPathForItem:i inSection:0];
            SectionCell *ell = (SectionCell *)[self.sectionCollectionView cellForItemAtIndexPath:indexP];
            if (ell) {
                CGRectIntersectsRect(ell.frame, self.sectionCollectionView.frame);
                [arr addObject:ell];
            }
        }
        for (SectionCell *aCell in arr) {
            aCell.selet = NO;
        }
        SectionCell *cell = (SectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
        //        if (![cell.list.title isEqualToString:listName]) {
        self.dataSource = ((List *)self.dataHelper.listMusics[self.sectionArr[indexPath.item]]).musics;
        cell.selet = YES;
        [self.collectionView reloadData];
//        }
    } else if (collectionView == self.collectionView) {
        MusicCell *cell = (MusicCell *)[collectionView cellForItemAtIndexPath:indexPath];
        MyMusicPlayer *myPlayer = [MyMusicPlayer sharedMyMusicPlayer];
        [myPlayer playWithMusic:cell.music];
        PlayingViewController *playingVC = [PlayingViewController mainPlayingViewController];
        [playingVC.reimu setTrans];
        [[[[UIApplication sharedApplication] delegate] window] bringSubviewToFront:playingVC.view];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset NS_AVAILABLE_IOS(5_0) {
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView == _collectionView) {
        if (scrollView.contentOffset.y < - 25) {
            if (!_searchBar) {
                NSLog(@"ddddd");
                self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2, 0 - 40, SCREEN_WIDTH, 40)];
                _searchBar.delegate = self;
                [self.view addSubview:_searchBar];
                [UIView animateWithDuration:0.7 animations:^{
                    _collectionView.center = CGPointMake(_collectionView.center.x, _collectionView.center.y + 40);
                    _searchBar.frame = CGRectMake(SCREEN_WIDTH / 2, 0, SCREEN_WIDTH, 40);
                } completion:^(BOOL finished) {

                }];

            } else {
                NSLog(@"sssss");
                [UIView animateWithDuration:0.5 animations:^{
                    _collectionView.center = CGPointMake(_collectionView.center.x, _collectionView.center.y - 40);
                    _searchBar.frame = CGRectMake(SCREEN_WIDTH / 2, -40, SCREEN_WIDTH, 40);
                } completion:^(BOOL finished) {
                    [_searchBar removeFromSuperview];
                    self.searchBar = nil;
                    if (_cancleKeyBoard) {
                        [self.collectionView removeGestureRecognizer:_cancleKeyBoard];
                        self.cancleKeyBoard = nil;
                    }
                }];

            }
        }

    }
    }
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {

}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
    self.interfaceOrientation = interfaceOrientation;
}


@end
