Original App Design Project - README Template
===

# Closet Friend
Demo https://youtu.be/wwmKZ8lCe54

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
This app allows you to input your closet items to help assist you with future shopping. It will have an easy to use search feature, so the user would always be aware of how much close of a certain category they have.

### App Evaluation
[Evaluation of your app across the following attributes]
* **Category:** Lifestyle
* **Mobile:** Can take pictures of clothes and tag them immediately. Also can be used on the go when shopping and comparing your closet with what you are planning to purchase.
* **Story:** Gives people a well rounded look at their closet and helps them not lose track of clothes that are out of season. 
* **Market:** There are other apps available like this, but I fell like being able to search through the closet will be an important aspect. Some times we put away our summer clothes for the winter and then forget about them, when summer comes around again we have forgoten about our summer clothes and go out an by a pair of flip flops not realizing that we already ahve two pairs stored away with our summer clothes.
* **Habit:** Will be used whenever a person is shopping or just wanting to look through the clothes that one has.
* **Scope:** The main aspects of this app would be adding items to your in app 'closet' and having ways to organize the items. After that, I think more interesting features could be added.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* User can login
* User can see a main page with a portion of there closet
* User can go to their profile page with their personal information
* User can click a button and go to the full closet page
* User can view all of their items in a grid layout
* User can view all of their items in a cell layout
* User can filter closet with different categories (i.e. season, clothing type, color)
* User can click a button in the closet and it takes them to a new item page
* User can add a new item by filling out the new item page and adding a photo
* User can logout
* User can create a new account

**Optional Nice-to-have Stories**

* User can have some kind of outfit selector tool, based on what ever factors they select
* User can delete items

### 2. Screen Archetypes

* Login page
   * User can login
* Sign-up page
   * User can create a new account
* Main page
    * User can see a main page with a portion of there closet
    * User can click a button and go to the full closet page
    * User can go to their profile page with their personal information
    * User can logout
* Profile page
    * User can go to their profile page with their personal information
* Closet page
    * User can view all of their items in a grid layout
    * User can view all of their items in a cell layout
    * User can filter closet with different categories (i.e. season, clothing type, color)
    * User can click a button in the closet and it takes them to a new item page
* New item page
    * User can add a new item by filling out the new item page and adding a photo

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Main Page
* Closet Page
* Profile Page

**Flow Navigation** (Screen to Screen)

* Login
   * Main Page
   * Sign up
* Sign up
   * Main
* Main
    * Closet
    * Profile
    * Login
* Closet
    * New Item
* Profile
    * Edit profile

## Wireframes
[Add picture of your hand sketched wireframes in this section]
<img src="https://github.com/annak4397/Closet-Friend/blob/master/Wireframe.pdf" width=600>

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema 
[This section will be completed in Unit 9]
### Models
**Model: User**
| Property	| Type |	Description |
| --- | --- | --- |
| objectID | String | unique id for the user (default field) |
| profileImage |	File	| users choosen profile image |
| username | String | user's username |
| name | String | user's name |
| password | String | user's password |
| createdAt	| DateTime | date when post is created (default field) |
| updatedAt	| DateTime | date when post is last updated (default field) |

**Model: Item**
| Property	| Type |	Description |
| --- | --- | --- |
| objectId | String | unique id for the item (default field) |
| author	| Pointer to User |	item creator |
| image |	File	| image that user addes to the item |
| description |	String |	short description of the item by author |
| season | String | season for which the user categorizes that item |
| size | Stiring | size lable for that item |
| itemType | String | what category this item falls under |
| price | Number | cost of the item at time of purchase |
| numberOfTimesWorn | Number | times the user has pressed the wear button |
| pricePerWear | Number | price divided by number of times worn |
| createdAt	| DateTime | date when post is created (default field) |
| updatedAt	| DateTime | date when post is last updated (default field) |

**Model: Outfit**
| Property	| Type |	Description |
| --- | --- | --- |
| objectId | String | unique id for the item (default field) |
| author	| Pointer to User |	outfit created for the particular creator |
| items |	Array	| items that are a part of this outfit |
| season | String | season for this outfit |
| price | Number | cost of the all the items in the outfit |
| season | String | season for this outfit |
| liked | Boolean | field to deternin if a user liked this generated outfit |
| createdAt	| DateTime | date when post is created (default field) |
| updatedAt	| DateTime | date when post is last updated (default field) |

### Networking
**Screen: Loggin**
| Type | Description | Code Example |
| --- | --- | --- |
| Create/POST | signing up user | [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {<br>if (error != nil) {<br>NSLog(@"Error: %@", error.localizedDescription);<br>} else {<br>NSLog(@"User registered successfully");<br>[self performSegueWithIdentifier:@"loginSegue" sender:nil];}}]; |
| Read/Get | logging user | [PFUser logInWithUsernameInBackground:email password:password block:^(PFUser * user, NSError *  error) {<br>if (error != nil) {<br>NSLog(@"User log in failed: %@", error.localizedDescription);<br>} else {<br>NSLog(@"User logged in successfully");<br>[self performSegueWithIdentifier:@"loginSegue" sender:nil];}}]; |

**Screen: Home**
| Type | Description | Code Example |
| --- | --- | --- |
| Read/GET | get latest 5-10 items from closet | PFQuery *query = [PFQuery queryWithClassName:@"Item"];<br>[query findObjectsInBackgroundWithBlock:^(NSArray *items, NSError *error) {<br>if (items != nil) {<br>self.items = items;<br>[self.tableView reloadData];<br>} else {<br>NSLog(@"%@", error.localizedDescription);}}]; |
| Read/GET | get latest 5-10 favorited outfits | PFQuery *query = [PFQuery queryWithClassName:@"Item"];<br>//add some kind of search ability to get the favorited outfits<br>[query findObjectsInBackgroundWithBlock:^(NSArray *items, NSError *error) {<br>if (items != nil) {<br>self.items = items;<br>[self.tableView reloadData];<br>} else {<br>NSLog(@"%@", error.localizedDescription);}}]; |

**Screen: Closet**
| Type | Description | Code Example |
| --- | --- | --- |
| Read/GET | get all items based on filter options | PFQuery *query = [PFQuery queryWithClassName:@"Item"];<br>//add some kind of search ability to get the items based on filters<br>[query findObjectsInBackgroundWithBlock:^(NSArray *items, NSError *error) {<br>if (items != nil) {<br>self.items = items;<br>[self.tableView reloadData];<br>} else {<br>NSLog(@"%@", error.localizedDescription);}}]; |

**Screen: New Item**
| Type | Description | Code Example |
| --- | --- | --- |
| Create/POST | add a new item to the database that the user creates | [Item itemUserImage:itemImage withCaption:self.captionTextView.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {<br>if(succeeded){<br>[self dismissViewControllerAnimated:YES completion:^{<br>[self.delegate didPost];}];<br>}else{<br>NSLog(@"Something went wrong with posting: %@", error.localizedDescription);<br>}}]; |

**Screen: New Outfit**
| Type | Description | Code Example |
| --- | --- | --- |
| Create/POST | add a new outfit to the database that the user creates | [Item itemUserImage:itemImage withCaption:self.captionTextView.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {<br>if(succeeded){<br>[self dismissViewControllerAnimated:YES completion:^{<br>[self.delegate didPost];}];<br>}else{<br>NSLog(@"Something went wrong with posting: %@", error.localizedDescription);<br>}}]; |
| Update/PUT | update outfit based on if the user likes it | not sure about the code yet |

**Screen: Profile**
| Type | Description | Code Example |
| --- | --- | --- |
| Read/GET | gets user's information to load | not sure about the code yet |
| Update/PUT | update user's information | not sure about the code yet |
