$(() => {
  const $focusModeOn = $("[data-focus-on]");
  const $focusModeOff = $("[data-focus-off]");
  const $wrapper = $(".focus-mode__body");
  const $content = $("[data-focus-body]");
  const $closer = $("[data-focus-close]");
  const $opener = $("[data-focus-open]");

  const $background = $(".title-bar, [data-set='nav-holder'], .process-header");

  const $overlay = $(".omnipresent-banner, .cookie-warning");
  const $cookieButton = $(".cookie-bar__button");

  const FADEOUT_TIME = 200;

  const overlayHeight = () => {
    var h = 0;
    $overlay.outerHeight((i, v) => {
      if ($($overlay[i]).is(":visible")) h += v;
    });
    return h;
  };

  const moveToShowOverlay = () => {
    const top = $(document).scrollTop();
    const height = overlayHeight();

    if (top <= height) {
      $focusModeOn.css({ top: `${height}px` })
    } else {
      $focusModeOn.css({ top: "0px" })
    }
  }

  const moveOverlay = () => {
    if (!$overlay.length) return;

    if ($cookieButton.length) {
      $cookieButton.on("click", moveToShowOverlay);
    }

    moveToShowOverlay();
    window.addEventListener("scroll", moveToShowOverlay);
  }

  const focusModeOn = function(fadeTime) {
    if ($opener.length) $opener.fadeOut(fadeTime);

    $background.animate({ opacity: 0 }, fadeTime);
    moveOverlay();

    $content.fadeOut(fadeTime, () => {
      $content.detach().prependTo($wrapper);
      $focusModeOn.fadeIn(fadeTime, () => {
        $content.fadeIn(fadeTime, () => {});
      });
    });
  }

  const focusModeOff = function(fadeTime) {
    $content.fadeOut(fadeTime);
    $background.animate({ opacity: 1 }, fadeTime);

    $focusModeOn.fadeOut(fadeTime, () => {
      $content.detach().prependTo($focusModeOff);
      $focusModeOff.fadeIn(fadeTime, () => {
        $content.fadeIn(fadeTime, () => {});
        if ($opener.length) $opener.fadeIn(fadeTime);
      });
    });
  }

  const initializeFocusMode = () => {
    $closer.on("click", () => { focusModeOff(FADEOUT_TIME) });

    if ($opener.length) $opener.on("click", () => { focusModeOn(FADEOUT_TIME) });

    if (window.matchMedia('(min-width: 800px)').matches) {
      focusModeOn(0);
    } else {
      focusModeOff(0);
    }
  }

  initializeFocusMode();

  $(window).resize(initializeFocusMode);
});
