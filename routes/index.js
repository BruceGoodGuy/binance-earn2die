var express = require('express');
var router = express.Router();
var binanceAPI = require('./../utils/binance');
require('dotenv').config()

/* GET home page. */
router.get('/', function (req, res, next) {
  res.render('index', { title: 'Earn to die' });
});

router.get('/ajax/init', async function (req, res, next) {
  try {
    const [quotedPrice, taker, transFiat] = await Promise.all([
      binanceAPI.getQuotedPrice(),
      binanceAPI.getCommissionRate(),
      binanceAPI.getFiatTransLimit(),
    ]);


    return res.json({ success: true, quoted: quotedPrice.data, taker: taker.data, trans: transFiat.data });
  } catch (error) {
    console.log(error);
    return res.json({ success: false, msg: error + '' }, 500);
  }
});

module.exports = router;
