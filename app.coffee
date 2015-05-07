# External
cors    = require('cors')
express = require('express')
# Internal
config  = require('./config.json')
binder  = require('./binder')
# Create a simple express app
app = do express
# Configure the application
app.configure ->
    # This application allows CORS
    app.use cors()
    app.get "/", (req, res)-> res.jsonp config
    # Each logo has is own configuration
    for slug, logo of config
        # Create a unique path for this loho
        path = "/#{slug}/"
        # Each colors is a different parameter
        for color, idx in logo.colors
            path += ":param#{idx}?/?"
        # Function to bind the given path to the app
        binder app, path, slug
# Then start listening
server = app.listen process.env.PORT or 3000
