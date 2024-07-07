// https://cdn.jsdelivr.net/npm/docsify-busuanzi@1.0.1/dist/docsify-busuanzi.min.js
// http://ibruce.info/2015/04/04/busuanzi/

!(function (n, i) {
    "object" == typeof exports && "object" == typeof module
        ? (module.exports = i())
        : "function" == typeof define && define.amd
        ? define([], i)
        : "object" == typeof exports
        ? (exports.DocsifyBusuanzi = i())
        : (n.DocsifyBusuanzi = i());
})(this, () =>
    (() => {
        "use strict";
        var n = {};
        function i() {
            return window.$docsify.busuanzi;
        }
        return (
            window.$docsify || (window.$docsify = {}),
            (window.$docsify.plugins = (window.$docsify.plugins || []).concat(
                function (n, e) {
                    n.afterEach(function (n, e) {
                        if (i()) {
                            (n +=
                                '<div style="text-align:center;color:gray;font-size:0.7rem;"><span id="busuanzi_container_site_uv"><span id="busuanzi_container_page_pv"><span id="busuanzi_value_page_pv"></span> visits for this article</span><br><span id="busuanzi_value_site_uv"></span> people have visited the site, <span id="busuanzi_container_site_pv">total site visits <span id="busuanzi_value_site_pv"></span></span></div>'),
                                (function () {
                                    if (i()) {
                                        var n =
                                            document.createElement("script");
                                        (n.src =
                                            "//busuanzi.ibruce.info/busuanzi/2.3/busuanzi.pure.mini.js"),
                                            (n.async = "async");
                                        var e =
                                            document.getElementsByTagName(
                                                "script"
                                            )[0];
                                        e.parentNode.insertBefore(n, e),
                                            console.info(
                                                "[docsify-busuanzi] enable busuanzi success!"
                                            );
                                    } else
                                        console.info(
                                            "[docsify-busuanzi] not enable busuanzi!"
                                        );
                                })();
                        }
                        e(n);
                    });
                }
            )),
            (n = n.default)
        );
    })()
);
