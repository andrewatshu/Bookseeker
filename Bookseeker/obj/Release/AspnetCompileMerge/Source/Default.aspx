<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Bookseeker.Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Bookseeker</title>
    <link rel="stylesheet" type="text/css" href="styles/styles.css" />
</head>
<body>
    <div class="divHeader">
        <h1>Bookseeker</h1>
        <div id="divLogin" runat="server" visible="true">
            <asp:HyperLink ID="hypLogin" runat="server">Login | </asp:HyperLink>
            <asp:HyperLink ID="hypRegister" runat="server">Register</asp:HyperLink>
        </div>
        <div id="divLoggedIn" runat="server" visible="false">
            <p>Welcome <asp:Literal ID="litUserName" runat="server" /></p>
        </div>
    </div>

    <form id="formReqs" runat="server">
        <div id="divReqs">
            <h1>Enter your requirements</h1>
            <div id="divReqsLeft">
                <h2>Genre: <asp:DropDownList ID="cmbGenre" runat="server">
                    <asp:ListItem Value="1">Horror</asp:ListItem>
                    <asp:ListItem Value="2">Adventure</asp:ListItem>
                       </asp:DropDownList></h2>
                <h2><asp:CheckBox ID="chkPurchaseLinks" runat="server" Text="Purchase Links: " TextAlign="Left"/></h2>
                <h2><asp:CheckBox ID="chkGRRatings" runat="server" Text="Show Goodreads Ratings: " TextAlign="Left"/></h2>
            </div>
            <div id="divReqsRight">
                <h2>Themes/Content: <asp:TextBox ID="txtThemes1" runat="server"></asp:TextBox></h2>
                <h2>Themes/Content: <asp:TextBox ID="txtThemes2" runat="server"></asp:TextBox></h2>
                <asp:Button ID="btnSubmit" runat="server" Text="Get recommendations" />
            </div>
        </div>

        <asp:ScriptManager ID="scriptManager" runat="server" />
        <asp:UpdatePanel ID="updResults" runat="server">
            <ContentTemplate>
                <div class="divResults" runat="server"> <%--visible="false"--%>
                    <h1>Results</h1>
                    <div class="divResult">
                        <div class="divResultTopBar">
                            <h2>War & Peace - Leo Tolstoy</h2>
                        </div>
                        <div class="divResultBody">
                            <img src="http://d.gr-assets.com/books/1413215930l/656.jpg" />
                            <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
                            <div class="divResultBodyRight">
                                <h3>Goodreads avg user rating</h3>
                                <h2>4.10/5</h2>
                                <asp:Button ID="btnBuy" runat="server" Text="Buy from Amazon" />
                            </div>
                        </div>
                    </div>
                    <asp:Repeater ID="repResults" runat="server">
                    
                    </asp:Repeater>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </form>
</body>
</html>
