const express = require("express")
router = express.Router()

router.get("/", (req, res) => {
    res.json({ message: "Welcome to Canary Home service!" })
})

module.exports = { router }

