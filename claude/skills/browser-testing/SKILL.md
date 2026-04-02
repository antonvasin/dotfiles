--
name: browser-testing
description: Tests code in browser. Use when making visual changes to frontend code.
--

After finishing making changes to visual frontend code test them in browser:

1. Check whether dev server is running on local 8000 port, if already
   running navigate to it. If https is not available try http protocol.
2. If dev server is not running, run it in background, wait for it to be
   available and navigate browser to it.
3. Test changes by simulating user behaviour in browser.
4. When making changes to styles that affect more than one viewport, make sure
   to test with mobile, tablet and desktop breakpoints.
