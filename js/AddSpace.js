$docsify.plugins = [].concat(function (n) {
    n.init(function (n) {
        var c;
        ((c = document.createElement("script")).async = !0),
            (c.src = "https://gcore.jsdelivr.net/npm/pangu"),
            document.body.appendChild(c);
    }),
        n.doneEach(function (n) {
            try {
                pangu.spacingElementByClassName("content");
            } catch (n) {}
        });
}, $docsify.plugins);
