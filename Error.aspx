<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Error.aspx.cs" Inherits="Error" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link href="Images/favicon.ico" rel="shortcut icon" type="image/x-icon" />
    <!-- Latest compiled and minified CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" crossorigin="anonymous">
    <style type="text/css">
        body {
            background-image: url(Images/bg-image.png);
        }
       .page-404 {
            padding: 40px 15px;
            text-align: center;
        }

            .page-404 h1 {
                color: #46a1f0;
                font-family: serif;
                font-size: 150px;
                font-weight: 400;
                line-height: .75;
                margin-bottom: 50px;
            }

            .page-404 h4 {
                color: #575757;
                font-family: serif;
                font-size: 80px;
                font-weight: 500;
                line-height: .75;
                margin-bottom: 0;
            }

        .circle-box {
            background: #eeeeee;
            color: #575757;
            width: 200px;
            height: 200px;
            border-radius: 50%;
            display: inline-block;
            padding-top: 48px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
       <div class="container-fluid">
            <div class="container">
                <div class="row">
                    <div class="col-md-6 col-md-offset-3">
                        <div class="page-404">
                            <h1>Oops!</h1>
                            <h3 class="text-uppercase">Something Went Wrong While Calling Spotmentor API</h3>
                            <p id="pError" runat="server">
                            Error: 
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
