using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Bookseeker.classes;

namespace Bookseeker
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if(!IsPostBack)
            {
                Bookseeker _dbContext = new Bookseeker();

                //Get all genre options from Bookseeker entities Books Class
                IQueryable<String> genreList = (from books
                                                in _dbContext.Books
                                                select books.Genre);
                var list = genreList.ToList().Distinct();
                cmbGenre.Items.Add(new ListItem("--Select--", ""));
                foreach (string str in list)
                {
                    cmbGenre.Items.Add(new ListItem(str, str));
                }
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            //User ID = 0 for the time being
            RecommendationResults results = new RecommendationResults(0, cmbGenre.SelectedValue, txtThemes1.Text, chkPurchaseLinks.Checked, chkGRRatings.Checked);

            repResults.DataSource = results.GetResults();
            repResults.DataBind();
            
            divResults.Visible = true;
            updResults.Update();
        }

    }
}