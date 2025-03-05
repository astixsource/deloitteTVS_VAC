
$(function () {
    $("#dvNewPwd").dialog({
        modal: true,
        title: "New Password Instruction",
        width: '36%',
        height: 'auto',
        dialogClass: "no-close",
        buttons: [
            {
                text: "OK",
                click: function () {
                    $(this).dialog("close");
                }
            }
        ]
    });

    //$("#dvNewPwd").hide();

    var showLaterButton = $("#hdnShowLaterButton").val();
    if (showLaterButton === "1") {
        $("#ctl00_CancelBtn").css("display", "");
    }
    else {
        $("#ctl00_CancelBtn").css("display", "none");
    }

    $(this).keyup(function (event) {
        if (event.which === 27) { // 27 is 'Ecs' in the keyboard
            disablePopup();  // function close pop up
        }
    });

    $("#txtConfirmPassword").keyup(function (event) {
        fnConfirmPasswordKeyup();
    });

    $("#txtNewPassword").keyup(function (event) {
        fnNewPasswordKeyup();
    });
    $("#ctl00_SubmitBtn").click(function () {
        fnChangePassword();  // function close pop up
    });

}); // jQuery End


history.pushState(null, null, document.URL);
window.addEventListener('popstate', function () {
    history.pushState(null, null, document.URL);
});

function fnlater() {
    var IsDistributor = document.getElementById("hdnIsDistributor").value;
    if (IsDistributor == 1) {
        window.location.href = 'manageorder/frmdefault.aspx';
    } else {
        window.location.href = 'default.aspx';
    }

}

function fnLogout() {
    window.location.href = "frmLogout.aspx"
}

function fnNewPwd() {
    $("#dvNewPwd").dialog({
        modal: true,
        title: "New Password Instruction",
        width: '30%',
        height: 'auto'
    });
}

function CheckPasswordOld(inputtxt) {
   // var paswd = /^(?=.*[0-9])(?=.*[!@#$%^*])[a-zA-Z0-9!@#$%^*]{8,15}$/;
    var paswd = /^(?=.*[0-9])(?=.*[!@#$*])[a-zA-Z0-9!@#$*]{8,15}$/;
      if (inputtxt.value.match(paswd)) {

        return true;
    }
    else {
        alert('Wrong Password Combination!!!,Kindly Enter Password As Per Guidance');
        return false;
    }
}

function fnNewPasswordKeyup() {
    if (CheckPassword($("#txtNewPassword")[0], false) == true) {
        $("#spanNewPassword").removeClass("glyphicon glyphicon-remove");
        $("#spanNewPassword").addClass("glyphicon glyphicon-ok");
        $("#spanNewPassword").css("color", 'green');
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

    if (ConfirmPassword != "" && NewPassword === ConfirmPassword) {
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

function IsChracterFound(text, charactersToFind) {
    for (i = 0; i < charactersToFind.length; i++) {
        if (text.indexOf(charactersToFind[i]) > -1) {
            return true
        }
    }
    return false;
}

function CheckPassword(inputTxt, showAlert) {
    var message = "";

    if (inputTxt.value.match(/^\d/)) {
        message = "Password must not start with a number!";
    }
    else if (IsChracterFound(inputTxt.value, '&^') == true) {
        message = "These 2 special characters & and ^ are not accepted";
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
    else if (IsChracterFound(inputTxt.value, '!$@%') == false) {
        message = "Atleast one special character (!$@%) is required!";
    }
    else if (inputTxt.value.length < 10) {
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

function fnChangePassword() {
    var UserName = $("#txtUserName").val();
    var OldPassword = $("#txtOldPassword").val();
    var NewPassword = $("#txtNewPassword").val();
    var ConfirmPassword = $("#txtConfirmPassword").val();
    if (OldPassword == "" || NewPassword == "") {
        alert("Password can't be blank!!!")
        return false;
    }

    if (CheckPassword($("#txtNewPassword")[0], true) == false) {
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
                    window.location.href = 'Login.aspx'
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
