report =
  init: ->
    _.templateSettings =  interpolate :/\{\{(.+?)\}\}/g
    @secondAnswer()
    @saveReport()
    @newReportShow()
    @showUserReport()
    @changeDayOfReport()
    @changeStatusEmployee()

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
      mood = ""
      params = $("#create-report-form").find("input, select").serializeArray()
      $.each params, (i, e) ->
        if e.value and e.name != "manager_id" and e.name != "mood"
          answ[e.name] = e.value
        else if e.name is "manager_id"
          manager_id = e.value
        else if e.name is "mood"
          mood = e.value

      if $.isEmptyObject(answ)
        $("#create-report-form").append "<div class='alert alert-danger'>Please check your answers</div>"
        $("#create-report-form").prepend "<div class='alert alert-danger'>Please check your answers</div>"
      else
        $.ajax(
          type: "post"
          url: "/save_report.json"
          data: {
            answ,
            manager_id,
            mood
          }
          dataType: "json"
        ).done (data) ->
          $(".alert").remove()
          if data.errors
            $(".container").prepend "<div class='alert alert-danger'>Please check your answers</div>"
          else
            $("#new_report").hide()
            $("#new-report-show").after "<div class='alert alert-success'>Report was sended to your manager</div>"
            $("#new-report-show").hide()
            setTimeout "window.location.reload();", 3000

  newReportShow: ->
    $("#new-report-show").on "click", ->
      if $("#new_report").is(":visible")
        $("#new_report").hide()
        $(this).val "NEW REPORT"
        $("html, body").animate({ scrollTop: 0 }, 1000);
      else
        $("#new_report").show()
        $(this).val "CANCEL"
        $("html, body").animate({ scrollTop: $(document).height() }, 1000);

  showUserReport: ->
    $("tr.report").on "click", ->
      $("tr.report").parent().find(".Check").css("backgroundColor", "white").css("border", "none").removeClass("Check")
      $(this).addClass("Check")
      $(this).css("backgroundColor", "#D1D1CD").css("border", "2px solid #0099FF");
      $("#userreport").empty()
      id_report = $(this).attr('id')
      listOfReports = []
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
            $(answ).appendTo($(q))

  changeDayOfReport: ->
    $('.day_of_report').on "click", ->
      user_id = $(this).parent().parent().attr('id')
      optionSelected = $("option:selected", this);
      day = this.value;

      $.ajax(
        type: "post"
        url: "/change_employee.json"
        data: {
          user_id,
          day
        }
        dataType: "json"
      ).done (data) ->
        $(".alert").remove()
        if data.errors
          $(".container").prepend "<div class='alert alert-danger'>Not stored. It's happens..</div>"
        else
          $(".container").prepend "<div class='alert alert-success'>Day of report was changed</div>"
          setTimeout "$('.alert').hide();", 3000

  changeStatusEmployee: ->
    $('.change-status').on "click", ->
      status = $(this)
      user_id = $(this).parent().parent().attr('id')
      status_id = status.attr('name')

      $.ajax(
        type: "post"
        url: "/change_employee_status.json"
        data: {
          user_id,
          status_id
        }
        dataType: "json"
      ).done (data) ->
        $(".alert").remove()
        if data.errors
          $(".container").prepend "<div class='alert alert-danger'>Not stored. It's happens..</div>"
        else
          $(".container").prepend "<div class='alert alert-success'>User status was changed</div>"
          setTimeout "$('.alert').hide();", 1000
          console.log status
          if status_id == "ON"
            src = status.attr("src").replace("/assets/On.png", "/assets/Off.png");
            name = status.attr("name").replace("ON", "OFF");
          else
            src = status.attr("src").replace("/assets/Off.png", "/assets/On.png");
            name = status.attr("name").replace("OFF", "ON");

          status.attr("name", name);
          status.attr("src", src);

$ ->
  report.init()