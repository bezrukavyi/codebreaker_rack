$ ()->
  $("input[name='guess[]']").keyup (e) ->
    return unless e.which != 8 and !isNaN(String.fromCharCode(event.which))
    $(this).val('').val(String.fromCharCode(e.keyCode || e.charCode))
    wrapp = $(this).closest('.guess-list')
    field_index = $(this).closest('.guess-item').index()
    next_field = $('.guess-item', wrapp)[field_index + 1]
    $('input', next_field).focus()
