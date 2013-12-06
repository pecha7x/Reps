report =
  init: ->
    _.templateSettings =  interpolate :/\{\{(.+?)\}\}/g
    @secondAnswer()
    @saveReport()
    @newReportShow()
    @showUserReport()
    @changeDayOfReport()
    @changeStatusEmployee()
    @addEmployeeSubmit()

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
          $("#result").prepend "<div class='alert alert-danger'>Not stored. It's happens..</div>"
        else
          $("#result").prepend "<div class='alert alert-success'>Day of report was changed</div>"
          setTimeout "$('.alert').hide();", 3000

  changeStatusEmployee: ->
    $('.change-status').on "click", ->
      status = $(this)
      user_id = $(this).parent().parent().attr('id')
      status_id = status.attr('id')

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
          $("#result").after "<div class='alert alert-danger'>Not stored. It's happens..</div>"
        else
          $("#result").after "<div class='alert alert-success'>User status was changed</div>"
          setTimeout "$('.alert').hide();", 1000
          if status_id == "ON"
            status.removeClass('status-on').addClass('status-off')
            status.attr("id","OFF")
          else
            status.removeClass('status-off').addClass('status-on')
            status.attr("id","ON")

  addEmployeeSubmit: ->
    $('#add-employee-submit').on "click", ->
      email = $('#add-employee').val()
      #validate email
      re = /[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/igm
      if !re.test(email)
        $(".alert").remove()
        return $("#result").after "<div class='alert alert-danger'>Please enter a valid address</div>"
      $.ajax(
        type: "post"
        url: "/invite_user.json"
        data: {
          email
        }
        dataType: "json"
      ).done (data) ->
        $(".alert").remove()
        if data.errors
          $("#result").after "<div class='alert alert-danger'>This user already exists in the team</div>"
        else
          $("#result").after "<div class='alert alert-success'>The user " + email + " was invited</div>"
          setTimeout "$('.alert').hide();", 4000
$ ->
  report.init()