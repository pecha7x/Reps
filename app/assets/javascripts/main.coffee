report =
  init: ->
    _.templateSettings =  interpolate :/\{\{(.+?)\}\}/g
    @secondAnswer()
    @saveReport()
    @newReportShow()
    @showUserReport()

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
            $("#new-report-show").hide()
            $("#new_report").hide()
            $("#last_report").append "<div class='alert alert-success'>Report sent to your manager</div>"
            setTimeout "window.location.reload();", 3000

  newReportShow: ->
    $("#new-report-show").on "click", ->
      if $("#new_report").is(":visible")
        $("#new_report").hide()
        $(this).val "NEW REPORT"
      else
        $("#new_report").show()
        $(this).val "CANCEL"

  showUserReport: ->
    $("tr.report").on "click", ->
      $("tr.report").parent().find(".Check").css("backgroundColor", "white").css("border", "none").removeClass("Check")
      $(this).addClass("Check")
      $(this).css("backgroundColor", "#D1D1CD").css("border", "2px solid #0099FF");
      $("#userreport").empty()
      id_report = $(this).attr('id')
      listOfReports = []
      #NEED BLOCK CLICK EVENT LATER!
      $.ajax(
        type: "post"
        url: "/get_report.json"
        data: {
          id_report
        }
        dataType: "json"
      ).done (data) ->
        listOfReports.push({
          user : data.user,
          date : data.date
        })
        #load template for name and date
        resultingHtml = (_.template( $("#report-template").html(), report) for report in listOfReports)
        $("#userreport").append resultingHtml
        #load templates for questions and theirs answers
        _.each data.answers, (answers, question) ->
          quest = _.template( $("#report-template-quesion").html(), {question: question})
          $(quest).appendTo(".quest_answ")
          _.each answers, (answer) ->
            answ = _.template( $("#report-template-answer").html(), {answer: answer})
            q = $("#userreport").find(".answs").last()
            console.log q
            $(answ).appendTo($(q))
$ ->
  report.init()