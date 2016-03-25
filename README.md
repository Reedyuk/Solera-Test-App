Solera-Test-App
=========
The app was implemented as per the requirements stated in the Document.

Requirements :
=========

1. Write a mobile application and associated unit tests that can price a basket of goods in a number of different currencies.
2. The goods that can be purchased, which are all priced in US$, are:
  - Peas : $ 0,95 per bag
  - Eggs : $ 2,10 per dozen
  - Milk : $ 1,30 per bottle
  - Beans : $ 0,73 per can
3. The program shall allow the user to add or remove items in a basket.
4. The user can click on a checkout button, which will then display the total price for the basket with the option to display the amount in different currencies.
5. The list of currencies shall be consumed from http://jsonrates.com/currencies.json
  

Implementation
=========
1. The app was developed using ObjC and Storyboards. 
2. Hard-coded Array of dictionaries was used to store the details of the products. In real-life circumstances, this data must be fetched from the server.
3. On the Product details screen, the user can select the quantity of the items and then tap on the "Add to Cart" button to add the product to the cart.
4. As per my understanding, for a Shopping Cart app such as this, Currency is supposed to be constant all through the app. Hence currency selection was implemented on the Main Screen. Tapping on the button pops up the complete list of Currency Locale codes. Selecting any locale enforces it all through the app, Products List, Product Details Screen as well as on the Shopping Cart.
5. JSONRates.com has been integrated with CurrencyLayer, hence the API provided by CurrencyLayer was used in the app.

Libraries Used
=========
1. AFNetworking - for Async Http requests
2. SDWebImage   - for loading Asynchronously in the TableView 
