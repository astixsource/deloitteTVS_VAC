/* 
author: istockphp.com
*/
jQuery(function ($) {

    $(".clktopopup").click(function () {

        loading(); // loading
        setTimeout(function () { // then show popup, deley in .5 second
            loadPopup(); // function show popup 
        }, 50); // .5 second
        return false;
    });

    /* event for close the popup */
    //$("div.close").hover(
    //				function () {
    //				    $('span.ecs_tooltip').show();
    //				},
    //				function () {
    //				    $('span.ecs_tooltip').hide();
    //				}
    //			);

    $("div.close").click(function () {
        disablePopup();  // function close pop up
    });

    $("div.close1").click(function () {
        disablePopup1();  // function close pop up
    });

    $(this).keyup(function (event) {
        if (event.which == 27) { // 27 is 'Ecs' in the keyboard
            disablePopup();  // function close pop up
        }
    });

    $("#txtConfirmPassword").keyup(function (event) {
        fnConfirmPasswordKeyup();
    });

    $("#txtNewPassword").keyup(function (event) {
        fnNewPasswordKeyup();
    });

    $("div#backgroundPopup").click(function () {
        disablePopup();  // function close pop up
    });

    //$('a.livebox').click(function () {
    //    alert('Hello World!');
    //    return false;
    //});


    /************** start: functions. **************/
    function loading() {
        $("div.loader").show();
    }
    function closeloading() {
        $("div.loader").fadeOut('normal');
    }

    var popupStatus = 0; // set value

    function loadPopup() {
        if (popupStatus == 0) { // if value is 0, show popup
            closeloading(); // fadeout loading
            $("#txtOldPassword").val("");
            $("#txtNewPassword").val("");
            $("#txtConfirmPassword").val("");
            $(".toPopup-new").fadeIn(0500); // fadein popup div
            $("#backgroundPopup").css("opacity", "0.7"); // css opacity, supports IE7, IE8
            $("#backgroundPopup").fadeIn(0001);
            popupStatus = 1; // and set value to 1
        }
    }

    function disablePopup() {
        if (popupStatus == 1) { // if value is 1, close popup
            $(".toPopup-new").fadeOut("normal");
            $("#backgroundPopup").fadeOut("normal");
            popupStatus = 0;  // and set value to 0
        }
    }

    function disablePopup1() {
        $(".toPopup-new").fadeOut("normal");
        $("#backgroundPopup").fadeOut("normal");
        popupStatus = 0;  // and set value to 0
    }
    /************** end: functions. **************/

    function CheckPasswordOld(inputtxt) {
        var paswd = /^(?=.*[0-9])(?=.*[!@#$%^*])[a-zA-Z0-9!@#$%^*]{8,15}$/;
        if (inputtxt.value.match(paswd)) {

            return true;
        }
        else {
            alert('Wrong Password Combination!!!,Kindly Enter Password As Per Guidance');
            return false;
        }
    }

    function fnNewPasswordKeyup() {
        if (CheckPassword($("#txtNewPassword")[0], false) ==true) {
            $("#spanNewPassword").removeClass("glyphicon glyphicon-remove");
            $("#spanNewPassword").addClass("glyphicon glyphicon-ok");
            $("#spanNewPassword").css("color",'green');
        }
        else {
            $("#spanNewPassword").removeClass("glyphicon glyphicon-ok");
            $("#spanNewPassword").addClass("glyphicon glyphicon-remove");
            $("#spanNewPassword").css("color", 'red');
        }

        var ConfirmPassword = $("#txtConfirmPassword").val();
        if (ConfirmPassword != "") {
            fnConfirmPasswordKeyup();
        }
    }

    function fnConfirmPasswordKeyup() {
        var NewPassword = $("#txtNewPassword").val();
        var ConfirmPassword = $("#txtConfirmPassword").val();

        if (ConfirmPassword !="" && NewPassword === ConfirmPassword) {
            $("#spanConfirmPassword").removeClass("glyphicon glyphicon-remove");
            $("#spanConfirmPassword").addClass("glyphicon glyphicon-ok");
            $("#spanConfirmPassword").css("color", 'green');
        }
        else {
            $("#spanConfirmPassword").removeClass("glyphicon glyphicon-ok");
            $("#spanConfirmPassword").addClass("glyphicon glyphicon-remove");
            $("#spanConfirmPassword").css("color", 'red');
        }
    }

    function IsChracterFound(text,charactersToFind) {
        for (i = 0; i < charactersToFind.length; i++) {
            if (text.indexOf(charactersToFind[i]) > -1) {
                return true
            }
        }
        return false;
    }

    function CheckPassword(inputTxt,showAlert) {
        var message = "";

        if (inputTxt.value.match(/^\d/)) {
            message = "Password must not start with a number!";
        }
        else if (inputTxt.value.match(/[A-Z]/g) == null) {
            message = "Atleast one uppercase character is required!";
        }
        else if (inputTxt.value.match(/[a-z]/g) == null) {
            message = "Atleast one lowercase character is required!";
        }
        else if ((inputTxt.value.match(/\d/g) || []).length < 2) {
            message = "Minimum two numerical characters are required!";
        }
        else if (IsChracterFound(inputTxt.value,'!$@%')==false) {
            message = "Atleast one special character (!$@%) is required!";
        }
        else if (inputTxt.value.length <10) {
            message = "Mininum password length is 10 characters!";
        }
        else if (inputTxt.value.split("").reverse().join("").match(/^\d/)) {
            message = "Password must not end with a number!";
        }

        if (message == "") {
            return true;
        }
        else {
            if (showAlert == true) {
                alert(message);
            }
            return false;
        }
    }

    $("#ctl00_CancelBtn").click(function () {
        disablePopup(); // function close pop up
    });
    $("#ctl00_SubmitBtn").click(function () {
        fnChangePassword();  // function close pop up
    });
    function fnChangePassword() {
       
        var UserName = $("#txtUserName").val();
        var OldPassword = $("#txtOldPassword").val();
        var NewPassword = $("#txtNewPassword").val();
        var ConfirmPassword = $("#txtConfirmPassword").val();
        if (OldPassword == "" || NewPassword == "") {
            alert("Password can't be blank!!!")
            return false;
        }

        if (CheckPassword($("#txtNewPassword")[0],true) == false) {
            return false;
        }

        if (OldPassword === NewPassword) {
            alert("New password can not be same as old password!!!")
            return false;
        }

        if (ConfirmPassword == "") {
            alert("Please confirm password!!!")
            return false;
        }

        if (NewPassword !== ConfirmPassword) {
            alert("Confirm Password Not Matched With New Passowrd!!!")
            return false;
        }
        $.ajax({
            url: "eywebservice.asmx/fnChangePassword",
            type: "POST",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            data: '{UserName:' + JSON.stringify(UserName) + ',OldPassword:' + JSON.stringify(OldPassword) + ',NewPassword:' + JSON.stringify(NewPassword) + '}',
            success: function (response) {
                var strRep = response.d;
                if (strRep.split("^")[0] == "2") {
                    alert("Error-" + strRep.split("^")[1]);
                } else {
                    var str = strRep.split("^")[1];
                    if (str.split("-")[0] == "1" && str.split("-")[1] == "0") {
                        alert("Password Changed Successfully,You can login again!!");
                        //fnlater();
                        $("#txtOldPassword").val("");
                        $("#txtNewPassword").val("");
                        $("#txtConfirmPassword").val("");
                        window.location.href = 'AssessorLogin.aspx'
                    }
                    else if (str.split("-")[0] == "0" && str.split("-")[1] == "1") {
                        alert("Changed password can not be same as previously used passwords!");
                        $("#txtNewPassword").val("");
                        $("#txtConfirmPassword").val("");
                    }
                    else {
                        alert("Wrong Username or Password!!");
                    }
                }
            },
            error: function (msg) {
                alert(msg.responseText);
            }
        });
    }
}); // jQuery End