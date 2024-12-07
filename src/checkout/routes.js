const express = require("express")
router = express.Router()

router.get("/", (req, res)=>{
    res.json({message:"Welcome to Checkout service!"})
})

router.get("/heavy-task", (req, res) => {
    setTimeout(() => {
        res.json({ message: "heavy task completed!" })
    }, (10000));
})

module.exports = {router}

