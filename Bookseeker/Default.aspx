<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Bookseeker.Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Bookseeker</title>
    <link rel="stylesheet" type="text/css" href="styles/styles.css" />
    <link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css" />
    <script src="//code.jquery.com/jquery-1.10.2.js"></script>
    <script src="//code.jquery.com/ui/1.11.4/jquery-ui.js"></script>
    <script src="data/keywords.js"></script>
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
        
        <asp:ScriptManager ID="scriptManager" runat="server" />
        <asp:UpdatePanel ID="updResults" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
        <div id="divReqs">
            <h1>Enter your requirements</h1>
            <div id="divReqsLeft">
                <h2>Genre: <asp:DropDownList ID="cmbGenre" runat="server"></asp:DropDownList></h2>
                <h2><asp:CheckBox ID="chkPurchaseLinks" runat="server" Text="Show Purchase Links: " TextAlign="Left" Checked="true"/></h2>
                <h2><asp:CheckBox ID="chkGRRatings" runat="server" Text="Show Goodreads Ratings: " TextAlign="Left" Checked="true"/></h2>
            </div>
            <div id="divReqsRight">
                <h2>Themes/Content: <asp:TextBox ID="txtThemes1" runat="server"></asp:TextBox></h2>
                <h4>(Use the autocomplete feature for best results)</h4>
                <asp:Button ID="btnSubmit" OnClick="btnSubmit_Click" runat="server" Text="Get recommendations" />
            </div>
            <div id="divValidationMsg">
                <asp:RequiredFieldValidator ID="reqCmbGenre" runat="server" ControlToValidate="cmbGenre" InitialValue="" ErrorMessage="Please select a genre.<br />" ForeColor="Red"/>
                <asp:RequiredFieldValidator ID="reqTxtThemes1" runat="server" ControlToValidate="txtThemes1" ErrorMessage="Themes/Content is a required field." ForeColor="Red" />
            </div>
        </div>

        <%--Code taken from http://api.jqueryui.com/autocomplete/--%>
        <script>
            $("#txtThemes1").autocomplete({
                source: json
            });
        </script>

                <div class="divResults" id="divResults" runat="server" visible="false">
                    <h1>Results</h1>
                    <asp:Repeater ID="repResults" runat="server">
                        <ItemTemplate>
                        <div class="divResult">
                            <div class="divResultTopBar">
                                <h2>
                                    <asp:Literal runat="server" ID="litTitle" text='<%# DataBinder.Eval(Container.DataItem, "Title") %>' /> - 
                                    <asp:Literal runat="server" ID="litAuthor" text='<%# DataBinder.Eval(Container.DataItem, "Author") %>' />
                                </h2>
                            </div>
                            <div class="divResultBody">
                                <asp:HyperLink runat="server" NavigateUrl='<%# DataBinder.Eval(Container.DataItem, "GRUrl") %>'>
                                    <asp:Image runat="server" ID="imgURL" ImageUrl='<%# DataBinder.Eval(Container.DataItem, "ImgUrl") %>' />
                                </asp:HyperLink>
                                <p>Genre: <asp:Literal runat="server" ID="litGenre" text='<%# DataBinder.Eval(Container.DataItem, "Genre") %>' /><br />
                                Keywords: <asp:Literal runat="server" ID="litKeywords" text='<%# DataBinder.Eval(Container.DataItem, "Keywords") %>' /><br /><br />
                                <asp:Literal runat="server" ID="litDesc" text='<%# DataBinder.Eval(Container.DataItem, "Description") %>' /></p>
                                <div class="divResultBodyRight">
                                    <div id="divGRRatings" runat="server" visible='<%# DataBinder.Eval(Container.DataItem, "showGrRating") %>'>
                                        <h3>Goodreads avg user rating</h3>
                                        <h2><asp:Literal runat="server" ID="litRating" text='<%# DataBinder.Eval(Container.DataItem, "grRating") %>' /></h2>
                                    </div>
                                    <asp:Button ID="btnBuy" runat="server" Text="Buy from Amazon" visible='<%# DataBinder.Eval(Container.DataItem, "showPurchaseUrl") %>'/>
                                </div>
                            </div>
                        </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>

        <asp:UpdateProgress ID="updProg" AssociatedUpdatePanelID="updResults" runat="server">
            <ProgressTemplate>
                <div id="divLoading" runat="server" clientidmode="static">
                    <div>
                        <asp:Image ID="imgWaitIcon" runat="server" ImageUrl="./images/wait.gif" />
                        <p>Gathering Data...</p>
                    </div>
                </div>
            </ProgressTemplate>
        </asp:UpdateProgress>
    </form>
</body>
</html>
