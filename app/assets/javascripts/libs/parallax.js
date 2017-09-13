var paraEls = document.getElementsByClassName("js-parallax");
var yScrollPosition;
var scrollInterval;
var scrollTop;

window.addEventListener("DOMContentLoaded", scrollLoop, false);

function scrollLoop() {
    yScrollPosition = window.scrollY;
    for(i=0;i<paraEls.length;i++) {
        setTranslate(paraEls[i].dataset.speed, paraEls[i]);
    }
    requestAnimationFrame(scrollLoop);
}

function setTranslate(ySpeed, el) {
    wrapperTop = el.parentElement.offsetTop;
    wrapperBottom = wrapperTop + el.parentElement.offsetHeight;
    viewport = yScrollPosition + window.innerHeight;

    if ( viewport >= wrapperTop && yScrollPosition <= wrapperBottom &&  window.innerWidth >= 1024 ) { 
        // Check the parallax elements parent/wrapper is in viewport and we're on a bigg'ish screen
        el.style.transform = "translate3d( 0, " + (viewport-wrapperTop)*ySpeed + "px, 0)";
    }
}