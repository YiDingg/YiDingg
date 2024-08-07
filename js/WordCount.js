// https://www.npmjs.com/package/docsify-count

var defaultOptions = {
    countable: !0,
    position: "top",
    /* margin: "10px", */
    /* float: "left", */
    /* fontsize: "0.9em", */
    /* color: "rgb(170,170,170)", */
    language: "english",
    isExpected: !0,
};
function plugin(t, n) {
    if (!defaultOptions.countable) return;
    let o;
    t.beforeEach(function (t) {
        return (o = t.match(/([\u4e00-\u9fa5]+?|[a-zA-Z0-9]+)/g).length), t;
    }),
        t.afterEach(function (t, n) {
            let i = o + " words",
                e = Math.ceil(o / 400) + " min";
            "chinese" === defaultOptions.language &&
                ((i = o + " 字"), (e = Math.ceil(o / 400) + " 分钟")),
                n(
                    `\n ${
                        "bottom" === defaultOptions.position ? t : ""
                    }\n <div style="margin-bottom: 10px;">\n <span style="\n float: left;\n font-size: 0.75rem;\n color:rgb(170,170,170);padding-top:15px">\n ${i}\n ${
                        defaultOptions.isExpected ? `&nbsp; | &nbsp;${e}` : ""
                    }\n </span>\n <div style="clear: both"></div>\n </div>\n ${
                        "bottom" !== defaultOptions.position ? t : ""
                    }\n`
                );
        });
}
(window.$docsify.count = Object.assign(defaultOptions, window.$docsify.count)),
    (window.$docsify.plugins = [].concat(plugin, window.$docsify.plugins));
/* function plugin(t, n) {
    if (!defaultOptions.countable) return;
    let o;
    t.beforeEach(function (t) {
        return (o = t.match(/([\u4e00-\u9fa5]+?|[a-zA-Z0-9]+)/g).length), t;
    }),
        t.afterEach(function (t, n) {
            let i = o + " words",
                e = Math.ceil(o / 400) + " min";
            "chinese" === defaultOptions.language &&
                ((i = o + " 字"), (e = Math.ceil(o / 400) + " 分钟")),
                n(
                    `\n ${
                        "bottom" === defaultOptions.position ? t : ""
                    }\n <div style="margin-${
                        "bottom" === defaultOptions.position ? "bottom" : "top"
                    }: ${defaultOptions.margin};">\n <span style="\n float: ${
                        "right" === defaultOptions.float ? "right" : "left"
                    };\n font-size: ${defaultOptions.fontsize};\n color:${
                        defaultOptions.color
                    };">\n ${i}\n ${
                        defaultOptions.isExpected ? `&nbsp; | &nbsp;${e}` : ""
                    }\n </span>\n <div style="clear: both"></div>\n </div>\n ${
                        "bottom" !== defaultOptions.position ? t : ""
                    }\n        `
                );
        });
}
(window.$docsify.count = Object.assign(defaultOptions, window.$docsify.count)),(window.$docsify.plugins = [].concat(plugin, window.$docsify.plugins));
 */
