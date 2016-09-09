<script type="text/javascript" src="/js/jquery.fancybox-1.3.4.js"></script>
<!-- slideshow modal -->
<div style="display:none">
  <div id="slideshow-modal">
    <h3 id="title"><?php print $title ?></h3>
    <h4 id="dek"><?php print $dek; ?></h4>
    <!-- slideshow image -->
    <div id="slideshow-image">
      <div id="prev">
      </div>
      <div id="image">
        <?php foreach ($slideshow as $item) { ?>
        <img src="<?php print '/'.$item['filepath'] ?>" title="<?php print $item['data']['caption']['body'] ?>" credits="<?php print $item['data']['photo_credits']['body'] ?>" alt="" >
        <?php } ?>
      </div>
      <div id="next">
      </div>
      <div id="photo-credits">
        <p>This is the photo credit</p>
      </div>
    </div>
    <!-- end slideshow image -->
    <!-- right sidebar -->
    <div id="right-sidebar">
      <div id="description">
        <p></p>
      </div>
    </div>
    <!-- end right sidebar -->
    <!-- thumbnail slider -->
    <div id="slider-container">
      <div id="prev">
      </div>
      <div id="thumbs-slider">
        <div id="thumbs-container">
          <ul id="thumbs">
            <?php
              $i = 1;
              foreach ($slideshow as $item) {
                switch ($i) { 
                  case 1:
            ?>
            <li class="active" rel="<?php print $i ?>">
            <?php
                    break;
                  default:
            ?>
            <li rel="<?php print $i ?>">
            <?php
                    break;
                }
            ?>
            <?php
              if (file_exists($item['filepath'])) {
                $width = 0;
                $hieght = 0;
                $imgData = getimagesize($item['filepath']);

                if ($imgData[0] > 104) {
                  $width = 104;
                }
                
                if ($imgData[1] > 70) {
                  $height = 70;
                }
              }
             
              if ($width > 0 && $height > 0 && $imgData[0] > $imgData[1]) {
            ?>
              <img src="<?php print '/'.$item['filepath'] ?>" alt="" width="<?php print $width; ?> px" >
            <?php
              } elseif ($width > 0 && $height > 0 && $imgData[0] < $imgData[1]) {
            ?>  
              <img src="<?php print '/'.$item['filepath'] ?>" alt="" height="<?php print $height; ?> px" >
            <?php
              } elseif ($width === 0 && $height > 0) {
            ?>
              <img src="<?php print '/'.$item['filepath'] ?>" alt="" height="<?php print $height; ?> px" >
            <?php
              } elseif ($width > 0 && $height === 0) {
            ?>
              <img src="<?php print '/'.$item['filepath'] ?>" alt="" width="<?php print $width; ?> px" >
            <?php
              } else {
            ?>
              <img src="<?php print '/'.$item['filepath'] ?>" alt="" >
            <?php  
              }
            ?>
            </li>
            <?php
                $i++;
              }
            ?>
          </ul>
        </div>
      </div>
      <div id="next">
      </div>
    </div>
    <!-- end thumbnail slider -->
    <!-- ad block -->
    <?php require_once 'block-ad120x60.tpl.php'; ?>
    <!-- end ad block -->
  </div>
</div>
<!-- end slideshow modal -->
<script type="text/javascript">
  // Pointer to the current image being displayed
  var currentImage;
  // The current index image being displayed
  var currentIndex = -1;
  // The total number of images in the container div
  var len = $('#image img').length;
  // Elaspsed time (in milliseconds) for animations to occur
  var speed = 50;
  // Boolean for image loading being complete
  var loading = false;
  
  // Displays the image that matches the index passed
  // Updates the currendImage and currentIndex to the new image
  // Populates the description for the image
  // Paints the matching thumbnail with an active CSS class
  function showImage(index) {
    if(index < $('#image img').length){
      // Initialize the ad space
      initAd();
      
      var indexImage = $('#image img')[index];
      
      if(currentImage){   
        if(currentImage !== indexImage ){
          $(currentImage).css('z-index', 2);
  
          $(currentImage).fadeOut(
            speed, 
            function() {
              $(this).css({'display':'none','z-index':1});
            });
        }
      }
  
      $(indexImage).css({'display':'block', 'opacity': 1});
  
      $('#description p').html('');
      $('#description p').html($(indexImage).attr('title'));
      $('#photo-credits p').html($(indexImage).attr('credits'));
  
      currentImage = indexImage;
      currentIndex = index;
  
      $('#thumbs li').removeClass('active');
      $($('#thumbs li')[index]).addClass('active');
    }
  }
  
  // Decrements currentIndex and passes it to showImage
  function showPrev(){
    // Decrement currentIndex and pass it to showImage
    if (currentIndex > 0) {
      var prev = currentIndex - 1;
      showImage(prev);
    }
    
    // Hide the previous arrow if the beginning of the slider is reached
    if (currentIndex === 0) {
      $('#slideshow-image #prev').css('opacity', 0.4);
      $('#slider-container #prev').css('opacity', 0.4);
    } else {
      $('#slideshow-image #next').css('opacity', 1);
      $('#slider-container #next').css('opacity', 1);
    }
  }
  
  // Increments currentIndex and passes it to showImage
  function showNext(){
    // Increment currentIndex and pass it to showImage
    if (currentIndex < (len-1)) {
      var next = currentIndex + 1;
      showImage(next);
    }
  
    // Hide the previous arrow if the beginning of the slider is reached
    if (currentIndex === (len-1)) {
      $('#slideshow-image #next').css('opacity', 0.4);
      $('#slider-container #next').css('opacity', 0.4);
    } else {
      $('#slideshow-image #prev').css('opacity', 1);
      $('#slider-container #prev').css('opacity', 1);
    }
  }
  
  // Slides the thumbnail ribbon right, and displays the previous image
  function slidePrev(){
    loading = true;
    // Delay the sliding until it reaches the middle of the thumbnail ribbon
    if (currentIndex > 2 && currentIndex < (len-1)) {
      // Slide the ribbon right and display the image
      $('#thumbs-container').animate({
        marginLeft: '+=115'
      }, 
      speed,
      function() {
        showPrev();
        loading = false;
      });
    } else {
      if (currentIndex > 0) {
        showPrev();
        loading = false;
      } else {
        loading = false;
      }
    }
  }
  
  // Slides the thumbnail ribbon left, and displays the next image
  function slideNext(){
    loading = true;
    // Delay the sliding until it reaches the middle of the thumbnail ribbon
    if (currentIndex > 2 && currentIndex < (len-1)) {
      // Slide the ribbon left and display the image
      $('#thumbs-container').animate({
        marginLeft: '-=115'
      }, 
      speed, 
      function() {
        showNext();
        loading = false;
      });
    } else {
      if (currentIndex < (len-1)) {
        showNext();
        loading = false;
      } else {
        loading = false;
      }
    }
  }
  
  $(document).ready(function(){
    // Initialize fancybox for the slideshow modal
    $.fancybox.init();
    // Initialize the a tag to open the modal
    $('a#open-modal').fancybox({
      autoDimensions: true,
      overlayColor: '#404040',
      centerOnScroll: false,
      onStart: function() {},
      onComplete: function() {
        // Initialize the ad space
        initAd ('.ad-slideshow-120x60', 5, 120, 60);
        // Fade out the previous buttons in the navigation
        $('#slideshow-image #prev').css('opacity', 0.4);
        $('#slider-container #prev').css('opacity', 0.4);
      }
    });
    // Load first image
    showNext();
    // Bind JQuery events to the DOM elements
    // Bind click events to the thumbnail images
    $('#thumbs li').bind('click',function(e){
      if (loading === false) {
        var count = $(this).attr('rel');
        showImage(parseInt(count)-1);
      }
    });
    // Bind click events to the navigation
    $('#slideshow-image #prev').bind('click', function(e){
        if (loading === false) {
          slidePrev();
        }
        e.preventDefault();
    });
  
    $('#slideshow-image #next').bind('click', function(e){
        if (loading === false) {
          slideNext();
        }
        e.preventDefault();
    });
  
    $('#slider-container #prev').bind('click', function(e){
        if (loading === false) {
          slidePrev();
        }
        e.preventDefault();
    });
  
    $('#slider-container #next').bind('click', function(e){
        if (loading === false) {
          slideNext();
        }
        e.preventDefault();
    });
    // Bind click events to the keyboard arrow keys
    $(document).bind('keydown', function (e) {
      var keyCode = e.keyCode || e.which,
          arrow = {
            left: 37, 
            up: 38, 
            right: 39, 
            down: 40 
          };
  
      switch (keyCode) {
        case arrow.left:
          if (loading === false) {
            slidePrev();
          }
          e.preventDefault();
        break;
        case arrow.up:
          //
        break;
        case arrow.right:
          if (loading === false) {
            slideNext();
          }
          e.preventDefault();
        break;
        case arrow.down:
          //
        break;
      }
    });
  });
</script>