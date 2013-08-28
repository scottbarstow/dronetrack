Drone = require("../..").Drone
path = require "path"
config = require "../config"

drone = new Drone(config.baseUrl, config.accessToken)

createDrone = ->
    before (done)->
            drone.create {name: "new Drone"}, (err, i)=>
                return done err if err?  
                @droneId = i.id
                done()
    after (done)->
        drone.remove @droneId, done


describe "Drone", ->
    
    describe "all()", ->
        it "should return all drone records of current user", (done)->
            drone.all (err, items)->
                return done err if err?
                Array.isArray(items).should.be.true
                done()
    
    describe "create()", ->
        it "should create new drone", (done)->
            drone.all (err, items)->
                return done err if err?
                count = items.length
                drone.create {name: "new Drone"}, (err, item)->
                    return done err if err?
                    item.id.should.be.ok
                    item.name.should.equal "new Drone"
                    drone.all (err, items)->
                       return done err if err?
                       items.length.should.equal count+1
                       done()
    describe "get()", ->
        it "should return drone with given id", (done)->
            drone.create {name: "new Drone"}, (err, i)->
                return done err if err?     
                drone.get i.id, (err, item)->
                    return done err if err?     
                    item.id.should.equal i.id
                    item.name.should.equal i.name
                    done()
                    
        it "should fail if drone is not exists", (done)->
            drone.get "id", (err, item)->
                err.should.be.ok
                done()
    
    describe "update()", ->
        it "should update drone with given id", (done)->
             drone.create {name: "new Drone"}, (err, i)->
                return done err if err?  
                drone.get i.id, (err, item)->
                    return done err if err?     
                    name=  "Name#{Math.random()}"
                    item.name.should.not.equal name
                    item.name = name
                    drone.update item, (err, it)->
                        return done err if err?     
                        it.name.should.equal name
                        drone.get i.id, (err, it)->
                            return done err if err?     
                            it.name.should.equal name
                            done()
                    
        it "should fail if drone is not exists", (done)->
            drone.update {id: "id", name:"Drone"}, (err, item)->
                err.should.be.ok
                done()            
    
    describe "remove()", ->
        it "should remove drone with given id", (done)->
             drone.create {name: "new Drone"}, (err, i)->
                return done err if err?  
                drone.all (err, items)->
                    return done err if err?  
                    count = items.length
                    drone.remove i.id, (err)->
                        return done err if err?  
                        drone.all (err, items)->
                            return done err if err?  
                            items.length.should.equal count-1
                            done()
                    
        it "should fail if drone is not exists", (done)->
            drone.remove "id",  (err, item)->
                err.should.be.ok
                done()      

    describe "addPoints()", ->
        createDrone()
        it "should create new track and add points to it if trackId is missing", (done)->
            drone.addPoints @droneId, [{latitude: 1, longitude: 1}, {latitude: 2, longitude: 2}], (err, res)->
                return done err if err?  
                res.trackId.should.be.ok
                done()
        it "should add points to exisiting track", (done)->
            drone.addPoints @droneId, [{latitude: 1, longitude: 1}, {latitude: 2, longitude: 2}], (err, res)=>
                return done err if err?  
                trackId = res.trackId
                trackId.should.be.ok
                drone.addPoints @droneId, trackId, [{latitude: 3, longitude: 3}, {latitude: 4, longitude: 4}], (err, res)=>
                    return done err if err?  
                    res.trackId.should.equal trackId
                    done()        

        it "should fail for non-exising drone", (done)->
            drone.addPoints "id", [{latitude: 1, longitude: 1}, {latitude: 2, longitude: 2}], (err, res)=>
                err.should.be.ok
                done()

        it "should fail for non-exising track", (done)->
            drone.addPoints @droneId, "trackId", [{latitude: 1, longitude: 1}, {latitude: 2, longitude: 2}], (err, res)=>
                err.should.be.ok
                done() 

    describe "importPointsFromFiles()", ->                     
        createDrone()
        it "should create new tracks and add points for each csv file", (done)->
            files = [path.join(__dirname, "test1.csv"), path.join(__dirname, "test2.csv")]
            drone.importPointsFromFiles @droneId, files, "csv", (err, res)->
                return done err if err?
                done()
        it "should create new tracks and add points for each kml file", (done)->
            files = [path.join(__dirname, "test1.kml")]
            drone.importPointsFromFiles @droneId, files, "kml", (err, res)->
                return done err if err?
                done()       
