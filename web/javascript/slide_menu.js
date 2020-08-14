const slideMenuBtns = document.querySelectorAll('[data-toggle="slide-menu"]');

slideMenuBtns.forEach(element => {
    const slideMenu = document.querySelector(element.dataset.target);
    element.addEventListener("click", (e) => {
        e.preventDefault();
        togleSlideMenu(slideMenu);
    });
});

const togleSlideMenu = (slideMenu) => {
    slideMenu.classList.toggle('show');
}