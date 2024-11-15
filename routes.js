const express = require("express")
router = express.Router()
router.get("/health", (req, res) => {
    res.json({ message: "hello world" })
})

router.get("/heavy-task", (req, res) => {
    setTimeout(() => {
        res.json({ message: "heavy task completed!" })
    }, (10000));
})

module.exports = {router}

