window.Suggester =>
  initialize = () ->
    ""
    
  this.onNavigationOpen (el) ->
    $(el.target).attr("data-user")
    txtbox = this.focusedTextarea
    val2 = txtbox.value.substring(0, d.selectionEnd)
    val1 = txtbox.value.substring(d.selectionEnd)
    val2 = val2.replace(/@(\w*)$/, "@" + e + " ")
    txtbox.value = val2 + val1
    this.deactivate()
    txtbox.focus()
    txtbox.selectionStart = val2.length
    txtbox.selectionEnd = val2.length
    false 