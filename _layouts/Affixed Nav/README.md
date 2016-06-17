# Affixed Left Nav Template

__Actions (4a) & Locations__

## HTML

```HTML
<body data-spy="scroll">
	<!-- navigation -->
	<!-- header -->
	<div class="container-fluid">
		<div class="row">
			<nav id="hc-affix-left-nav-container" class="col-sm-4 col-md-3">

				<a id="hc-affix-left-nav-xs-toggle" class="navbar-header visible-xs-block" data-toggle="collapse" data-target="#hc-affix-left-nav" aria-expanded="false">
					<button type="button" class="navbar-toggle">
						<span class="sr-only">Toggle navigation</span>
						<i class="fa fa-fw fa-chevron-down"></i>
					</button>
					<span class="navbar-brand">
						Jump to:
					</span>
				</a>

				<ul id="hc-affix-left-nav" class="nav nav-pills nav-stacked collapse navbar-collapse text-center-xs">
					<!-- list items -->
					<li role="presentation"><a href="#overview">Overview</a></li>
					...
				</ul>
			</nav>

			<section id="hc-affix-content" class="col-sm-8 col-md-9">
				<!-- rendered items -->
				<h2 class="hc-affix-content-heading" id="overview">Overview</h2>
				<!-- field content -->
				...
			</section>
		</div>
	</div>
	<!-- footer -->
</body>
```

## Javascript

```Javascript
$(window).on('load resize', function() {
	if ($(this).width() > 752) {
		$(this).on('.affix');
		$('#hc-affix-left-nav').width($('#hc-affix-left-nav-container').width());
		$('#hc-affix-left-nav-container').height($('#hc-affix-left-nav-container').parent().height());
		$('#hc-affix-left-nav').affix({
			offset: {
				top: function() {
					this.top = $('#hc-main-nav').outerHeight(true) + $('#hc-affix-header').outerHeight(true);
				},
				bottom: function() {
					this.bottom = $('#hc-footer').outerHeight(true);
				}
			}
		});
	} else {
		$(this).off('.affix');
		$('#hc-affix-left-nav').removeData('affix').removeClass('affix affix-top affix-bottom');
		$('#hc-affix-left-nav').width('auto');
		$('#hc-affix-left-nav-container').height('auto');
	}
});
```

__Do not just copy and paste.__ The offset option's top and bottom functions require a bit of configuration to work properly.

* The `top` function requires the sum of the heights of the elements above `#hc-affix-left-nav-container`, seen in the example above as `#hc-main-nav` & `#hc-affix-header`.

* The same is true for the `bottom` function, however use the sum of the elements below; in the example only `#hc-footer` is needed.
