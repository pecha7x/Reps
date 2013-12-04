report =
  init: ->
    @secondAnswer()
    @saveReport()

  secondAnswer: ->
    $(".more-answer").on "click", ->
      parent_div = $(this).parent('div')
      num = parent_div.find("input").size()
      parent_answer = $(this).parent().attr("id")
      parent_div.find('input').last().after("<input type='text' class='form-control' name='" + parent_answer + "[" + num + "]' placeholder='Enter answer of question'/>");

  saveReport: ->
    $("#create-report-send").on "click", ->
      $(".alert").remove()
      answ = {}
      manager_id = ""
      params = $("#create-report-form").find("input").serializeArray()
      $.each params, (i, e) ->
        if e.value and e.name != "manager_id"
          answ[e.name] = e.value
        else if e.name is "manager_id"
          manager_id = e.value

      if $.isEmptyObject(answ)
        $("#create-report-form").append "<div class='alert alert-danger'>Please check your answers</div>"
        $("#create-report-form").prepend "<div class='alert alert-danger'>Please check your answers</div>"
      else
        $.ajax(
          type: "post"
          url: "/save_report.json"
          data: {
            answ,
            manager_id
          }
          dataType: "json"
        ).done (data) ->
          $(".alert").remove()
          if data.errors
            $(".container").prepend "<div class='alert alert-danger'>Please check your answers</div>"
          else
            window.location = "/"



$ ->
  report.init()