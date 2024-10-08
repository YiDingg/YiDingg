// https://gcore.jsdelivr.net/npm/docsify-pagination/dist/docsify-pagination.min.js

!(function (t) {
    ("object" != typeof exports || "undefined" == typeof module) &&
    "function" == typeof define &&
    define.amd
        ? define(t)
        : t();
})(function () {
    "use strict";
    var i =
        "undefined" != typeof window
            ? window
            : "undefined" != typeof global
            ? global
            : "undefined" != typeof self
            ? self
            : {};
    function t(t, e) {
        return t((e = { exports: {} }), e.exports), e.exports;
    }
    var c = t(function (t, e) {
            function n(t, e) {
                return e.querySelector(t);
            }
            ((e = t.exports =
                function (t, e) {
                    return n(t, (e = e || document));
                }).all = function (t, e) {
                return (e = e || document).querySelectorAll(t);
            }),
                (e.engine = function (t) {
                    if (!t.one) throw new Error(".one callback required");
                    if (t.all) return (n = t.one), (e.all = t.all), e;
                    throw new Error(".all callback required");
                });
        }),
        e =
            (c.all,
            c.engine,
            t(function (e) {
                var n = eval;
                try {
                    n("export default global");
                } catch (t) {
                    try {
                        n("export default self");
                    } catch (t) {
                        try {
                            e.exports = i;
                        } catch (t) {
                            try {
                                self.global = self;
                            } catch (t) {
                                window.global = window;
                            }
                        }
                    }
                }
            }));
    try {
        var a = c;
    } catch (t) {
        a = c;
    }
    var e = e.Element,
        e = (e && e.prototype) || {},
        r =
            e.matches ||
            e.webkitMatchesSelector ||
            e.mozMatchesSelector ||
            e.msMatchesSelector ||
            e.oMatchesSelector,
        s = function (t, e) {
            if (!t || 1 !== t.nodeType) return !1;
            if (r) return r.call(t, e);
            for (var n = a.all(e, t.parentNode), i = 0; i < n.length; ++i)
                if (n[i] == t) return !0;
            return !1;
        };
    try {
        var o = s;
    } catch (t) {
        o = s;
    }
    var p = function (t, e, n) {
        n = n || document.documentElement;
        for (; t && t !== n; ) {
            if (o(t, e)) return t;
            t = t.parentNode;
        }
        return o(t, e) ? t : null;
    };
    (e =
        ".docsify-pagination-container{display:flex;flex-wrap:wrap;justify-content:space-between;overflow:hidden;margin:5em 0 1em;border-top:1px solid rgba(0,0,0,.07)}.pagination-item{margin-top:2.5em}.pagination-item a,.pagination-item a:hover{text-decoration:none}.pagination-item a{color:currentColor}.pagination-item a:hover .pagination-item-title{text-decoration:underline}.pagination-item:not(:last-child) a .pagination-item-label,.pagination-item:not(:last-child) a .pagination-item-subtitle,.pagination-item:not(:last-child) a .pagination-item-title{opacity:.3;transition:all .2s}.pagination-item:last-child .pagination-item-label,.pagination-item:not(:last-child) a:hover .pagination-item-label{opacity:.6}.pagination-item:not(:last-child) a:hover .pagination-item-title{opacity:1}.pagination-item-label{font-size:.8em}.pagination-item-label>*{line-height:1;vertical-align:middle}.pagination-item-label svg{height:.8em;width:auto;stroke:currentColor;stroke-linecap:round;stroke-linejoin:round;stroke-width:1px}.pagination-item--next{margin-left:auto;text-align:right}.pagination-item--next svg{margin-left:.5em}.pagination-item--previous svg{margin-right:.5em}.pagination-item-title{font-size:1.6em}.pagination-item-subtitle{text-transform:uppercase;opacity:.3}"),
        (u = (u = void 0 === u ? {} : u).insertAt),
        e &&
            "undefined" != typeof document &&
            ((n = document.head || document.getElementsByTagName("head")[0]),
            ((l = document.createElement("style")).type = "text/css"),
            "top" === u && n.firstChild
                ? n.insertBefore(l, n.firstChild)
                : n.appendChild(l),
            l.styleSheet
                ? (l.styleSheet.cssText = e)
                : l.appendChild(document.createTextNode(e)));
    var n,
        l,
        u = function (t, e, n) {
            return e && f(t.prototype, e), n && f(t, n), t;
        };
    function f(t, e) {
        for (var n = 0; n < e.length; n++) {
            var i = e[n];
            (i.enumerable = i.enumerable || !1),
                (i.configurable = !0),
                "value" in i && (i.writable = !0),
                Object.defineProperty(t, i.key, i);
        }
    }
    var d =
            Object.assign ||
            function (t) {
                for (var e = 1; e < arguments.length; e++) {
                    var n,
                        i = arguments[e];
                    for (n in i)
                        Object.prototype.hasOwnProperty.call(i, n) &&
                            (t[n] = i[n]);
                }
                return t;
            },
        h = "docsify-pagination-container";
    function g(t) {
        return Array.prototype.slice.call(t);
    }
    function m(t) {
        return t.href ? t : c("a", t);
    }
    function v(t) {
        return t && "#/README" === t.toUpperCase() ? "#/" : t;
    }
    function x(e, t) {
        return 1 === arguments.length
            ? function (t) {
                  return x(e, t);
              }
            : v(decodeURIComponent(t.getAttribute("href").split("?")[0])) ===
                  v(decodeURIComponent(e));
    }
    u(w, [
        {
            key: "toJSON",
            value: function () {
                if (this.hyperlink)
                    return {
                        name: this.hyperlink.innerText,
                        href: this.hyperlink.getAttribute("href"),
                        chapterName:
                            (this.chapter && this.chapter.innerText) || "",
                        isExternal:
                            "_blank" === this.hyperlink.getAttribute("target"),
                    };
            },
        },
    ]);
    var y = w;
    function w(t) {
        var e;
        if (!(this instanceof w))
            throw new TypeError("Cannot call a class as a function");
        t &&
            ((this.chapter = ((e = p((e = t), "div > ul > li")), c("p", e))),
            (this.hyperlink = m(t)));
    }
    var b = function () {
            return '<div class="' + h + '"></div>';
        },
        k = function (t, e) {
            (a = e),
                (r = t.route.path),
                (o = {}),
                ["previousText", "nextText"].forEach(function (n) {
                    var i = a[n];
                    "string" == typeof i
                        ? (o[n] = i)
                        : Object.keys(i).some(function (t) {
                              var e = r && -1 < r.indexOf(t);
                              return (o[n] = e ? i[t] : i), e;
                          });
                });
            var a,
                r,
                o,
                n = o,
                i = n.previousText,
                n = n.nextText;
            return [
                t.prev &&
                    '\n        <div class="pagination-item pagination-item--previous">\n          <a href="' +
                        t.prev.href +
                        '" ' +
                        (t.prev.isExternal ? 'target="_blank"' : "") +
                        '>\n            <div class="pagination-item-label">\n              <svg width="10" height="16" viewBox="0 0 10 16" xmlns="http://www.w3.org/2000/svg">\n                <polyline fill="none" vector-effect="non-scaling-stroke" points="8,2 2,8 8,14"/>\n              </svg>\n              <span>' +
                        i +
                        '</span>\n            </div>\n            <div class="pagination-item-title">' +
                        t.prev.name +
                        "</div>\n      ",
                t.prev &&
                    e.crossChapterText &&
                    '<div class="pagination-item-subtitle">' +
                        t.prev.chapterName +
                        "</div>",
                t.prev && "</a>\n        </div>\n      ",
                t.next &&
                    '\n        <div class="pagination-item pagination-item--next">\n          <a href="' +
                        t.next.href +
                        '" ' +
                        (t.next.isExternal ? 'target="_blank"' : "") +
                        '>\n            <div class="pagination-item-label">\n              <span>' +
                        n +
                        '</span>\n              <svg width="10" height="16" viewBox="0 0 10 16" xmlns="http://www.w3.org/2000/svg">\n                <polyline fill="none" vector-effect="non-scaling-stroke" points="2,2 8,8 2,14"/>\n              </svg>\n            </div>\n            <div class="pagination-item-title">' +
                        t.next.name +
                        "</div>\n      ",
                t.next &&
                    e.crossChapterText &&
                    '<div class="pagination-item-subtitle">' +
                        t.next.chapterName +
                        "</div>",
                t.next && "</a>\n        </div>\n      ",
            ]
                .filter(Boolean)
                .join("");
        };
    (window.$docsify = window.$docsify || {}),
        (window.$docsify.plugins = [
            function (t, e) {
                var n = d(
                    {},
                    (e.config,
                    {
                        previousText: "PREVIOUS",
                        nextText: "NEXT",
                        crossChapter: !1,
                        crossChapterText: !1,
                    }),
                    e.config.pagination || {}
                );
                function i() {
                    var t = c("." + h);
                    t &&
                        (t.innerHTML = k(
                            (function (t, e) {
                                e = e.crossChapter;
                                try {
                                    var n = t.router.toURL(t.route.path),
                                        i = g(
                                            c.all(".sidebar-nav li a")
                                        ).filter(function (t) {
                                            return !s(t, ".section-link");
                                        }),
                                        a = i.find(x(n)),
                                        r = g(
                                            (p(a, "ul") || {}).children
                                        ).filter(function (t) {
                                            return (
                                                "LI" === t.tagName.toUpperCase()
                                            );
                                        }),
                                        o = e
                                            ? i.findIndex(x(n))
                                            : r.findIndex(function (t) {
                                                  t = m(t);
                                                  return t && x(n, t);
                                              }),
                                        l = e ? i : r;
                                    return {
                                        route: t.route,
                                        prev: new y(l[o - 1]).toJSON(),
                                        next: new y(l[o + 1]).toJSON(),
                                    };
                                } catch (t) {
                                    return { route: {} };
                                }
                            })(e, n),
                            n
                        ));
                }
                t.afterEach(function (t) {
                    return t + b();
                }),
                    t.doneEach(i);
            },
        ].concat(window.$docsify.plugins || []));
});
