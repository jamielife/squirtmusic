<div id="primary-navigation" class="text-right">
			<a <?php if(in_array($_SERVER['PHP_SELF'], array('/shows.php'))): ?>        class="active"<?php endif; ?> href="/shows.php">Shows</a> 
			<a <?php if(in_array($_SERVER['PHP_SELF'], array('/bios.php', 
                                                             '/jamie.php', 
                                                             '/john.php', 
                                                             '/dean.php', 
                                                             '/pete.php'))): ?>         class="active"<?php endif; ?> href="/bios.php">Bios</a> 
			<a <?php if(in_array($_SERVER['PHP_SELF'], array('/news.php'))): ?>         class="active"<?php endif; ?> href="/news.php">News</a> 
			<a <?php if(in_array($_SERVER['PHP_SELF'], array('/guestbook.php'))): ?>    class="active"<?php endif; ?> href="/guestbook.php">Guestbook</a> 
			<a <?php if(in_array($_SERVER['PHP_SELF'], array('/discography.php'))): ?>  class="active"<?php endif; ?> href="/discography.php">Discography</a> 
			<a <?php if(in_array($_SERVER['PHP_SELF'], array('/faqs.php'))): ?>         class="active"<?php endif; ?> href="/faqs.php">FAQs</a> 
			<a <?php if(in_array($_SERVER['PHP_SELF'], array('/contact.php'))): ?>      class="active"<?php endif; ?> href="/contact.php">Contact</a> 
		</div>		
