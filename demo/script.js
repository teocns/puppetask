const puppeteer = require('puppeteer');
const process = require('process');
// Get WS_URL from env variable
const WS_URL = process.env.WS_URL;
const opts = async () => {
  // Connect to existing Chrome instance
  const browser = await puppeteer.connect({ browserWSEndpoint: WS_URL, protocolTimeout: 0, dumpio:true });
  console.log('connected')

  //const page = await browser.newPage();
  const pages = await browser.pages();

  console.log(pages.length)
  let page;
  if (!page){
    page = await browser.newPage();
  }




  await page.setRequestInterception(true);


  await page.goto('http://www.google.com/search?q=what+is+my+ip');

  console.log('Finished navigating')


  
};


opts().then().catch(console.error);




