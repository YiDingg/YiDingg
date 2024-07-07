!(function (t, e) {
    "object" == typeof exports && "object" == typeof module
        ? (module.exports = e())
        : "function" == typeof define && define.amd
        ? define([], e)
        : "object" == typeof exports
        ? (exports.DocsifyGiscus = e())
        : (t.DocsifyGiscus = e());
})(this, () =>
    (() => {
        "use strict";
        var t = {};
        return (
            window.$docsify || (window.$docsify = {}),
            (window.$docsify.plugins = (window.$docsify.plugins || []).concat(
                function (t, e) {
                    t.afterEach(function (t, e) {
                        (t += "<div class='giscus'></div>"),
                            (function (t) {
                                var e = document.getElementById("giscus");
                                e && e.remove();
                                var s = document.createElement("script");
                                (s.src = "https://giscus.app/client.js"),
                                    (s.dataset.repo = t.repo),
                                    (s.dataset.repoId = t.repoId),
                                    (s.dataset.category = t.category),
                                    (s.dataset.categoryId = t.categoryId),
                                    (s.dataset.mapping = t.mapping),
                                    (s.dataset.reactionsEnabled =
                                        t.reactionsEnabled),
                                    (s.dataset.strict = t.strict),
                                    (s.dataset.emitMetadata = t.emitMetadata),
                                    (s.dataset.inputPosition = t.inputPosition),
                                    (s.dataset.theme = t.theme),
                                    (s.dataset.lang = t.lang),
                                    (s.dataset.loading = t.loading),
                                    (s.crossorigin = "anonymous"),
                                    (s.id = "giscus");
                                var o =
                                    document.getElementsByTagName("script")[0];
                                o.parentNode.insertBefore(s, o),
                                    console.info("[docsify-giscus] rendering!");
                            })(window.$docsify.giscus),
                            e(t);
                    });
                }
            )),
            (t = t.default)
        );
    })()
);
