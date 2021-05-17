$(() => {
  const $focusModeOn = $("[data-focus-on]");
  const $focusModeOff = $("[data-focus-off]");
  const $wrapper = $(".focus-mode__body");
  const $content = $("[data-focus-body]");
  const $closer = $("[data-focus-close]");
  const $opener = $("[data-focus-open]");

  const FADEOUT_TIME = 200;

  const focusModeOn = function(fadeTime) {
    if ($opener.length) $opener.fadeOut(fadeTime);

    $content.fadeOut(fadeTime, () => {
      $content.detach().prependTo($wrapper);
      $focusModeOn.fadeIn(fadeTime, () => {
        $content.fadeIn(fadeTime, () => {});
      });
    });
  }

  const focusModeOff = function(fadeTime) {
    $content.fadeOut(fadeTime);

    $focusModeOn.fadeOut(fadeTime, () => {
      $content.detach().prependTo($focusModeOff);
      $focusModeOff.fadeIn(fadeTime, () => {
        $content.fadeIn(fadeTime, () => {});
        if ($opener.length) $opener.fadeIn(fadeTime);
      });
    });
  }

  $closer.on("click", () => { focusModeOff(FADEOUT_TIME) });
  if ($opener.length) $opener.on("click", () => { focusModeOn(FADEOUT_TIME) });

  if (($focusModeOn).data("focus-state") == "on") {
    focusModeOn(0);
  } else {
    focusModeOff(0);
  }
});
