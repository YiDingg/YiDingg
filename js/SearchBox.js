// https://gcore.jsdelivr.net/npm/docsify/lib/plugins/search.min.js

!(function () {
    function u(e) {
        return e
            .replace(/<!-- {docsify-ignore} -->/, "")
            .replace(/{docsify-ignore}/, "")
            .replace(/<!-- {docsify-ignore-all} -->/, "")
            .replace(/{docsify-ignore-all}/, "")
            .trim();
    }
    var f = {},
        m = {
            EXPIRE_KEY: "docsify.search.expires",
            INDEX_KEY: "docsify.search.index",
        };
    function g(e) {
        var n = {
            "&": "&amp;",
            "<": "&lt;",
            ">": "&gt;",
            '"': "&quot;",
            "'": "&#39;",
        };
        return String(e).replace(/[&<>"']/g, function (e) {
            return n[e];
        });
    }
    function y(e) {
        return (
            e.text ||
                "table" !== e.type ||
                (e.cells.unshift(e.header),
                (e.text = e.cells
                    .map(function (e) {
                        return e.join(" | ");
                    })
                    .join(" |\n "))),
            e.text
        );
    }
    function v(e) {
        return e.text || "list" !== e.type || (e.text = e.raw), e.text;
    }
    function b(o, e, s, c) {
        void 0 === e && (e = "");
        var d,
            e = window.marked.lexer(e),
            l = window.Docsify.slugify,
            p = {},
            h = "";
        return (
            e.forEach(function (e, n) {
                var t, a, i, r;
                "heading" === e.type && e.depth <= c
                    ? ((t = (a =
                          ((i = e.text),
                          (r = {}),
                          {
                              str: (i =
                                  (i = void 0 === i ? "" : i) &&
                                  i
                                      .replace(/^('|")/, "")
                                      .replace(/('|")$/, "")
                                      .replace(
                                          /(?:^|\s):([\w-]+:?)=?([\w-%]+)?/g,
                                          function (e, n, t) {
                                              return -1 === n.indexOf(":")
                                                  ? ((r[n] =
                                                        (t &&
                                                            t.replace(
                                                                /&quot;/g,
                                                                ""
                                                            )) ||
                                                        !0),
                                                    "")
                                                  : e;
                                          }
                                      )
                                      .trim()),
                              config: r,
                          })).str),
                      (i = a.config),
                      (a = u(e.text)),
                      (d = i.id
                          ? s.toURL(o, { id: l(i.id) })
                          : s.toURL(o, { id: l(g(a)) })),
                      t && (h = u(t)),
                      (p[d] = { slug: d, title: h, body: "" }))
                    : (0 === n &&
                          ((d = s.toURL(o)),
                          (p[d] = {
                              slug: d,
                              title: "/" !== o ? o.slice(1) : "Home Page",
                              body: e.text || "",
                          })),
                      d &&
                          (p[d]
                              ? p[d].body
                                  ? ((e.text = y(e)),
                                    (e.text = v(e)),
                                    (p[d].body += "\n" + (e.text || "")))
                                  : ((e.text = y(e)),
                                    (e.text = v(e)),
                                    (p[d].body = e.text || ""))
                              : (p[d] = { slug: d, title: "", body: "" })));
            }),
            l.clear(),
            p
        );
    }
    function p(e) {
        return e && e.normalize
            ? e.normalize("NFD").replace(/[\u0300-\u036f]/g, "")
            : e;
    }
    function o(e) {
        var n = [],
            t = [];
        Object.keys(f).forEach(function (n) {
            t = t.concat(
                Object.keys(f[n]).map(function (e) {
                    return f[n][e];
                })
            );
        });
        var a = (e = e.trim()).split(/[\s\-，\\/]+/);
        1 !== a.length && (a = [].concat(e, a));
        for (var i = 0; i < t.length; i++)
            !(function (e) {
                var e = t[e],
                    r = 0,
                    o = "",
                    s = "",
                    c = "",
                    d = e.title && e.title.trim(),
                    l = e.body && e.body.trim(),
                    e = e.slug || "";
                d &&
                    (a.forEach(function (e) {
                        var n,
                            t,
                            a = new RegExp(
                                g(p(e)).replace(/[|\\{}()[\]^$+*?.]/g, "\\$&"),
                                "gi"
                            ),
                            i = -1;
                        (s = d && g(p(d))),
                            (c = l && g(p(l))),
                            (t = d ? s.search(a) : -1),
                            (i = l ? c.search(a) : -1),
                            (0 <= t || 0 <= i) &&
                                ((r += 0 <= t ? 3 : 0 <= i ? 2 : 0),
                                (t =
                                    (t = n = 0) ==
                                    (n = (i = i < 0 ? 0 : i) < 11 ? 0 : i - 10)
                                        ? 70
                                        : i + e.length + 60),
                                l && t > l.length && (t = l.length),
                                (a =
                                    c &&
                                    "..." +
                                        c
                                            .substring(n, t)
                                            .replace(a, function (e) {
                                                return (
                                                    '<em class="search-keyword">' +
                                                    e +
                                                    "</em>"
                                                );
                                            }) +
                                        "..."),
                                (o += a));
                    }),
                    0 < r &&
                        ((e = {
                            title: s,
                            content: l ? o : "",
                            url: e,
                            score: r,
                        }),
                        n.push(e)));
            })(i);
        return n.sort(function (e, n) {
            return n.score - e.score;
        });
    }
    function r(a, i) {
        var t,
            r,
            n,
            e,
            o = "auto" === a.paths,
            s = o
                ? ((t = i.router),
                  (r = []),
                  Docsify.dom
                      .findAll(
                          ".sidebar-nav a:not(.section-link):not([data-nosearch])"
                      )
                      .forEach(function (e) {
                          var n = e.href,
                              e = e.getAttribute("href"),
                              n = t.parse(n).path;
                          n &&
                              -1 === r.indexOf(n) &&
                              !Docsify.util.isAbsolutePath(e) &&
                              r.push(n);
                      }),
                  r)
                : a.paths,
            c = "";
        s.length && o && a.pathNamespaces
            ? ((n = s[0]),
              Array.isArray(a.pathNamespaces)
                  ? (c =
                        a.pathNamespaces.filter(function (e) {
                            return n.slice(0, e.length) === e;
                        })[0] || c)
                  : a.pathNamespaces instanceof RegExp &&
                    (d = n.match(a.pathNamespaces)) &&
                    (c = d[0]),
              (e = -1 === s.indexOf(c + "/")),
              (d = -1 === s.indexOf(c + "/README")),
              e && d && s.unshift(c + "/"))
            : -1 === s.indexOf("/") &&
              -1 === s.indexOf("/README") &&
              s.unshift("/");
        var d,
            l = ((d = a.namespace) ? m.EXPIRE_KEY + "/" + d : m.EXPIRE_KEY) + c,
            p = ((d = a.namespace) ? m.INDEX_KEY + "/" + d : m.INDEX_KEY) + c,
            c = localStorage.getItem(l) < Date.now();
        if (((f = JSON.parse(localStorage.getItem(p))), c)) f = {};
        else if (!o) return;
        var h = s.length,
            u = 0;
        s.forEach(function (t) {
            return f[t]
                ? u++
                : void Docsify.get(
                      i.router.getFile(t),
                      !1,
                      i.config.requestHeaders
                  ).then(function (e) {
                      var n;
                      (f[t] = b(t, e, i.router, a.depth)),
                          h === ++u &&
                              ((n = a.maxAge),
                              (e = p),
                              localStorage.setItem(l, Date.now() + n),
                              localStorage.setItem(e, JSON.stringify(f)));
                  });
        });
    }
    var s,
        c = "";
    function d(e) {
        var n = Docsify.dom.find("div.search"),
            t = Docsify.dom.find(n, ".results-panel"),
            a = Docsify.dom.find(n, ".clear-button"),
            i = Docsify.dom.find(".sidebar-nav"),
            n = Docsify.dom.find(".app-name");
        if (!e)
            return (
                t.classList.remove("show"),
                a.classList.remove("show"),
                (t.innerHTML = ""),
                void (
                    s.hideOtherSidebarContent &&
                    (i && i.classList.remove("hide"),
                    n && n.classList.remove("hide"))
                )
            );
        var e = o(e),
            r = "";
        e.forEach(function (e) {
            r +=
                '<div class="matching-post">\n<a href="' +
                e.url +
                '">\n<h2>' +
                e.title +
                "</h2>\n<p>" +
                e.content +
                "</p>\n</a>\n</div>";
        }),
            t.classList.add("show"),
            a.classList.add("show"),
            (t.innerHTML = r || '<p class="empty">' + c + "</p>"),
            s.hideOtherSidebarContent &&
                (i && i.classList.add("hide"), n && n.classList.add("hide"));
    }
    function l(e) {
        s = e;
    }
    function h(e, n) {
        var t,
            a,
            i = n.router.parse().query.s;
        l(e),
            Docsify.dom.style(
                "\n.sidebar {\n  padding-top: 0;\n}\n\n.search {\n  margin-bottom: 20px;\n  padding: 6px;\n  border-bottom: 1px solid #eee;\n}\n\n.search .input-wrap {\n  display: flex;\n  align-items: center;\n}\n\n.search .results-panel {\n  display: none;\n}\n\n.search .results-panel.show {\n  display: block;\n}\n\n.search input {\n  outline: none;\n  border: none;\n  width: 100%;\n  padding: 0.6em 7px;\n  font-size: inherit;\n  border: 1px solid transparent;\n}\n\n.search input:focus {\n  box-shadow: 0 0 5px var(--theme-color, #42b983);\n  border: 1px solid var(--theme-color, #42b983);\n}\n\n.search input::-webkit-search-decoration,\n.search input::-webkit-search-cancel-button,\n.search input {\n  -webkit-appearance: none;\n  -moz-appearance: none;\n  appearance: none;\n}\n\n.search input::-ms-clear {\n  display: none;\n  height: 0;\n  width: 0;\n}\n\n.search .clear-button {\n  cursor: pointer;\n  width: 36px;\n  text-align: right;\n  display: none;\n}\n\n.search .clear-button.show {\n  display: block;\n}\n\n.search .clear-button svg {\n  transform: scale(.5);\n}\n\n.search h2 {\n  font-size: 17px;\n  margin: 10px 0;\n}\n\n.search a {\n  text-decoration: none;\n  color: inherit;\n}\n\n.search .matching-post {\n  border-bottom: 1px solid #eee;\n}\n\n.search .matching-post:last-child {\n  border-bottom: 0;\n}\n\n.search p {\n  font-size: 14px;\n  overflow: hidden;\n  text-overflow: ellipsis;\n  display: -webkit-box;\n  -webkit-line-clamp: 2;\n  -webkit-box-orient: vertical;\n}\n\n.search p.empty {\n  text-align: center;\n}\n\n.app-name.hide, .sidebar-nav.hide {\n  display: none;\n}"
            ),
            (function (e) {
                void 0 === e && (e = "");
                var n = Docsify.dom.create(
                        "div",
                        '<div class="input-wrap">\n      <input type="search" value="' +
                            e +
                            '" aria-label="Search text" />\n      <div class="clear-button">\n        <svg width="26" height="24">\n          <circle cx="12" cy="12" r="11" fill="#ccc" />\n          <path stroke="white" stroke-width="2" d="M8.25,8.25,15.75,15.75" />\n          <path stroke="white" stroke-width="2"d="M8.25,15.75,15.75,8.25" />\n        </svg>\n      </div>\n    </div>\n    <div class="results-panel"></div>\n    </div>'
                    ),
                    e = Docsify.dom.find("aside");
                Docsify.dom.toggleClass(n, "search"), Docsify.dom.before(e, n);
            })(i),
            (n = Docsify.dom.find("div.search")),
            (a = Docsify.dom.find(n, "input")),
            (e = Docsify.dom.find(n, ".input-wrap")),
            Docsify.dom.on(n, "click", function (e) {
                return (
                    -1 === ["A", "H2", "P", "EM"].indexOf(e.target.tagName) &&
                    e.stopPropagation()
                );
            }),
            Docsify.dom.on(a, "input", function (n) {
                clearTimeout(t),
                    (t = setTimeout(function (e) {
                        return d(n.target.value.trim());
                    }, 100));
            }),
            Docsify.dom.on(e, "click", function (e) {
                "INPUT" !== e.target.tagName && ((a.value = ""), d());
            }),
            i &&
                setTimeout(function (e) {
                    return d(i);
                }, 500);
    }
    function x(e, n) {
        var t, a, i, r, o;
        l(e),
            (t = e.placeholder),
            (a = n.route.path),
            (r = Docsify.dom.getNode('.search input[type="search"]')) &&
                ("string" == typeof t
                    ? (r.placeholder = t)
                    : ((i = Object.keys(t).filter(function (e) {
                          return -1 < a.indexOf(e);
                      })[0]),
                      (r.placeholder = t[i]))),
            (e = e.noData),
            (o = n.route.path),
            (c =
                "string" == typeof e
                    ? e
                    : e[
                          Object.keys(e).filter(function (e) {
                              return -1 < o.indexOf(e);
                          })[0]
                      ]);
    }
    var w = {
        placeholder: "Type to search",
        noData: "No Results!",
        paths: "auto",
        depth: 2,
        maxAge: 864e5,
        hideOtherSidebarContent: !1,
        namespace: void 0,
        pathNamespaces: void 0,
    };
    $docsify.plugins = [].concat(function (e, n) {
        var t = Docsify.util,
            a = n.config.search || w;
        Array.isArray(a)
            ? (w.paths = a)
            : "object" == typeof a &&
              ((w.paths = Array.isArray(a.paths) ? a.paths : "auto"),
              (w.maxAge = (t.isPrimitive(a.maxAge) ? a : w).maxAge),
              (w.placeholder = a.placeholder || w.placeholder),
              (w.noData = a.noData || w.noData),
              (w.depth = a.depth || w.depth),
              (w.hideOtherSidebarContent =
                  a.hideOtherSidebarContent || w.hideOtherSidebarContent),
              (w.namespace = a.namespace || w.namespace),
              (w.pathNamespaces = a.pathNamespaces || w.pathNamespaces));
        var i = "auto" === w.paths;
        e.mounted(function (e) {
            h(w, n), i || r(w, n);
        }),
            e.doneEach(function (e) {
                x(w, n), i && r(w, n);
            });
    }, $docsify.plugins);
})();
