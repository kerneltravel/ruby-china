window.Suggester = 
  focusedSuggester : false
  focusedTextarea : false
  query : null
  
  init : () ->
    textareas = $("textarea[data-suggester-list]")    
    textareas.bind "keyup", (e) -> Suggester.onKeyUp(e)
    textareas.bind "focusin", (e) -> Suggester.onFocusIn(e)
    textareas.bind "focusout", (e) -> Suggester.onFocusOut(e)
    textareas.bind "navigation:keydown", (e) -> Suggester.onNavigationKeyDown(e)
    textareas.bind "navigation:open", (e) -> Suggester.onNavigationOpen(e)
    
  onFocusIn : (e) ->
    Suggester.focusTimeout && clearTimeout(Suggester.focusTimeout)
    Suggester.focusedTextarea = e.currentTarget
    Suggester.focusedSuggester = document.getElementById($(e.currentTarget).attr("data-suggester-list"))
    
  onFocusOut : (e) ->
    return Suggester.focusTimeout = setTimeout(() -> 
        return Suggester.deactivate()
        Suggester.focusedTextarea = Suggester.focusedSuggester = null
        Suggester.focusTimeout = null
    200)
    
  onNavigationKeyDown : (e) ->
    console.log "onNavigationKeyDown #{e.hotkey}"
    switch (e.hotkey)
      when "tab"
        return this.onNavigationOpen(e)
      when "esc"
        return this.deactivate()
      
  onNavigationOpen : (e) ->
    login = $(e.target).attr("data-user")
    console.log "onNavigationOpen #{login}"
    strStart = Suggester.focusedTextarea.value.substring(0, Suggester.focusedTextarea.selectionEnd)
    strEnd = Suggester.focusedTextarea.value.substring(Suggester.focusedTextarea.selectionEnd)
    strStart = strStart.replace(/@(\w*)$/, "@#{login} ")
    Suggester.focusedTextarea.value = strStart + strEnd
    this.deactivate()
    Suggester.focusedTextarea.focus()
    Suggester.focusedTextarea.selectionStart = strStart.length
    Suggester.focusedTextarea.selectionEnd = strStart.length
    false
    
  deactivate : (a, b) ->
    a == null && (a = Suggester.focusedTextarea)
    b == null && (b = Suggester.focusedSuggester)
    if (!$(b).is(".active")) 
      return
    $(b).removeClass("active")
    $(a).removeClass("js-navigation-enable")
    $(b).trigger("navigation:deactivate")
    
  activate : (a,b) ->
    if ($(b).is(".active")) 
      return
    if (!$(b).find("[data-user]")[0])
      return
    $(b).addClass("active")
   #  $(b).css($(a).selectionEndPosition())
    $(a).addClass("js-navigation-enable")
    $(b).trigger("navigation:focus")
    
  onKeyUp : (e) ->
    d = Suggester.focusedTextarea
    c = Suggester.focusedSuggester
    if (!Suggester.focusedTextarea || !Suggester.focusedSuggester) 
      return
    b = Suggester.searchQuery(d)
    if (b != null)
      if (b == Suggester.query) 
        return
      Suggester.query = b
      Suggester.activate(d, c)
      Suggester.search(c, this.query)
    Suggester.query = null
    this.deactivate()
    
  searchQuery: (text) ->
    strEnd = text.value.substring(0, text.selectionEnd)
    matched = strEnd.match(/(^|\s)@(\w*)$/)
    if matched then matched[2] else null
      
  search : (panel, queryText) ->
    ul = $(panel).find("ul")
    li = ul.children("li")
    li.sort (a, b) ->
      a_score = a.textContent.score(queryText)
      b_score = b.textContent.score(queryText)
      if a_score > b_score then -1 else
        if a_score < b_score then 1 else 0
    ul.append(li)
    li.hide().slice(0, 5).show()
    $(panel).trigger("navigation:focus")

    
