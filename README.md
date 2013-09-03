# Dronetrack API

This is a simple node module for integrating with the Dronetrack  API

# Pre-Requisites and Installation
## Prerequisites

You will need to create an account on Dronetrack and get clientId, clientSecret and redirect url to receive access token value.

## Installation 
```shell
npm install dronetrack

```

---

# Using Dronetrack Client

```
var dronetrack = require('dronetrack');
```

## Drone

Type Drone allows user to manage user's drones

```
var droneApi = new dronetrack.Drone('baseUrl', 'accessToken'); //you can get accessToken with dronetrack.OAuthHelper

```

### Getting drones
```
droneApi.all(function(err, drones){...});
```

### Getting drone by id
```
droneApi.get(id, function(err, drone){...});
```

### Creating drone
```
droneApi.create({name: 'name'}, function(err, drone){...});
```

### Updating drone
```
droneApi.update({id: id, name: 'name'}, function(err, drone){...});
```

### Removing drone
```
droneApi.remove(id, function(err){...});
```

### Adding points to new or exisiting track of drone
```
// Adding points to new track
droneApi.addPoints(id, [{latitude: latitude, longitude: longitude, timestamp: timestamp}, ...], function(err, res){ /* res.trackId will be contain id of created track */...}); 

// Adding points to exisiting track
droneApi.addPoints(id, trackId, [{latitude: latitude, longitude: longitude, timestamp: timestamp }, ...], function(err){...}); 

```

### Import points from CSV or KML files to new tracks of drone

```
// Import points to new tracks from csv files
// New track will be created for each file. File name  without extension will be used as track name.
droneApi.importPointsFromFiles(id, ['/path/to/file1', ...], 'csv' function(err){...}); 

// Import points to new tracks from kml files
droneApi.importPointsFromFiles(id, ['/path/to/file1', ...], 'kml' function(err){...}); 


```


## Track

Type Track allows user to manage tracks tracks

```
var trackApi = new dronetrack.Track('baseUrl', 'accessToken'); //you can get accessToken with dronetrack.OAuthHelper

```

### Getting tracks
```
trackApi.all(function(err, tracks){...});
```

### Getting track by id
```
trackApi.get(id, function(err, track){...});
```

### Creating track
```
trackApi.create({name: 'name', deviceId: droneId}, function(err, track){...});
```

### Updating track
```
trackApi.update({id: id, name: 'name'}, function(err, track){...});
```

### Removing track
```
trackApi.remove(id, function(err){...});
```

### Getting points
```
trackApi.getPoints(id, function(err, points){...});
```

### Adding points to track
```
trackApi.addPoints(id, [{latitude: latitude, longitude: longitude, timestamp: timestamp}, ...], function(err, points){...}); 

```

### Import points from CSV or KML files to  track

```
// Import points to new tracks from csv files
// All exisiting points will be overwriten
trackApi.importPointsFromFiles(id, ['/path/to/file1', ...], 'csv' function(err){...}); 

// Import points to new tracks from kml files
trackApi.importPointsFromFiles(id, ['/path/to/file1', ...], 'kml' function(err){...}); 


```

## OAuthHelper

Dronetrack API uses OAuth 2.0 to authorize user. To get access token you can use type  OAuthHelper

```
var auth = new dronetrack.OAuthHelper('baseUrl', 'clientId', 'clientSecret', 'redirectUrl'); // you must receive clientId, clientSecret and redirectUrl from Dronetrack site
```

### Getting OAuth 2.0 access token

```
auth.getAccessToken(function(url, callback){
    // You should redirect to this 'url' (for web apps) or open this 'url' in browser (for other apps)
    // User will sign in on Dronetrack site (if need) and confirm decision to allow your app to work with Dronetrack API.
    // Then Dronetrack site will redirect user to 'redirectUrl' putting pin code value as query parameter 'code' (for web apps)
    // If your 'redirectUrl' is 'http://localhost' (for non-web apps) pin code will be shown to user. You should promt to enter this value by user.
    // Anyway you should pass this code as second parameter of callback function (like callback(null, code);)
}, function(err, accessToken));

//You should save accessToken value to use it in future.

```