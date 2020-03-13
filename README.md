# New York Times Best Sellers 
### Your Favorite New York Times Best Sellers Books

- The app architecture is MVC and follows Cocoa design patterns whenever fit.

- All networking are done via the singleton class of `NetworkManager`, which is a unified access point to make HTTP requests. And each type of request is done via a dedicated method. This class handles caching as well.

- Date fetched over [Book API](https://developer.nytimes.com/docs/books-product/1/overview).

- There are 2 options for sorting the results:
1. Ranking: Ascending order (e.g. book with ranking 1 is on the top)
2. Weeks on List: Descending (e.g. book made it to the list for the longest time is on the top)

- All images are cached locally (this might not work in the simulator, as the absolute path on disk is always randomly generated for the "tmp" folder for the user)
