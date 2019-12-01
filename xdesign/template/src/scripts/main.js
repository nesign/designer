const $ = require('jquery');
const jQuery = $;
const bootstrap = require('bootstrap');

const isVideo = function (url) {
  return url && url.startsWith('https://youtube.com/')
    || url.startsWith('https://www.youtube.com/')
    || url.startsWith('https://youtu.be/');
}

document.addEventListener('invite', (event) => {
  const invite = event.detail;
  if (invite) {
    // Loaded invite { addrText: "3366 Demo Street, Demo City, CA - 94583", addrUrl: "https://www.google.com/search?q=3366%20Demo%20Street,%20Demo%20City,%20CA%20-%2094583", bgPhoto: {url: "https://i.imgur.com/bCGCTrB.jpg"}, hostName: "Mr. & Mrs. Demo", longMsg: "It's **Demo's** _birthday_,↵↵and we're all very _excited_.↵↵For this special _funday_,↵↵you are cheerfully _invited_.", mainPhoto: {url: "https://i.imgur.com/LiQ7lSI.jpg"}, nesign: "a00001", photos: (3) [{…}, {…}, {…}], shortMsg: "You are invited!", timeFrom: moment, timeFromString: "Friday, December 25, 2020 7:00 PM", timeTo: moment, timeToString: "Friday, December 25, 2020 11:00 PM", title: "Demo is turning 3", tz: "America/Los_Angeles"}
  }
}, false);

document.addEventListener('guest', (event) => {
  const guest = event.detail;
  if (guest) {
    // Loaded guest { adultCount: 2, email: "guestemailid@gmail.com", hostApproved: true, kidCount: 3, name: "Guest Name", notifyUpdates: true, role: "GUEST", rsvp: "Y" }
  }
}, false);