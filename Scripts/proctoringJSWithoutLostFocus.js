var cntLost = 0;
document.addEventListener("visibilitychange", function () {
    if (document.hidden) {
        if (cntLost == 0) {
            cntLost = 1;
            console.log("User switched tab or minimized browser");
            fnShowDialogAlertMain("Tab switched or window minimized", "You have switched tab! You will be logged out.");
        }
        // Send an alert or log this event
    } else {
        console.log("User is back on the tab");
    }
});
function fnShowDialogAlertMain(ViolationText, displaymsg) {
    document.title = ViolationText;
    $("#dvDialogalert").html("<br>" + displaymsg);
    $("#dvDialogalert").dialog({
        title: "Warning",
        modal: true,
        open: function (event, ui) {
            $(".ui-dialog-titlebar-close", $(this).parent()).hide();
        },
        close: function () {
            $(this).html("");
            $(this).dialog("destroy");
        },
        buttons: {
            "OK": function () {
                document.title = "Assessment";
                $(this).dialog("close");
                let url = window.location.href;
                let ViolationAt = url.split('.aspx')[0] + ".aspx";
                $.ajax({
                    url: "../../WebService.asmx/fnSaveAssessmentViolationByParticipants",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    data: '{ViolationText:' + JSON.stringify(ViolationText) + ',ViolationAt:' + JSON.stringify(ViolationAt) + '}',
                    success: function (response) {
                        window.location.href = "../../Login.aspx";
                    },
                    error: function (msg) {
                        window.location.href = "../../Login.aspx";
                    }
                });
            }
        }
    });
    return false;
}
//window.addEventListener("blur", function () {
//    if (cntLost == 0) {
//        cntLost = 1;
//        console.log("Window lost focus!");
//        alert("You switched windows! You will be logged out.");
//        window.location.href = "../../Login.aspx";
//    }
//});