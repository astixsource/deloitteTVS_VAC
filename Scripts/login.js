
function fnValidate() {
    document.getElementById("hdnResolution").value = screen.availWidth + "*" + screen.availHeight;
    if (document.getElementById("txtLoginID").value === "") {

        document.getElementById("dvMessage").innerText = "Login ID can't be left blank";
        document.getElementById("txtLoginID").focus();
        return false;
    }
    if (document.getElementById("txtPassword").value === "") {
        if (LngId === 1) {
            document.getElementById("dvMessage").innerText = "Password can't be left blank";
        }
        else {
            document.getElementById("dvMessage").innerText = "Password can't be left blank";
        }
        document.getElementById("txtPassword").focus();
        return false;
    }
}

function fnHideError() {
    document.getElementById("tblProgress").style.display = "none";
}
function fnKeyPress() {
    document.getElementById("dvMessage").innerText = "";
}

function fnForgotPwd() {
    $("#dvForgotPwd").dialog({
        modal: true,
        title: "Forgot Password",
        width: '400',
        height: 'auto'
    });
}

function fnSendResetLink() {
    $("#dvFadeForProcessing").css("display", "block");
    var userName = $("#txtUsernameForForgotPassword").val().trim();

    if (userName === "") {
        $("#dvFadeForProcessing").css("display", "none");
        $("#txtUsernameForForgotPassword").val("");
        $("#txtUsernameForForgotPassword").focus();
        alert("Please enter username first!");
        return false;
    }

    $.ajax({
        url: "eywebservice.asmx/fnGetUserdetailForResetLink",
        type: "POST",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: '{UserName:' + JSON.stringify(userName) + '}',
        success: function (response) {
            $("#dvFadeForProcessing").css("display", "none");
            var strRep = response.d;

            if (strRep.split("^")[0] == "1") {
               
                alert(strRep.split("^")[1]);
                $("#dvForgotPassword").dialog("close");
            

                window.location.href = 'Login.aspx'
                $("#txtLoginID").val("");
                $("#txtPassword").val("");
            }
            else {
                alert(strRep.split("^")[1]);
            }
        },
        error: function (msg) {
            $("#dvFadeForProcessing").css("display", "none");
            alert(msg.responseText);
        }
    });
}
var specialKeys = new Array();
specialKeys.push(8);  //Backspace
specialKeys.push(9);  //Tab
specialKeys.push(46); //Delete
specialKeys.push(36); //Home
specialKeys.push(35); //End
specialKeys.push(37); //Left
specialKeys.push(39); //Right

function RestrictSpaceSpecial(evt) {
    var keyCode = (evt.which) ? evt.which : evt.keyCode;
    if (keynum === 62 || keynum === 60)
        e.preventDefault();
}

function specialcharecter(cntrlId) {

    var iChars = "!`@#$%^&*()+=-[]\\\';,./{}|\":<>?~_";

    var data = document.getElementById(cntrlId).value;

    for (var i = 0; i < data.length; i++) {

        if (iChars.indexOf(data.charAt(i)) != -1) {
            return false;
        }
    }
    return true;
}
function specialcharecterAddress(cntrlId) {

    var iChars = "!`@#$%^&*+=[]\\\'{}|\":<>?~";

    var data = document.getElementById(cntrlId).value;

    for (var i = 0; i < data.length; i++) {

        if (iChars.indexOf(data.charAt(i)) != -1) {
            return false;
        }
    }
    return true;
}