const crypto = require('crypto');
const axios = require('axios');

const getQuotedPrice = () => {
    return axios({
        method: 'post',
        url: process.env.PUBLIC_PATH + 'v2/public/c2c/adv/quoted-price',
        data: {
            assets: [
                "USDT",
            ],
            fiatCurrency: "VND",
            tradeType: "SELL",
            fromUserRole: "USER",
        }
    });
}

const getCommissionRate = () => {
    return axios({
        method: 'post',
        url: process.env.PUBLIC_PATH + 'v1/friendly/c2c/commission-rate/taker',
        data: {
            "channel": "c2c",
            "area": "express",
            "asset": "USDT",
            "fiat": "VND"
        }
    });
}

const getFiatTransLimit = () => {
    return axios({
        method: 'post',
        url: process.env.PUBLIC_PATH + 'v1/public/c2c/portal/fiat-trans-limit',
        data: {
            "area": "express",
            "asset": "USDT",
            "fiat": "VND",
            "tradeType": "SELL"
        }
    });
}


module.exports = { getQuotedPrice, getCommissionRate, getFiatTransLimit }