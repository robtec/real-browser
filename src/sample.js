import { connect } from 'puppeteer-real-browser'

connect({
    tf: true, // If a feature you want to use at startup is not working, you can initialize the tf variable false and update it later.
    turnstile: true
})
.then(async response => {
        const { page, browser, setTarget } = response

        page.goto('https://nopecha.com/demo/cloudflare', {
            waitUntil: 'domcontentloaded'
        })

        setTarget({ status: false })

        let page2 = await browser.newPage();

        setTarget({ status: true })

        await page2.goto('https://nopecha.com/demo/cloudflare');
})
