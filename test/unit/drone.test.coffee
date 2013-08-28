Drone = require("../..").Drone

config = require "../config"

drone = new Drone(config.baseUrl, config.accessToken)
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
            drone.get {id: "id", name:"Drone"}, (err, item)->
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
