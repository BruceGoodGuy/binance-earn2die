<!DOCTYPE html>
<html lang="en" class="h-100">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${d.title}</title>
    <link rel="stylesheet" href="/stylesheets/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="stylesheets/style.css" />
</head>

<body class="d-flex flex-column h-100 bg-dark text-white">
    <header class="py-3">
        <div class="container">
            <div class="wrap-nav d-flex justify-content-center gap-3">
                <a class="link-underline link-underline-opacity-0 link-underline-opacity-75-hover fw-bold" href="">
                    <span class="text-gold">E2D</span>
                </a>
                <a class="link-underline link-underline-opacity-0 link-underline-opacity-75-hover text-white"
                    href="">About</a>
            </div>
        </div>
    </header>
    <main class="container flex-shrink-0 flex-grow-1">
        <div class="row mx-auto my-auto justify-content-center align-items-center h-100">
            <div class="wrapper px-0 px-lg-3">
                <div class="col-12 text-center">
                    <h5>USDT > VND <span class="text-gold">BINANCE</span></h5>
                </div>
                <div class="col-lg-8 col-12 mx-auto">
                    <div class="card bg-transparent border-0">
                        <div class="card-body text-white px-0 px-lg-3">
                            <div class="border border-white px-3 py-5 rounded-4 border-3 position-relative">
                                <div class="loading w-100 h-100 bg-dark position-absolute rounded-4">
                                    <div class="d-flex justify-content-center align-items-center h-100">
                                        <div class="spinner-border text-gold" role="status">
                                            <span class="visually-hidden">Loading...</span>
                                        </div>
                                    </div>
                                </div>
                                <h6 class="card-subtitle mb-2 text-white text-end">Nhập USDT</h6>
                                <div class="wrap-input position-relative">
                                    <input type="number" maxlength="15"
                                        class="form-control bg-transparent border-0 text-gold border-bottom h-50px rounded-0 fs-2 ps-0 pe-5 text-end"
                                        id="money" name="money" placeholder="0 - 0">
                                    <span class="position-absolute currency-symbol">USDT</span>
                                </div>
                                <div class="wrap-info d-flex justify-content-end mt-3">
                                    <div class="d-flex flex-column wrap-al position-relative">
                                        <div class="wrap">
                                            <div class="text-end">
                                                <span class="usdt-format">0</span>
                                                <p class="symbol d-inline-block">USDT</p>
                                            </div>
                                        </div>
                                        <div class="text-end">
                                            <span>-</span>
                                            <span class="sub-usdt-format">0</span>
                                            <p class="symbol d-inline-block">USDT</p>
                                        </div>
                                        <div class="border-bottom pb-1 text-end">
                                            <span>x</span>
                                            <span class="rate-vnd-format">0</span>
                                            <p class="symbol d-inline-block">VND</p>
                                        </div>
                                        <div class="result mt-1 text-end">
                                            <span class="text-gold result-format fs-2 ">
                                                0
                                            </span>
                                            <p class="symbol d-inline-block fs-9">VND</p>
                                        </div>
                                    </div>
                                </div>
                                <div class="wrap-info d-flex justify-content-between mt-3 fs-9">
                                    <div class="d-flex flex-column">
                                        <span>Giá ước tính</span>
                                        <span data-price="25890">1 USDT ≈ <span>0</span> VND</span>
                                    </div>
                                    <div class="d-flex flex-column">
                                        <span>Phí</span>
                                        <span data-fee="0.001">0.1000%</span>
                                    </div>
                                    <span>
                                        Thời gian:
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
    <footer class="footer mt-auto py-3 text-center">
        <span class="text-white">@Bruce 2024</span>
    </footer>
    <script src="javascripts/axios.min.js"></script>
    <script>
        let response = {};
        const moneyInput = document.querySelector('input[name="money"]');
        const usdtFormatEl = document.querySelector('span.usdt-format');
        const feeEl = document.querySelector('span.sub-usdt-format');
        const rateEl = document.querySelector('span.rate-vnd-format');
        const resultEl = document.querySelector('span.result-format');
        const feeTransEl = document.querySelector('span[data-fee]');
        const rateHintEl = document.querySelector('span[data-price] span');

        // Format the price above to USD using the locale, style, and currency.
        const USDollar = new Intl.NumberFormat('en-US', {
            style: 'currency',
            currency: 'USD',
            maximumFractionDigits: 10,
            minimumFractionDigits: 0,
        });

        const VNDong = new Intl.NumberFormat('vi-VN', {
            style: 'currency',
            currency: 'VND',
            maximumFractionDigits: 10,
            minimumFractionDigits: 0,
        });


        document.addEventListener("DOMContentLoaded", async (event) => {
            try {
                const { data } = await axios.get('http://localhost:3000/ajax/init');
                const trans = data?.trans.data.transLimits.filter(o => o.buyType === "BY_AMOUNT")[0];
                response.quotedPrice = data?.quoted?.data[0]?.referencePrice ?? 0;
                response.taker = data?.taker.data.filter(o => o.tradeType === 'SELL')[0]?.commissionRate;
                response.trans = { min: trans.lowerLimit, max: trans.upperLimit };
                moneyInput.setAttribute('placeholder', response.trans.min + ' - ' + response.trans.max);
                const formatQuetedPrice = USDollar.format(response.quotedPrice).replace('$', '');
                rateEl.innerText = formatQuetedPrice;
                rateHintEl.innerText = formatQuetedPrice;
                feeTransEl.innerText = response.taker * 100 + '%';
                moneyInput.addEventListener('input', calculate);
            } catch (err) {
                console.log(err);
            }
            document.querySelector('.loading').classList.add('d-none');
        });

        function calculate(event) {
            const input = event.target;
            // Get the value without any non-numeric characters
            const value = input.value.replace(/e/g, '');
            if (value.length > 15) {
                input.value = value.slice(0, 15);
                return;
            }
            const feeCharge = value * response.taker;
            // The formated version of 14340 is $14,340.00
            // Update the input value with the formatted currency
            usdtFormatEl.innerText = USDollar.format(value).replace('$', '');
            feeEl.innerText = USDollar.format(feeCharge).replace('$', '');
            rateEl.innerText = VNDong.format(response.quotedPrice).replace('₫', '').trim();
            resultEl.innerText = VNDong.format((value - feeCharge) * response.quotedPrice).replace('₫', '').trim();
        }
    </script>
</body>

</html>