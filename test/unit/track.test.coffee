lib = require("../..")
Track = lib.Track
Drone = lib.Drone
path = require "path"
config = require "../config"
auth = require "./auth"


createSimpleTrack = (accessToken, done)->
    drone = new Drone(config.baseUrl, accessToken)
    track = new Track(config.baseUrl, accessToken)
    drone.create {name: "new Drone"}, (err, d)=>
        return done err if err?
        track.create {name: "new Track", deviceId: d.id}, (err, i)=>
            return done err if err?  
            done(null, i)

createTrack = ->
    before (done)->
        createSimpleTrack @accessToken, (err, t)=>
            return done err if err?
            @trackId = t.id
            @droneId = t.deviceId
            done()
            
    after (done)->
        drone = new Drone(config.baseUrl, @accessToken)
        drone.remove @droneId, done


describe "Track", ->
    auth.authorize()
    before ->
        @track = new Track(config.baseUrl, @accessToken)

    describe "all()", ->
        it "should return all track records of current user", (done)->
            @track.all (err, items)=>
                return done err if err?
                Array.isArray(items).should.be.true
                done()
    
    describe "create()", ->
        it "should create new track", (done)->
            @track.all (err, items)=>
                return done err if err?
                count = items.length
                createSimpleTrack @accessToken, (err, t)=>                
                    return done err if err?
                    t.id.should.be.ok
                    t.name.should.equal "new Track"
                    @track.all (err, items)=>
                       return done err if err?
                       items.length.should.equal count+1
                       done()
    describe "get()", ->
        it "should return track with given id", (done)->
            createSimpleTrack @accessToken, (err, i)=>
                return done err if err?     
                @track.get i.id, (err, item)=>
                    return done err if err?     
                    item.id.should.equal i.id
                    item.name.should.equal i.name
                    done()
                    
        it "should fail if track is not exists", (done)->
            @track.get "id", (err, item)=>
                err.should.be.ok
                done()
    
    describe "update()", ->
        it "should update track with given id", (done)->
             createSimpleTrack @accessToken, (err, i)=>
                return done err if err?  
                @track.get i.id, (err, item)=>
                    return done err if err?     
                    name=  "Name#{Math.random()}"
                    item.name.should.not.equal name
                    item.name = name
                    @track.update item, (err, it)=>
                        return done err if err?     
                        it.name.should.equal name
                        @track.get i.id, (err, it)=>
                            return done err if err?     
                            it.name.should.equal name
                            done()
                    
        it "should fail if track is not exists", (done)->
            @track.update {id: "id", name:"Track"}, (err, item)=>
                err.should.be.ok
                done()            
    
    describe "remove()", ->
        it "should remove track with given id", (done)->
             createSimpleTrack @accessToken, (err, i)=>
                return done err if err?  
                @track.all (err, items)=>
                    return done err if err?  
                    count = items.length
                    @track.remove i.id, (err)=>
                        return done err if err?  
                        @track.all (err, items)=>
                            return done err if err?  
                            items.length.should.equal count-1
                            done()
                    
        it "should fail if track is not exists", (done)->
            @track.remove "id",  (err, item)=>
                err.should.be.ok
                done()      

    describe "addPoints()", ->
        createTrack()
        it "should add points", (done)->
            @track.addPoints @trackId, [{latitude: 1, longitude: 1}, {latitude: 2, longitude: 2}], (err, res)=>
                return done err if err?  
                Array.isArray(res).should.be.true
                (res.length >=2).should.be.true
                done()        

        it "should fail for non-exising track", (done)->
            @track.addPoints "id", [{latitude: 1, longitude: 1}, {latitude: 2, longitude: 2}], (err, res)=>
                err.should.be.ok
                done()

    describe "importPointsFromFiles()", ->                     
        createTrack()
        it "should create new tracks and add points for each csv file", (done)->
            files = [path.join(__dirname, "test1.csv"), path.join(__dirname, "test2.csv")]
            @track.importPointsFromFiles @trackId, files, "csv", (err, res)=>
                return done err if err?
                done()
        it "should create new tracks and add points for each kml file", (done)->
            files = [path.join(__dirname, "test1.kml")]
            @track.importPointsFromFiles @trackId, files, "kml", (err, res)=>
                return done err if err?
                done()       


    describe "getPoints()", ->
        createTrack()
        it "should return points of the track", (done)->
            @track.addPoints @trackId, [{latitude: 1, longitude: 1}, {latitude: 2, longitude: 2}], (err, res)=>
                return done err if err?  
                @track.getPoints @trackId, (err, pts)=>
                    return done err if err?  
                    Array.isArray(pts).should.be.true
                    (pts.length >= 2).should.be.true
                    done()        

            
