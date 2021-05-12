$(() => {
  const $focusModeOn = $("[data-focus-on]");
  const $focusModeOff = $("[data-focus-off]");
  const $wrapper = $(".focus-mode__body");
  const $content = $("[data-focus-body]");
  const $closer = $("[data-focus-close]");
  const $opener = $("[data-focus-open]");

  const FADEOUT_TIME = 300;

  const focusModeOn = function() {
    $opener.fadeOut(FADEOUT_TIME);
    $content.fadeOut(FADEOUT_TIME, () => {
      $content.detach().prependTo($wrapper);
      $focusModeOn.fadeIn(FADEOUT_TIME, () => {
        $content.fadeIn(FADEOUT_TIME, () => {});
      });
    });
  }

  const focusModeOff = function() {
    $content.fadeOut(FADEOUT_TIME);

    $focusModeOn.fadeOut(FADEOUT_TIME, () => {
      $content.detach().prependTo($focusModeOff);
      $focusModeOff.fadeIn(FADEOUT_TIME, () => {
        $content.fadeIn(FADEOUT_TIME, () => {});
        $opener.fadeIn(FADEOUT_TIME);
      });
    });
  }

  $closer.on("click", focusModeOff);
  $opener.on("click", focusModeOn);

  if (($focusModeOn).data("focus-mode-status") == "open") {
    // todo
    // todo: store cookie
  }
});
