function() {
    var a,
    b = function(a, b) {
        return function() {
            return a.apply(b, arguments)
        }
    };
    a = function() {
        function a() {
            this.onNavigationOpen = b(this.onNavigationOpen, this),
            this.onNavigationKeyDown = b(this.onNavigationKeyDown, this),
            this.onFocusOut = b(this.onFocusOut, this),
            this.onFocusIn = b(this.onFocusIn, this),
            this.onKeyUp = b(this.onKeyUp, this),
            $(document).on("keyup", "textarea[data-suggester-list]", this.onKeyUp),
            $(document).on("focusin", "textarea[data-suggester-list]", this.onFocusIn),
            $(document).on("focusout", "textarea[data-suggester-list]", this.onFocusOut),
            $(document).on("navigation:keydown", ".suggester [data-user]", this.onNavigationKeyDown),
            $(document).on("navigation:open", ".suggester [data-user]", this.onNavigationOpen),
            this.focusedTextarea = null,
            this.focusedSuggester = null
        }
        return a.prototype.onKeyUp = function(a) {
            var b,
            c,
            d;
            d = this.focusedTextarea,
            c = this.focusedSuggester;
            if (!this.focusedTextarea || !this.focusedSuggester) return;
            b = this.searchQuery(d);
            if (b != null) {
                if (b === this.query) return;
                return this.query = b,
                this.activate(d, c),
                this.search(c, this.query),
                !1
            }
            this.query = null,
            this.deactivate()
        },
        a.prototype.onFocusIn = function(a) {
            return this.focusTimeout && clearTimeout(this.focusTimeout),
            this.focusedTextarea = a.currentTarget,
            this.focusedSuggester = document.getElementById($(a.currentTarget).attr("data-suggester-list"))
        },
        a.prototype.onFocusOut = function(a) {
            var b = this;
            return this.focusTimeout = setTimeout(function() {
                return b.deactivate(),
                b.focusedTextarea = b.focusedSuggester = null,
                b.focusTimeout = null
            },
            200)
        },
        a.prototype.onNavigationKeyDown = function(a) {
            switch (a.hotkey) {
            case "tab":
                return this.onNavigationOpen(a),
                !1;
            case "esc":
                return this.deactivate(),
                !1
            }
        },
        a.prototype.onNavigationOpen = function(a) {
            var b,
            c,
            d,
            e;
            return e = $(a.target).attr("data-user"),
            d = this.focusedTextarea,
            c = d.value.substring(0, d.selectionEnd),
            b = d.value.substring(d.selectionEnd),
            c = c.replace(/@(\w*)$/, "@" + e + " "),
            d.value = c + b,
            this.deactivate(),
            d.focus(),
            d.selectionStart = c.length,
            d.selectionEnd = c.length,
            !1
        },
        a.prototype.activate = function(a, b) {
            if ($(b).is(".active")) return;
            if (!$(b).find("[data-user]")[0]) return;
            return $(b).addClass("active"),
            # $(b).css($(a).selectionEndPosition()),
            $(a).addClass("js-navigation-enable"),
            $(b).trigger("navigation:focus")
        },
        a.prototype.deactivate = function(a, b) {
            a == null && (a = this.focusedTextarea),
            b == null && (b = this.focusedSuggester);
            if (!$(b).is(".active")) return;
            return $(b).removeClass("active"),
            $(a).removeClass("js-navigation-enable"),
            $(b).trigger("navigation:deactivate")
        },
        a.prototype.searchQuery = function(a) {
            var b,
            c;
            c = a.value.substring(0, a.selectionEnd),
            b = c.match(/(^|\s)@(\w*)$/);
            if (b) return b[2]
        },
        a.prototype.search = function(a, b) {
            var c,
            d;
            return d = $(a).find("ul"),
            c = d.children("li"),
            c.sort(function(a, c) {
                var d,
                e;
                return d = a.textContent.score(b),
                e = c.textContent.score(b),
                d > e ? -1: d < e ? 1: 0
            }),
            d.append(c),
            c.hide().slice(0, 5).show(),
            $(a).trigger("navigation:focus")
        },
        a
    } (),
    new a
}.call(this),