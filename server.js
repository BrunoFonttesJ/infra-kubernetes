const express = require("express")
const { router } = require("./routes")
const app = express()
const PORT = 3000

app.use(express.json())

app.use("/api", router)


const server = app.listen(PORT, () => {
    console.log(`Running on port ${PORT}`);
})

process.on("SIGINT", gracefulShutdownHandler) // ctrl + c singal
process.on("SIGTERM", gracefulShutdownHandler) // docker system level termination signal

function gracefulShutdownHandler(signal) {
    console.info(`caught ${signal}, gracefully shutting down`);

    server.close(() => {
        console.info("all requests stopped, shutting down")
        // Perform cleanup tasks here
        // i.e: close database connections 
        process.exit()
    })
}
