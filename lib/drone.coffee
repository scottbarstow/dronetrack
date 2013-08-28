RestService = require "./restService"

class Drone extends RestService
    constructor: (@baseUrl, @accessToken)->
        super("/drone")

    addPoints: (id, trackId=null, points, callback)->    
        @createRequest("#{@url}/#{id}/points", "post").send({trackId: trackId, points: (points || [])}).end(@processResult.bind(this, callback))

    importPointsFromFiles: (id, files, format, callback)->    
        format = format.toUpperCase()
        if format != "CSV" && format != "KML"
            return callback new Error("Format #{format || '<null>'} is not supported")   
        r = @createRequest("#{@url}/#{id}/import#{format}", "post")
        i = 1
        for file in files
            r = r.attach("file#{i}", file)
            i += 1
        r.end(@processResult.bind(this, callback)) 

module.exports = Drone        