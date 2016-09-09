// $Id$

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN">
<html>
<head>
	<title>
	<?php
		print $head_title	
	?>
	</title>
	<!-- Style sheet information -->
	<?php
		print $styles
	?>
</head>

<body>
	<div id="container">
	
		<!-- Header -->
		<div id="header">
			<h1>
				<?php
				 print $site_name
				?>
			</h1>
		</div>
		
		<!-- Sidebars -->
		<?php
			if ($sidebar_left)
			{
		?>
			<div id="sidebar-left">
				<?php
					print $sidebar_left
				?>
			</div>
		<?php
			}
		?>
		<?php
			if ($sidebar_right)
			{
		?>
			<div id="sidebar-right">
				<?php
					print $sidebar_right
				?>
			</div>
		<?php
			}
		?>
		
		<!-- Main content -->
		<div id="breadcrumb">
			<?php
				print $breadcrumb
			?>
		</div>	
		<div id="main" style="main-content">
			<h2>
				<?php
					print $title
				?>
			</h2>
			<?php
				print $content
			?>
		<div>
		
		<!-- Footer -->
		<div id="footer">
			<?php
				print $footer
			?>
		</div>
		
	</div>
</body>
</html>