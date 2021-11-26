# Bakester

## Links

|Links||
|-|-|
|Deployed Website:|<http://bakester.herokuapp.com>|
|Github:|<https://github.com/leighpoulier/bakester>|
|Trello:|<https://trello.com/b/Uayp6SHv/bakester>|

## About Bakester

Bakester is a Ruby on Rails web app where people can buy "bakes" from home bakers.  "Bakes" might include cakes, cupcakes, slices, pies, pastries, tarts, desserts etc. On Bakester a home baker can advertise baked items they are able and willing to produce in exchange for payment, and any other user can place an order for a specific bake.  The baker receives the order, produces the bake, and delivers it to the customer.

### The Problem

!["Car Cake" by Anne (source: BBC - The Great British Bake Off: An Extra Slice)](docs/carcake.jpg)
"Car Cake" by Anne (source: BBC - The Great British Bake Off: An Extra Slice)

Many people, particularly those with young kids, may feel pressured to provide an impressive celebration cake for an upcoming event such as a kid's birthday.  The pressures of social media and the demands of the honourary child place the parent in a difficult position, particularly for those without the skills to bake at home.

Non-bakers may look into sourcing a cake from a local supplier, however professionally made cakes can be very expensive, and are oriented more towards large celebrations such as weddings.  Such cakes are outside the budget of most people planning a smaller event, and may be considered overkill.  The aim this website aims to fill the gap by providing access to affordable home baked celebration cakes and other bakes.

The flipside of this situation is someone who DOES have the skills and time to bake at home, and is interested in making a bit of money from those skills. The home baker can post a listing called a "bake" on Bakester, to offer home baked celebration cakes or other items to the general community in exchange for payment.


### Target Audience

This web app aims to provide a marketplace solution to the above problems for two classes of users.

|User Type|Definition|
|---|---|
|Customers| People who want to buy a home made cake or other baked item rather than make it themselves, due to lack of ability, time etc.|
|Bakers|People who want to bake at home on behalf of others in exchange for payment.|

A third type of administrative user called an "Admin" is also part of the design for this web app, although this user does not necessarily participate in the marketplace.



## The Bakester Web App

Bakester was developed to provide a place for people to purchase home made bakes from other people.  The main use case for the site is the need for a celebration cake, such as a birthday cake for a child.  However, any type of home made baked item can be listed and ordered on the site. 

### Features

The website implements the following features:

<strong>General</strong>
- Neopolitan icecream colour scheme (chocolate, strawberry and vanilla) to add to the sweetness.
- Responsive design which adapts to mobile, tablet and desktop views.

<strong>Customers</strong>
- Card based layout to view available bakes
- Search / filter / sort function for the list of bakes. 
- Cart where bakes may be placed in order to prepare a list for checkout.
- Checkout function which finalises the cart into an order.
- Past orders page to keep track of orders and their progress
- Upgrade a "customer" account into a "baker" account which changes the UI

<strong>Bakers</strong>
- Add and edit bake listings
- Upload an image on a bake listing.  Images are stored in an Amazon S3 bucket.
- View my bakes, and manage their visibility to customers on the site.
- View my jobs, which are elements of customer orders containing a single bake.
- Receive a notification of new jobs at login
- Acknowledge recipt of a job, and update the status as it is produced and shipped.

<strong>Admin</strong>
- Manage many aspects of the site as if they were the owner.  For example
   - Create new categories
   - Moderate bakes for unacceptable user generated content.  Edit bakes, remove images, or delete bakes completetely if they are unreferenced in the database.
   - View all bakes, even if they are hidden.
   - View any user's cart and past orders.
   - View any baker's list of bake jobs, and edit their status.

### Sitemap

The following diagram represents a map of the main areas of the Bakester site and the typical flow of navigation between them.  The bold "Bakes" node is the root of the site, and all initial access to the site starts on this page, which includes a listing of all the bakes available for order.

![Bakester site map](docs/sitemap/bakester_sitemap.svg)

There are four shaded regions on the sitemap, which represent the three classes of user accessing the site and a fourth state where the user is not logged in.

Different parts of the site are available according to the users' status as follows:

#### Not Logged in
A user who is not logged in can the browse bakes available on the site, and add them to their cart, but cannot checkout without signing in.  They can also view other user profiles.

#### Logged in as User
When logged in as a standard user, the above features are available, and checkout functionality is added.  A user can also manage one's own account and view one's own past orders.  There is also a function available to upgrade one's account to "baker" status.

#### Logged in as Baker
After upgrading their account to a baker, the baker can access all of the above functions with the addition of creating and editing bake listings, and managing their own bake jobs.  

#### Logged in as Admin
An admin can access all of the above, with the addition of the ability to manage all users, categories, bakes, orders and bake jobs.

However, an admin is not automatically a baker, they too will need to upgrade their account to baker if they wish to create bakes and manage bakejobs in their own name.

### Tech Stack

Bakester uses a Ruby on Rails application framework.  All of the programming code is written in Ruby, and the individual web pages are written in html with embedded Ruby, preprocessed by the puma server and delivered to the browser as standard HTML.  Pages are styled using SCSS.

Bakester makes use the following additional components:
- Devise - a rails engine for login authorisation and user, session, and password management.
- Bootsrap - for styling and standardised features such as buttons, modal popup dialog boxes and tooltips.  Many of the standard bootstrap styles are customised and extended, in particular colours.
- JQuery - for a small amount of required client side scripting, including modal popups and tooltips.

Bakester is deployed to a Heroku on a free "Hobby Dev" level account.

### Walkthrough / Screenshots

We will following a typical user journey as they move through the site, create an account, use the features available to a user, upgrade their account to baker, and use the features available to a baker.  Following this the features available to an Admin will be presented.

#### New user first contact

When a new user first accesses the site, they are presented with the bakes list.  This is a vertical scrollable list of bakes presented on cards, which responsively adapts by expanding up to 3 columns wide.

On the mobile view, a hamburger menu replaces the navigation bar icons.  Pressing the hamburger button opens a drawer containing the navigation links

![Bakester main page](docs/screenshots/01_bakes_index_tablet_mobile_border.png)
Bakester main page on mobile and tablet.

![Bakester main page](docs/screenshots/01_bakes_index_desktop_border.png)
Bakester main page on desktop.

#### Navigation

On mobile view, the navigation menu expands downward once the hamburger is pressed, and displays additional options for a logged in user, a baker, and an admin (who is also a baker in this case).

Also visible in the below image are the badges added on the "cart" icon and "my jobs" icon, to indicate that there are items in the cart, or new jobs respectively.

![Bakester navigation on mobile](docs/screenshots/00_navigation_mobile.png)

On a tablet and desktop, the hamburger button disappears and is replaced by a horizontal list of icons.  The following image displays tablet view, but desktop is the same except for its width.

![Bakester navigation on tablet](docs/screenshots/00_navigation_tablet.png)

#### Search

On the bake listing page, a search form is available where the user can search by text, filter various properties of the bakes, and sort by any property in ascending or descending direction.  By default only the search text field, the category select box and the sort select boxes are visible, but clicking on the "Advanced Search" text expands the rest of the search form to show all available search and filter options.

![Bakester search form on mobile](docs/screenshots/05_search_mobile.png)
Bake search form on mobile.

![Bakester search form on tablet](docs/screenshots/05_search_tablet.png)
Bake search form on tablet.

![Bakester search form on desktop](docs/screenshots/05_search_desktop.png)
Bake search form on desktop.





#### View Bake

The user can click on a bake in the main list, and be taken to it's detail page to read the full description and view a larger image

![Bakester bake view mobile and tablet](docs/screenshots/02_bake_view_mobile_tablet.png)
Bake view page on mobile and tablet.
![Bakester bake view desktop](docs/screenshots/02_bake_view_desktop.png)
Bake view page on desktop.

#### View Cart

Once the user clicks "Add to Cart", the bake is added to their cart.  If they are not logged in this is handled by session storage, and for a logged in user it is stored in the database. After clicking on the navigation link to view their cart they will be presented with the view cart page.

![Bakester cart view mobile and tablet](docs/screenshots/03_cart_view_mobile_tablet.png)
Cart view page on mobile and tablet.
![Bakester cart view desktop](docs/screenshots/03_cart_view_desktop.png)
Cart view page on desktop.

#### Check Out

The user can then press the "Checkout" button, which after confirmation transforms the cart into an order and sends bake jobs to bakers.  After checking out, the user sees the new order confirmation.

![Bakester compelted order view on mobile and tablet](docs/screenshots/04_checkout_mobile_tablet.png)
Completed order page on mobile and tablet.
![Bakester completed order view on desktop](docs/screenshots/04_checkout_desktop.png)
Completed order page on desktop.

#### My Account

Links to upgrade to baker are provided on the navigation bar (see above).  The link can also be accessed from the "My Account" page, along with options to edit username, email and password.


![My account page on mobile](docs/screenshots/06_myaccount_mobile.png)
My account page on mobile.

![My account page on tablet](docs/screenshots/06_myaccount_tablet.png)
My account page on mobile.

![My account page on desktop](docs/screenshots/06_myaccount_desktop.png)
My account page on mobile.

#### My Bakes

After upgrading their account to a baker the user will be able to add a new bake using the "new bake" option in the navigation menu.  They will then be presented with the form for creating or editing bakes.


![Bake form on mobile](docs/screenshots/07_bake_form_mobile.png)
Bake form on mobile.

![Bake form on tablet](docs/screenshots/07_bake_form_tablet.png)
Bake form on tablet.

![Bake form on desktop](docs/screenshots/07_bake_form_desktop.png)
Bake form on desktop.

#### Edit a Bake

After the creating a new bake, it will appear with an "Edit" button instead of "Add to Cart" in all views. For example in desktop view it can be seen that the first of these three bakes is owned by the currently logged in baker and therefore can be edited:

![Edit button on bake card on desktop](docs/screenshots/08_edit_button_desktop.png)
Edit button on bake card on desktop.

Once the edit button is clicked the same form will be populated with that bake and can be edited.


![Bake edit on mobile](docs/screenshots/09_bake_edit_mobile.png)
Bake edit form on mobile.

![Bake edit on tablet](docs/screenshots/09_bake_edit_tablet.png)
Bake edit form on tablet.

![Bake edit on desktop](docs/screenshots/09_bake_edit_desktop.png)
Bake edit form on desktop.

#### Receiving a new job

If another user makes an order for a bake, a modal popup will appear to indicate this to the baker.





## Design Process

### User Stories

When designing the website and its functions, the following user stories were used to clarify the required funcitonality of the website.  In these defnitions, an "order" is what the customer creates, and a "job" is the task that the baker receives.


#### Customers

As a <strong>Customer</strong>...

|I want to...|So that i can...|
|---|---|
|Browse all bakes| see what bakes are available|
|Search and filter bakes | drill down to the types of bakes i am looking for|
|View a bake| see details about the bake and its description|
|Sign up for a new account| make orders for bakes|
|Log in to my account| see details of my past orders|
|Change my password | keep my account secure|
|Edit my account details | correct/update my name or email|
|Add a bake to my cart | build up a basket of bakes to order |
|Checkout | place an order with a baker|
|See my orders | keep track of the progress of my orders|
|View a User| see details of a user, in particular a baker's bakes|
|Become a baker| sell my home bakes on Bakester|


#### Bakers

As a <strong>Baker</strong>...

|I want to...|So that i can...|
|---|---|
|Do everything a customer can do|still act as a customer|
|Add a bake listing| start to receive customer orders for that bake|
|Add an image to a bake| make the bake more appealing to customers|
|Edit bake| update or correct details of my bakes|
|Hide a bake| temporarily prevent customers from placing an order|
|Delete a bake| permanently remove a bake |
|View my bakes| keep track of what bakes i am offering|
|Be notified of new jobs | i am aware of new jobs as soon as customers checkout|
|View my jobs| keep track of the customer orders that i need to fulfil|
|Update Job status| Track which jobs i have completed, and which are still pending|


#### Admin

As an <strong>Admin</strong>...

|I want to...|So that i can...|
|---|---|
|View categories| know what categories are provided for bakers to classify their bakes|
|Add a category| bakers can use it to classify their bakes|
|Edit a category| correct / update a category name|
|Delete a category| permanently remove a category from the site|
|Edit a bake| moderate content provided by bakers|
|Delete a bake| permanently remove a bake |
|See all users| know about all the users signed up on the site|
|Edit a user| change a user's name or email|
|Delete a user| close a user's account|
|See all orders | know about all the orders placed on the site|
|See the orders from a customer| investigate problems on behalf of a customer|
|See all jobs | know about all the jobs assigned to bakers|
|See all jobs for a particular baker| investigate problems on behalf of a baker|

### Project Management

To manage the creation of this site, a [trello board](https://trello.com/b/Uayp6SHv/bakester) was implemented.  Each user story above and many other design tasks were moved through four stages:

|Stage|Description|
|---|---|
|Backlog|A place for all tasks until they are prioritised
|Current| Tasks that are prioritised to be completed in the short term
|Work in Progress| The tasks that are currently being worked on
|Complete| Tasks that are finished and active on the site

![Trello Board](docs/trello/trello4.png)

Some features are not as yet implemented, and remain on the backlog, such as comments and ratings for users and bakes.


### Wireframes

The following wireframes were created to crystalise my vision of the layout of various core pages of the web site.  We will follow the journey of a new user through first access, signup, use of the site as a customer, and then use of the site as a baker.

#### Main page

When the user first accesses the site, they will be presented with a screen containing all of the bakes that are available on the site.  Sign up or log in is not required to view this list.  A grid of cards is presented, each linking to a bake's own page.  A search / filter / sort form is provided to customise the listing.  


![Main bakes page - mobile and tablet](docs/wireframes/01_bakes_mobile_tablet.svg)
Main bakes page - mobile and tablet

![Main bakes page - desktop](docs/wireframes/01_bakes_desktop.svg)
Main bakes page - desktop

To navigate the site on desktop and tablet, a navigation bar is provided at the top of the page with a horizontal list of links.  In the mobile view, the navigation bar is compacted and a hamburger button replaces the horizontal list, and when activated displays a drawer containing the same links.

#### Sign Up

After deciding to become an active user of the site, the user can sign up


![Signup page - mobile and tablet](docs/wireframes/02_signup_mobile_tablet.svg)
Main bakes page - mobile and tablet

![Signup page - desktop](docs/wireframes/02_signup_desktop.svg)
Main bakes page - desktop

#### View Bake

For more detail on a particular bake, a user can click on it and access a detail page


![Bake - mobile and tablet](docs/wireframes/03_bake_mobile_tablet.svg)
Bake page - mobile and tablet

![Bake - desktop](docs/wireframes/03_bake_desktop.svg)
Bake page - desktop

#### Cart

A bake can be added to cart from either the card on the bakes list, or a bake detail page.  The cart page shows the bakes currently in the users cart.

![Cart - mobile and tablet](docs/wireframes/04_cart_mobile_tablet.svg)
Cart page - mobile and tablet

![Cart - desktop](docs/wireframes/04_cart_desktop.svg)
Cart page - desktop

#### Edit Bake

After upgrading their account to a baker, the user is now classed a "baker" and is able to create or edit their own bakes.  A form is provided including functionality to upload an image.


![Edit Bake - mobile and tablet](docs/wireframes/05_bake_edit_mobile_tablet.svg)
Edit Bake page - mobile and tablet

![Edit Bake - desktop](docs/wireframes/05_bake_edit_desktop.svg)
Edit Bake page - desktop

The navigation menu has changed and more options are available to a baker to manager their bakes listed on the site


#### Bake Jobs

Once a user has made an order for a baker's bake, the baker is notified they have a new bake job.  The baker can view the list of their bake jobs to manage their tasks.


![Bake Jobs - mobile and tablet](docs/wireframes/06_bakejobs_mobile_tablet.svg)
Bake Jobs page - mobile and tablet

![Bake Jobs - desktop](docs/wireframes/06_bakejobs_desktop.svg)
Bake Jobs page - desktop


#### Edit Bake Job

A baker can edit the status of their bake jobs to keep track of what is pending, and also keep the customer updated.


![Edit Bake Job - mobile and tablet](docs/wireframes/07_bakejob_edit_mobile_tablet.svg)
Edit Bake Job page - mobile and tablet

![Edit Bake Job - desktop](docs/wireframes/07_bakejob_edit_desktop.svg)
Edit Bake Job page - desktop







# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...