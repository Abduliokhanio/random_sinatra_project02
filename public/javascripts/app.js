//need to make a function that gets rid of the preloader.
window.addEventListener('load',()=>{
  const preload = document.querySelector('.preload');  
  setTimeout(() =>{preload.classList.add('preload-finish');}, 5000)
});
