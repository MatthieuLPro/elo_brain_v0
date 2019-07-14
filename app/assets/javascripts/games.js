$(document).on('turbolinks:load', function() {
  const searchInput = document.getElementById('searchInput');
  const searchIcon = document.getElementById('fa-search');

  if (searchInput && searchIcon) {
    searchInput.addEventListener('input', function(e) {
      sortGames(e.target.value);
    });

    function sortGames(value) {
      const games = document.querySelectorAll('.game');
      games.forEach(game => {
        if (
          game.firstElementChild.textContent
            .toUpperCase()
            .includes(value.toUpperCase())
        ) {
          //   console.log(game.firstElementChild);
          game.style.display = 'block';
        } else {
          game.style.display = 'none';
        }
      });
    }

    $(searchIcon).click(function() {
      $(searchInput).toggleClass('show');
    });
  }
});
