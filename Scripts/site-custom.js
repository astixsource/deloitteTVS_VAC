function isIE() {
    ua = navigator.userAgent;
    var is_ie = ua.indexOf("MSIE ") > -1 || ua.indexOf("Trident/") > -1;
    return is_ie;
}

function fnHelp() {
    $("#dvHelp").dialog({
        title: 'Help',
        modal: true,
       // height: 20,
        width: '60%',
        maxHeight: $(window).height() - 75
        //minHeight: 150
    });
}

$(window).on("load resize", function () {
    $("img.bg-img, img.info-bg").hide();

    var Uurl = $("img.bg-img").attr("src"),
        Wurl = $("img.info-bg").attr("src"),
        Fimg = $('.full-background'),
        WlcmBh = $('.grid-welcome-bg'),
        navbarH = $(".navbar").outerHeight() + "px";

    $(Fimg).css('backgroundImage', 'url(' + Uurl + ')');
    $(WlcmBh).css('backgroundImage', 'url(' + Wurl + ')');

    $('input[type="text"], input[type="password"]').focus(function () {
        $(this).data('placeholder', $(this).attr('placeholder')).attr('placeholder', '');
    }).blur(function () {
        $(this).attr('placeholder', $(this).data('placeholder'));
    });

    if (window.matchMedia("(max-width: 767px)").matches) {
        // The viewport is less than 768 pixels wide 
        $(".login-img").css({ marginTop: "25%", marginBottom: "1rem" });
        $(".login-logo").css({ width: "60%" });
        $(".loginfrm").css({ margin: "0 auto" });
    } else {
        // The viewport is at least 768 pixels wide
        $(".login-img").css({
            marginTop: ($(window).height() - $(".login-img").outerHeight()) / 2 + "px"
        });
        $(".loginfrm").css({
            marginTop: ($(window).height() - $(".loginfrm").outerHeight()) / 2 + "px"
            //'marginLeft': ($(window).width() - $('.loginfrm').outerWidth()) * 3 / 4 + "px"
        });
    }
    if (isIE()) {
        //alert('It is InternetExplorer');
        $("nav.navbar").css("display", "block"), $("img.logo").css("margin-top", "8px");
    } else {
        //alert('It is NOT InternetExplorer');
        $("nav.navbar").css("display", "flex");
    }

    $(".main-content").css({
        "min-height": $(window).height() - ($(".navbar").outerHeight() + 20)
        //"margin-top": navbarH
    });

   
});
