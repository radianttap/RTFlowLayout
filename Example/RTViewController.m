//
//  RTViewController.m
//  RTFlowLayout
//
//  Created by Aleksandar Vacić on 24.10.12..
//  Copyright (c) 2012. Aleksandar Vacić. All rights reserved.
//

#import "RTViewController.h"
#import "RTFlowLayout.h"
#import "RTPhotoCell.h"
#import "RTGroupHeaderView.h"
#import "RTGroupFooterView.h"
#import "RTMastheadView.h"
#import "RTColophonView.h"

@interface RTViewController ()

@property (nonatomic, strong) NSArray *pics;

@end

@implementation RTViewController

#pragma mark - Init

- (id)initWithCollectionViewLayout:(RTFlowLayout *)layout {
	
	layout.itemSize = CGSizeMake(60.0, 40.0);
	layout.headerReferenceSize = CGSizeMake(320, 160);
	layout.footerReferenceSize = CGSizeMake(320, 100);
	layout.sectionHeaderReferenceSize = CGSizeMake(320, 60);
	layout.sectionFooterReferenceSize = CGSizeMake(320, 2);
	layout.sectionInset = UIEdgeInsetsMake(0, 20, 20, 20);
	layout.scrollDirection = UICollectionViewScrollDirectionVertical;
	
	self = [super initWithCollectionViewLayout:layout];
	if (self) {
		//	build data source
		self.pics = @[
		@{@"name" : @"Paris",
			@"photos" : @[
			@"20070424-IMG_0681.jpg",
			@"20070426-IMG_1086.jpg",
			@"20070426-IMG_1153.jpg",
			@"20070427-IMG_1293.jpg",
			@"20070427-IMG_1436.jpg",
			@"20070428-IMG_1726.jpg",
			@"20070428-IMG_1801.jpg"
			]},
		@{@"name" : @"Vineyard",
			@"photos" : @[
			@"20080623-IMG_5998-2.jpg",
			@"20080623-IMG_5998.jpg",
			@"20080712-IMG_6175.jpg",
			@"20080712-IMG_6186.jpg",
			@"20080712-IMG_6226.jpg",
			@"20080712-IMG_6228.jpg",
			@"20080712-IMG_6270.jpg",
			@"20080901-IMG_6979.jpg",
			@"20081011-IMG_7875.jpg",
			@"20081011-IMG_7880.jpg",
			@"20081011-IMG_7882.jpg",
			]},
		@{@"name" : @"Kopaonik",
			@"photos" : @[
			@"20090307-IMG_8895.jpg",
			@"20090307-IMG_8899.jpg",
			@"20090307-IMG_8903.jpg",
			@"20090307-IMG_8907.jpg",
			@"20090307-IMG_8910.jpg",
			@"20090311-IMG_8998.jpg",
			@"20090311-IMG_9033.jpg",
			@"20090311-IMG_9036.jpg",
			@"20090311-IMG_9051.jpg",
			@"20090311-IMG_9052.jpg",
			@"20090311-IMG_9090.jpg",
			@"20090311-IMG_9092.jpg",
			@"20090311-IMG_9135.jpg",
			@"20090311-IMG_9137.jpg",
			@"20090312-IMG_9175.jpg"
			]},
		@{@"name" : @"Istra",
			@"photos" : @[
			@"20090822-IMG_9677.jpg",
			@"20090822-IMG_9690.jpg",
			@"20090823-IMG_9709.jpg",
			@"20090823-IMG_9751.jpg",
			@"20090824-IMG_9764.jpg",
			@"20090826-IMG_0017.jpg",
			@"20090826-IMG_9888.jpg",
			@"20090826-IMG_9977.jpg"
			]},
		@{@"name" : @"Space",
			@"photos" : @[
			@"Universe_and_planets_digital_art_wallpaper_albireo.jpg",
			@"Universe_and_planets_digital_art_wallpaper_church.jpg",
			@"Universe_and_planets_digital_art_wallpaper_Decampment.jpg",
			@"Universe_and_planets_digital_art_wallpaper_denebola.jpg",
			@"Universe_and_planets_digital_art_wallpaper_dk.jpg",
			@"Universe_and_planets_digital_art_wallpaper_Hibernaculum.jpg",
			@"Universe_and_planets_digital_art_wallpaper_lucernarium.jpg",
			@"Universe_and_planets_digital_art_wallpaper_lux.jpg",
			@"Universe_and_planets_digital_art_wallpaper_moons.jpg",
			@"Universe_and_planets_digital_art_wallpaper_praedestinatio.jpg",
			@"Universe_and_planets_digital_art_wallpaper_transitorius.jpg",
			@"Universe_and_planets_digital_art_wallpaper_victimofgravity.jpg"
			]}
		];
	}
	
	return self;
}

#pragma mark - View lifecycle

-(void)viewDidLoad {
	[super viewDidLoad];
	
	self.view.backgroundColor = [UIColor whiteColor];
	self.collectionView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.600];
	
	[self.collectionView registerClass:[RTPhotoCell class] forCellWithReuseIdentifier:@"PHOTO_CELL"];
	
	[self.collectionView registerNib:[UINib nibWithNibName:@"MastheadView" bundle:nil] forSupplementaryViewOfKind:RTCollectionElementKindHeader withReuseIdentifier:@"MASTHEAD"];
	[self.collectionView registerNib:[UINib nibWithNibName:@"ColophonView" bundle:nil] forSupplementaryViewOfKind:RTCollectionElementKindFooter withReuseIdentifier:@"COLOPHON"];
	
	[self.collectionView registerNib:[UINib nibWithNibName:@"GroupHeader" bundle:nil] forSupplementaryViewOfKind:RTCollectionElementKindSectionHeader withReuseIdentifier:@"GROUP_HEADER"];
	[self.collectionView registerNib:[UINib nibWithNibName:@"GroupFooter" bundle:nil] forSupplementaryViewOfKind:RTCollectionElementKindSectionFooter withReuseIdentifier:@"GROUP_FOOTER"];
}



#pragma mark - Flow Layout Delegate

//- (CGSize)collectionView:(UICollectionView *)collectionView layoutReferenceSizeForHeader:(RTFlowLayout *)collectionViewLayout {}
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(RTFlowLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {}
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(RTFlowLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {}
//	etc.




#pragma mark - Collection View Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	
	NSInteger ret = [self.pics count];
	
    return ret;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
	
	NSInteger ret = 0;
	
	NSDictionary *d = [self.pics objectAtIndex:section];
	ret = [(NSArray *)[d objectForKey:@"photos"] count];
	
    return ret;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
	
	if (kind == RTCollectionElementKindSectionHeader) {
		RTGroupHeaderView *v = [collectionView dequeueReusableSupplementaryViewOfKind:RTCollectionElementKindSectionHeader withReuseIdentifier:@"GROUP_HEADER" forIndexPath:indexPath];
		NSDictionary *d = [self.pics objectAtIndex:indexPath.section];
		v.groupTitleLabel.text = [d objectForKey:@"name"];
		return v;
		
	} else if (kind == RTCollectionElementKindSectionFooter) {
		RTGroupFooterView *v = [collectionView dequeueReusableSupplementaryViewOfKind:RTCollectionElementKindSectionFooter withReuseIdentifier:@"GROUP_FOOTER" forIndexPath:indexPath];
		return v;
		
	} else if (kind == RTCollectionElementKindHeader) {
		RTMastheadView *v = [collectionView dequeueReusableSupplementaryViewOfKind:RTCollectionElementKindHeader withReuseIdentifier:@"MASTHEAD" forIndexPath:indexPath];
		return v;
		
	} else if (kind == RTCollectionElementKindFooter) {
		RTColophonView *v = [collectionView dequeueReusableSupplementaryViewOfKind:RTCollectionElementKindFooter withReuseIdentifier:@"COLOPHON" forIndexPath:indexPath];
		return v;
		
	}
	
	return nil;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	RTPhotoCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"PHOTO_CELL" forIndexPath:indexPath];
	
	NSDictionary *d = [self.pics objectAtIndex:indexPath.section];
	NSArray *thumbs = (NSArray *)[d objectForKey:@"photos"];
	
	[cell.imageView setImage:[UIImage imageNamed:[thumbs objectAtIndex:indexPath.row]]];
	
	return cell;
}


@end
