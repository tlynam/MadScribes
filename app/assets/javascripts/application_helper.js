jQuery(function($) {
	$("tr[data-link]").click(function() {
		window.location = this.dataset.link
	});
})
