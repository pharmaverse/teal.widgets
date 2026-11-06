// Function that registers resize observer for particular parent elements.
// Arguments are namespaced ids of DOM elements.
var establishPlotResizing = function (plot_out, flex_width) {
  // Create resize observer to trigger shiny actions when plot container is resized.
  var plotObserver = new ResizeObserver(function () {
    const paddingTolerance = 10;
    Shiny.onInputChange(
      flex_width,
      document.getElementById(plot_out).clientWidth - paddingTolerance // Reducing the plot width to avoid overflow
    );
  });

  // Create mutation observer to delay activation of resize observer.
  // Activating observer before the target element exists is impossible.
  var plotNoticer = new MutationObserver(function () {
    const plotContainer = document.getElementById(plot_out);
    if (plotContainer === null) return;
    plotObserver.observe(plotContainer, { box: "border-box" });
  });

  plotNoticer.observe(document, { subtree: true, childList: true });
};

// --- CanvasXpress htmlwidget helpers ---------------------------------------
// Resolve the CanvasXpress instance rendered inside a widget output container.
var tealWidgetsCx = function (outputId) {
  try {
    var cont = document.getElementById(outputId);
    var cv = cont && cont.querySelector("canvas");
    return (cv && window.CanvasXpress && CanvasXpress.getObject) ?
      CanvasXpress.getObject(cv.id) : null;
  } catch (e) { return null; }
};

// Rewire the module download control to export the CanvasXpress chart as a PNG
// (cx.print()) rather than downloading the widget HTML. Capture-phase so it
// runs before shiny's download-link handler.
var tealWidgetsBindWidgetDownload = function (outputId, downloadLinkId) {
  var tries = 0;
  (function bind() {
    var dl = document.getElementById(downloadLinkId);
    if (!dl) { if (tries++ < 50) { setTimeout(bind, 100); } return; }
    if (dl.getAttribute("data-cx-bound") === "1") { return; }
    dl.setAttribute("data-cx-bound", "1");
    dl.addEventListener("click", function (e) {
      var cx = tealWidgetsCx(outputId);
      // Only take over the download for CanvasXpress charts; any other
      // htmlwidget falls through to shiny's existing (HTML) download handler.
      if (cx && cx.print) {
        e.preventDefault();
        e.stopImmediatePropagation();
        cx.print();
      }
    }, true);
    // The file-format (png/pdf/svg) and file-name controls do not apply to the
    // CanvasXpress PNG export, so hide them, leaving a clean download action.
    var base = downloadLinkId.replace(/-data_download$/, "");
    ["-file_format", "-file_name", "-file_name_warning"].forEach(function (suffix) {
      var node = document.getElementById(base + suffix);
      var wrap = node && node.closest ? node.closest(".form-group, .shiny-input-container") : null;
      if (wrap) { wrap.style.display = "none"; } else if (node) { node.style.display = "none"; }
    });
    // The download button is disabled (pointer-events: none) until the hidden
    // file-name field is valid; a PNG export needs no name, so keep it enabled
    // and clickable. Re-apply if shiny toggles the class back on.
    var enable = function () {
      if (dl.classList.contains("disabled")) { dl.classList.remove("disabled"); }
      dl.removeAttribute("aria-disabled");
      dl.style.pointerEvents = "auto";
    };
    enable();
    try {
      new MutationObserver(enable).observe(dl, { attributes: true, attributeFilter: ["class"] });
    } catch (e) { /* no-op */ }
  })();
};

// Bind the bslib card expand button to CanvasXpress fullscreen (cx.toggleFullScreen).
// CanvasXpress fullscreen is a toggle but has no built-in exit here, so we add an
// ESC handler and a floating "Exit full screen" button that toggle it back.
var tealWidgetsBindWidgetFullscreen = function (outputId, cardId) {
  var tries = 0;
  var exitBtnId = outputId + "-cx-fs-exit";
  var onKey = function (ev) {
    if (ev.key === "Escape" || ev.keyCode === 27) { ev.preventDefault(); exitFs(); }
  };
  var exitFs = function () {
    var cx = tealWidgetsCx(outputId);
    if (cx && cx.toggleFullScreen) { cx.toggleFullScreen(); }
    document.removeEventListener("keydown", onKey, true);
    var eb = document.getElementById(exitBtnId);
    if (eb) { eb.parentNode.removeChild(eb); }
  };
  var enterFs = function () {
    var cx = tealWidgetsCx(outputId);
    if (!cx || !cx.toggleFullScreen) { return; }
    cx.toggleFullScreen();
    document.addEventListener("keydown", onKey, true);
    if (!document.getElementById(exitBtnId)) {
      var eb = document.createElement("button");
      eb.id = exitBtnId;
      eb.type = "button";
      eb.textContent = "✕ Exit full screen";
      eb.style.cssText = "position:fixed;top:12px;right:16px;z-index:100000;" +
        "padding:6px 12px;border-radius:6px;border:1px solid #ccc;background:#fff;" +
        "cursor:pointer;font:600 13px sans-serif;box-shadow:0 2px 8px rgba(0,0,0,.2);";
      eb.addEventListener("click", function (e) { e.stopPropagation(); exitFs(); });
      document.body.appendChild(eb);
    }
  };
  (function bind() {
    var card = document.getElementById(cardId);
    var btn = card && card.querySelector(".bslib-full-screen-enter");
    if (!btn) { if (tries++ < 50) { setTimeout(bind, 100); } return; }
    if (btn.getAttribute("data-cx-bound") === "1") { return; }
    btn.setAttribute("data-cx-bound", "1");
    btn.addEventListener("click", function (e) {
      var cx = tealWidgetsCx(outputId);
      // Only take over the expand for CanvasXpress charts; any other htmlwidget
      // keeps bslib's own full-screen behaviour.
      if (cx && cx.toggleFullScreen) {
        e.preventDefault();
        e.stopImmediatePropagation();
        enterFs();
      }
    }, true);
  })();
};
