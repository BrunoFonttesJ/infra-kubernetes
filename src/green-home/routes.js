const express = require("express")
router = express.Router()

router.get("/", (req, res) => {
    res.json({ message: "Welcome to Green Home service!" })
})

module.exports = { router }

