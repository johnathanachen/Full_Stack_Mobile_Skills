import Foundation

//: ## URL & URLComponents
//: ### URL from String
let urlString = "https://itunes.apple.com/search?media=music&entity=song&term=abba"
let url = URL(string: urlString)
url?.absoluteString
url?.scheme
url?.host
url?.path
url?.query
url?.baseURL



//: `baseURL` is useful for building REST API urls.
let baseURL = URL(string: "https://itunes.apple.com")
let relativeURL = URL(string: "search", relativeTo: baseURL)
relativeURL?.absoluteString
relativeURL?.scheme
relativeURL?.host
relativeURL?.path
relativeURL?.query
relativeURL?.baseURL



//: ### URLComponents & URL-encoding
var urlComponents = URLComponents(string: "https://itunes.apple.com/search?media=music&entity=song")
let queryItem = URLQueryItem(name: "term", value: "crowded house")
urlComponents?.queryItems?.append(queryItem)
urlComponents?.url



//: URL-encode "smiling cat face with heart-shaped eyes"
queryItem = URLQueryItem(name: "emoji", value: "🐱")
urlComponents?.url



