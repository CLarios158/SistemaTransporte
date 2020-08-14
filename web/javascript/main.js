document.addEventListener('DOMContentLoaded', function() {
    fixMainHeight();

    window.addEventListener('resize', function(){
        fixMainHeight();
    });
});

function fixMainHeight() {
    if(window.innerHeight < document.body.offsetHeight) {
        const mainSlideMenu = document.getElementsByClassName('main-slide-menu')[0];
        const mainContainer = document.getElementsByTagName('main')[0];
        
        if(!mainSlideMenu || !mainContainer) return;
        
        const mainSlideMenuHeight = mainSlideMenu.offsetHeight;
        
        mainContainer.style.minHeight = mainSlideMenuHeight+"px";
    }
}